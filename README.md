# DevOps
The IJELO DevOps deployment environment allows you to quickly install a VM on your local [VirtualBox](https://www.virtualbox.org) system with [Packer](https://www.packer.io/) and [Vagrant](https://www.vagrantup.com/).

## Requirements

Tested on macOS HighSierra 10.13.3.

You need command line tools installed, open terminal and execute:

`xcode-select --install`

### Install the following applications

Download and install [VirtualBox](https://www.virtualbox.org/wiki/Downloads)

Download and install [Vagrant](https://releases.hashicorp.com/vagrant/2.0.3/vagrant_2.0.3_x86_64.dmg) 

Download and install [Packer](https://releases.hashicorp.com/packer/1.2.1/packer_1.2.1_darwin_amd64.zip)


### Run example

From the cloned root directory:

`cd centos7-example`

`make all`

After around 15 minutes a freshly baked VM is available on your VirtualBox system, login to the system and have fun.

`make ssh`

### Security Considerations about the example

The kickstartfile configuration uses some hard coded stuff like username and password actually, they are the vagrant defaults. This is true for the bootstrapfile as well, that uses the well-known insecure public key from Vagrant.

Make sure when using in live- or production environments that these values are replaced by the ones issued by your sysadmin or your security officer.

