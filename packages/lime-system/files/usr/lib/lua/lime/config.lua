#!/usr/bin/lua

--! LibreMesh is modular but this doesn't mean parallel, modules are executed
--! sequencially, so we don't need to worry about transactionality and all other
--! stuff that affects parrallels database, at moment we don't need parallelism
--! as this is just some configuration stuff and is not performance critical.

local fs = require("nixio.fs")
local libuci = require("uci")

config = {}

function config.log(...)
	print(...)
end

config.uci = nil
config.hooksDir = "/etc/hotplug.d/lime-config"

function config.get_uci_cursor()
	if config.uci == nil then
		config.uci = libuci:cursor()
	end
	return config.uci
end

function config.set_uci_cursor(cursor)
	config.uci = cursor
end

config.uci = config.get_uci_cursor()

config.UCI_AUTOGEN_NAME = 'lime-autogen'
config.UCI_NODE_NAME = 'lime-node'
config.UCI_NETWORK_NAME = 'lime-network'
config.UCI_FACTORY_NAME = 'lime-defaults-factory'
config.UCI_CONFIG_NAME = config.UCI_AUTOGEN_NAME

function config.get_config_path()
	return config.uci:get_confdir() .. '/' .. config.UCI_CONFIG_NAME
end

--! Minimal /etc/config/lime santitizing
function config.sanitize()
	local lime_path = config.get_config_path()
	local cf = io.open(lime_path, "r")
	if (cf == nil) then
		cf = io.open(lime_path, "w")
		cf:write("")
	end
	cf:close()

	for _,sectName in pairs({"system","network","wifi"}) do
		config.set(sectName, "lime")
	end
end

function config.get(sectionname, option, fallback)
	local limeconf = config.uci:get(config.UCI_CONFIG_NAME, sectionname, option)
	if limeconf then return limeconf end

	if ( fallback ~= nil ) then
		config.log("Use fallback value for "..sectionname.."."..option..": "..tostring(fallback))
		return fallback
	else
		config.log("WARNING: Attempt to access undeclared default for: "..sectionname.."."..option)
		config.log(debug.traceback())
		return nil
	end
end

--! Execute +callback+ for each config of type +configtype+ found in
--! +/etc/config/lime-autogen+.
function config.foreach(configtype, callback)
	return config.uci:foreach(config.UCI_CONFIG_NAME, configtype, callback)
end

function config.get_all(sectionname)
	return config.uci:get_all(config.UCI_CONFIG_NAME, sectionname)
end

function config.get_bool(sectionname, option, default)
	local val = config.get(sectionname, option, default)
	return (val and ((val == '1') or (val == 'on') or (val == 'true') or (val == 'enabled') or (val == 1) or (val == true)))
end

config.batched = false

function config.init_batch()
	config.batched = true
end

function config.set(...)
	local aty = type(arg[3])
	if (aty ~= "nil" and aty ~= "string" and aty ~= "table") then
		arg[3] = tostring(arg[3])
	end
	config.uci:set(config.UCI_CONFIG_NAME, unpack(arg))
	if(not config.batched) then config.uci:save(config.UCI_CONFIG_NAME) end
end

function config.delete(...)
	config.uci:delete(config.UCI_CONFIG_NAME, unpack(arg))
	if(not config.batched) then config.uci:save(config.UCI_CONFIG_NAME) end
end

function config.end_batch()
	if(config.batched) then
		config.uci:save(config.UCI_CONFIG_NAME)
		config.batched = false
	end
end

function config.autogenerable(section_name)
	return ( (not config.get_all(section_name)) or config.get_bool(section_name, "autogenerated") )
end


--! Merge two uci files. If an option exists in both files the value of high_prio is selected
function config.uci_merge_files(high_prio, low_prio, output)
	local uci = config.get_uci_cursor()

	local high_pt = uci:get_all(high_prio)
	local low_pt = uci:get_all(low_prio)

	--! populate high_prio with low_prio values that are not in high_prio
	for section_name, section in pairs(low_pt) do
		local high_section = high_pt[section_name]
		if high_section ~= nil then
			--! copy only some attributes
			for option_name, option in pairs(section) do
				--! if the options starts with a dot it is not a real options it is an attribute
				--! like .name, .type, .anonymous and .index
				if option_name[1] ~= '.' and high_section[option_name] == nil then
					high_section[option_name] = option
				end
			end
		else
			high_pt[section_name] = section
		end
	end

	--! populate output from high_prio using uci
	for section_name, section in pairs(high_pt) do
		local section_type = section['.type']
		uci:set(output, section_name, section_type)
		for option_name, option in pairs(section) do
		--! if the options starts with a dot it is not a real options it is an attribute
		--! like .name, .type, .anonymous and .index
			if option_name[1] ~= '.' then
				local otype = type(option)
				if (otype ~= "nil" and otype ~= "string" and otype ~= "table") then
					option = tostring(option)
				end
				uci:set(output, section_name, option_name, option)
			end
		end
	end
	uci:commit(output)
end

function config.uci_autogen()
	--! start clearing the config
	local f = io.open(config.get_config_path(), "w")
	f:write('')
	f:close()

	for _, cfg_name in pairs({config.UCI_FACTORY_NAME, config.UCI_NETWORK_NAME, config.UCI_NODE_NAME}) do
		local cfg = io.open(config.uci:get_confdir() .. '/' .. cfg_name)
		if cfg ~= nil then
			config.uci_merge_files(cfg_name, config.UCI_AUTOGEN_NAME, config.UCI_AUTOGEN_NAME)
		end
	end
end

function config.main()
	config.sanitize()
	config.uci_autogen()

	local modules_name = { "hardware_detection", "wireless", "network", "firewall", "system" }
	local modules = {}

	for i, name in pairs(modules_name) do modules[i] = require("lime."..name) end
	for _,module in pairs(modules) do
		xpcall(module.clean, function(errmsg) print(errmsg) ; print(debug.traceback()) end)
	end

	for _,module in pairs(modules) do
		xpcall(module.configure, function(errmsg) print(errmsg) ; print(debug.traceback()) end)
	end

	for hook in fs.dir(config.hooksDir) do
		local hookCmd = config.hooksDir.."/"..hook.." after"
		print("executed hook:", hookCmd, os.execute(hookCmd))
	end
end

return config
