[![travis](https://api.travis-ci.org/libremesh/lime-packages.svg?branch=develop)](https://travis-ci.org/libremesh/lime-packages)
[![Backers on Open Collective](https://opencollective.com/libremesh/backers/badge.svg)](#backers) 
[![Sponsors on Open Collective](https://opencollective.com/libremesh/sponsors/badge.svg)](#sponsors) 
[![codecov.io](http://codecov.io/github/libremesh/lime-packages/branch/master/graphs/badge.svg)](http://codecov.io/github/libremesh/lime-packages)

# [LibreMesh][5] packages

[![LibreMesh logo](https://raw.githubusercontent.com/libremesh/lime-web/master/logo/logo.png)](https://libremesh.org)

[LibreMesh project][5] includes the development of several tools used for deploying libre/free mesh networks.

The firmware (the main piece) will allow simple deployment of auto-configurable,
yet versatile, multi-radio mesh networks. Check the [Network Architecture][4] to
see the basic ideas.

We encourage each network community to create its firmware profile on
[network-profiles][10] repository and build the images locally.


## Supported hardware

[In this page][1] we provide a list of requirements that ensure you to have a working LibreMesh node on your router.
This list comes with no warranties: read carefully the [model-specific instructions on OpenWrt wiki][2] and be extra-careful when flashing your routers!


## Building a Firmware Image on Your PC

The LibreMesh firmware can be compiled by following [these instructions][13].


## Run a linux development environment

Download the Source Code
git clone [https://github.com/libremesh/lime-packages.git]
cd lime-packages

On an Ubuntu system, the following command will install the minimum compilation dependencies:

sudo apt update
sudo apt install --no-install-recommends git ca-certificates subversion wget make gcc g++ libncurses5-dev gawk unzip file patch python3-distutils python3-minimal python2-minimal libpython2-stdlib

Install qemu

sudo apt-get install qemu qemu-utils qemu-kvm virt-manager libvirt-daemon-system libvirt-clients bridge-utils virt-manager virt-viewer libvirt-bin

Download compiled images
[https://repo.librerouter.org/lros/releases/1.4/targets/x86/64/]

In the lime-packages dir run:
 sudo ./tools/qemu_dev_start /DIRECTORY/YOURUSER/Downloads/librerouteros-1.4-r11343+1-73adbf987f-x86-64-generic-rootfs.tar.gz /DIRECTORY/YOURUSER/Downloads/librerouteros-1.4-r11343+1-73adbf987f-x86-64-ramfs.bzImage 


It will show you: 

BusyBox v1.30.1 () built-in shell (ash)

  _______                     ________        __
 |       |.-----.-----.-----.|  |  |  |.----.|  |_
 |   -   ||  _  |  -__|     ||  |  |  ||   _||   _|
 |_______||   __|_____|__|__||________||__|  |____|
          |__| W I R E L E S S   F R E E D O M
 -----------------------------------------------------
 LibreRouterOs 1.4, r11343+1-73adbf987f
 -----------------------------------------------------
  ___   __ __                _______             __
 |   |_|__|  |--.----.-----.|   |   |-----.-----|  |--.
 |     |  |  _  |   _|  -__||       |  -__|__ --|     |
 |_____|__|_____|__| |_____||__|_|__|_____|_____|__|__|

 ------------------------------------------------------
 LiMe 9654a168273c94d5f9c307266ab75f58a57fa860 development (9654a168273c94d5f9c)
 ------------------------------------------------------
 https://libremesh.org
 ------------------------------------------------------

 === System Notes =================================================

 = edit via http://thisnode.info/app/#/notes or /etc/banner.notes =

=== WARNING! =====================================
There is no root password defined on this device!
Use the "passwd" command to set up a new password
in order to prevent unauthorized SSH logins.
--------------------------------------------------
root@(none):/# 


Finally open [http://10.13.0.1/] in your favorite browser

If it gives an error qemu-system-x86_64: -enable-kvm: unsupported machine type. Use -machine help to list supported machines

just edit the file  /tools/qemu_dev_start.sh
erase the following line and re-run 
-enable-kvm



## Testing

LibreMesh has unit tests that help us add new features while keeping maintenance effort contained.

To run the tests simply execute `./run_tests`.

Please read the [[Unit Testing Guide](TESTING.md)] for more details about testing and how to add tests to LibreMesh.

## Get in Touch with LibreMesh Community

### Mailing Lists

The project has a main mailing list [lime-users@lists.libremesh.org][8] and an Element (#libremesh-dev:matrix.guifi.net) bridged on IRC (#libremesh-dev on Freenode) chat room, check out this page for how to join the chatroom:


### Contributors

This project exists thanks to all the people who contribute. [[Contribute](CONTRIBUTING.md)].
<a href="https://github.com/libremesh/lime-packages/graphs/contributors"><img src="https://opencollective.com/libremesh/contributors.svg?width=890&button=false" /></a>


### Donations

We are now a member of [open collective][12], please consider a small donation!

#### Backers

Thank you to all our backers! 🙏 [[Become a backer](https://opencollective.com/libremesh#backer)]

<a href="https://opencollective.com/libremesh#backers" target="_blank"><img src="https://opencollective.com/libremesh/backers.svg?width=890"></a>


#### Sponsors

Support this project by becoming a sponsor. Your logo will show up here with a link to your website. [[Become a sponsor](https://opencollective.com/libremesh#sponsor)]

<a href="https://opencollective.com/libremesh/sponsor/0/website" target="_blank"><img src="https://opencollective.com/libremesh/sponsor/0/avatar.svg"></a>
<a href="https://opencollective.com/libremesh/sponsor/1/website" target="_blank"><img src="https://opencollective.com/libremesh/sponsor/1/avatar.svg"></a>
<a href="https://opencollective.com/libremesh/sponsor/2/website" target="_blank"><img src="https://opencollective.com/libremesh/sponsor/2/avatar.svg"></a>
<a href="https://opencollective.com/libremesh/sponsor/3/website" target="_blank"><img src="https://opencollective.com/libremesh/sponsor/3/avatar.svg"></a>
<a href="https://opencollective.com/libremesh/sponsor/4/website" target="_blank"><img src="https://opencollective.com/libremesh/sponsor/4/avatar.svg"></a>
<a href="https://opencollective.com/libremesh/sponsor/5/website" target="_blank"><img src="https://opencollective.com/libremesh/sponsor/5/avatar.svg"></a>
<a href="https://opencollective.com/libremesh/sponsor/6/website" target="_blank"><img src="https://opencollective.com/libremesh/sponsor/6/avatar.svg"></a>
<a href="https://opencollective.com/libremesh/sponsor/7/website" target="_blank"><img src="https://opencollective.com/libremesh/sponsor/7/avatar.svg"></a>
<a href="https://opencollective.com/libremesh/sponsor/8/website" target="_blank"><img src="https://opencollective.com/libremesh/sponsor/8/avatar.svg"></a>
<a href="https://opencollective.com/libremesh/sponsor/9/website" target="_blank"><img src="https://opencollective.com/libremesh/sponsor/9/avatar.svg"></a>

[1]: https://libremesh.org/docs/hardware/
[2]: https://openwrt.org/toh/start
[4]: https://libremesh.org/howitworks.html
[5]: https://libremesh.org/
[8]: https://lists.libremesh.org/mailman/listinfo/lime-users
[10]: https://github.com/libremesh/network-profiles/
[12]: https://opencollective.com/libremesh
[13]: https://libremesh.org/development.html
