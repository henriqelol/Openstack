sudo apt-get update & sudo apt-get dist-upgrade & sudo apt-get autoremove
sudo apt-get -y install gcc make linux-headers-$(uname -r) dkms
wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
sudo sh -c 'echo "deb http://download.virtualbox.org/virtualbox/debian $(lsb_release -sc) contrib" >> /etc/apt/sources.list'
sudo apt-get update
sudo apt-get install virtualbox-5.2

wget http://releases.ubuntu.com/16.04/ubuntu-16.04.4-server-amd64.iso

#Criando VM - VBoxManage
https://www.oracle.com/technetwork/articles/servers-storage-admin/manage-vbox-cli-2264359.html

==============================
sudo su
mkdir -p /var/vbox

==========Controller==========
VBoxManage createvm --name Controller --ostype "Ubuntu_64" --register --basefolder /var/vbox
VBoxManage modifyvm Controller --cpus 4 --memory 10240 --vram 9
VBoxManage modifyvm Controller --nic1 nat
VBoxManage modifyvm Controller --natpf1 "ssh, tcp, 127.0.0.1,2222, 10.0.2.15, 22"
VBoxManage modifyvm Controller --nic2 hostonly --hostonlyadapter2 vboxnet0
VBoxManage modifyvm Controller --nic3 bridged --bridgeadapter3 enp1s0f0
VBoxManage createhd --filename /var/box/Controller.vdi --size 40000 --format VDI --variant Standard
VBoxManage storagectl Controller --name "Controller SATA" --add sata --bootable on
VBoxManage storageattach Controller --storagectl "Controller SATA" --port 0 --device 0 --type hdd --medium /var/box/Controller.vdi
VBoxManage storagectl Controller --name "IDE Controller" --add ide
VBoxManage storageattach Controller --storagectl "IDE Controller" --port 0  --device 0 --type dvddrive --medium /home/asgard/ubuntu-16.04.4-server-amd64.iso
#VBoxManage modifyvm "Controller" --groups "/IronicGroup"

VBoxManage startvm Controller --type gui
VBoxManage controlvm Controller poweroff
VBoxManage showvminfo Controller
==============================
===========Compute===========
VBoxManage createvm --name Compute --ostype "Ubuntu_64" --register --basefolder /var/vbox
VBoxManage modifyvm Compute --cpus 4 --memory 10240 --vram 9
VBoxManage modifyvm Compute --nic1 nat
VBoxManage modifyvm Compute --natpf1 "ssh, tcp, 127.0.0.1,2222, 10.0.2.16, 22"
VBoxManage modifyvm Compute --nic2 hostonly --hostonlyadapter2 vboxnet0
VBoxManage modifyvm Compute --nic3 bridged --bridgeadapter3 enp1s0f0
VBoxManage createhd --filename /var/box/Compute.vdi --size 40000 --format VDI --variant Standard
VBoxManage storagectl Compute --name "Compute SATA" --add sata --bootable on
VBoxManage storageattach Compute --storagectl "Compute SATA" --port 0 --device 0 --type hdd --medium /var/box/Compute.vdi
VBoxManage storagectl Compute --name "IDE Compute" --add ide
VBoxManage storageattach Compute --storagectl "IDE Compute" --port 0  --device 0 --type dvddrive --medium /home/asgard/ubuntu-16.04.4-server-amd64.iso
#VBoxManage modifyvm "Compute" --groups "/TestGroup"

VBoxManage startvm Compute --type gui
VBoxManage controlvm Compute poweroff
VBoxManage showvminfo Compute
==============================
============Block============
VBoxManage createvm --name Block --ostype "Ubuntu_64" --register --basefolder /var/vbox
VBoxManage modifyvm Block --cpus 4 --memory 10240 --vram 9
VBoxManage modifyvm Block --nic1 nat
VBoxManage modifyvm Block --natpf1 "ssh, tcp, 127.0.0.1,2222, 10.0.2.17, 22"
VBoxManage modifyvm Block --nic2 hostonly --hostonlyadapter2 vboxnet0
VBoxManage modifyvm Block --nic3 bridged --bridgeadapter3 enp1s0f0
VBoxManage createhd --filename /var/box/Block.vdi --size 40000 --format VDI --variant Standard
VBoxManage storagectl Block --name "Block SATA" --add sata --bootable on
VBoxManage storageattach Block --storagectl "Block SATA" --port 0 --device 0 --type hdd --medium /var/box/Block.vdi
VBoxManage storagectl Block --name "IDE Block" --add ide
VBoxManage storageattach Block --storagectl "IDE Block" --port 0  --device 0 --type dvddrive --medium /home/asgard/ubuntu-16.04.4-server-amd64.iso
#VBoxManage modifyvm "Block" --groups "/TestGroup"

VBoxManage startvm Block --type gui
VBoxManage controlvm Block poweroff
VBoxManage showvminfo Block
==============================
VBoxManage list vms
VBoxManage startvm Block --type gui
VBoxManage startvm Controller --type gui
VBoxManage startvm Compute --type gui
=============================================================
============Install Linux and Configure Interface============

VBoxManage controlvm Controller poweroff
VBoxManage controlvm Compute poweroff
VBoxManage controlvm Block poweroff
=============================================================
==========Acess SSH and Config enp0s3/8/9 and hosts==========

VBoxManage startvm Controller --type headless
VBoxManage startvm Compute --type headless
VBoxManage startvm Block --type headless

ssh -l controller -p 2222 localhost
ssh -l compute -p 2222 localhost
ssh -l block -p 2222 localhost

sudo su
ssh-keygen
vim .ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC2IiP6qHRN/1jdOlmuQlpDcOEU+3iCwKgn0RnU5eWbcmUYKccXcB25fBCG308mp2YDyrFccIi0Imz6O0xzHXsLaGhzr9OU6cnF4dDYlAxq75TTuTkrSoF+cTDHr9QeEnmVXlw+qDVGVTXGXlj8aZ4o3zr8y7zwQz0+fopnD7Lh3tRSrydWNrDmqDTJ070ABD7oW6Flu0H0FwjBPVNKnGY3Sjw32xy5P44LKFYSZvkev3zGcVrLzeSYQoT4fomh1EHh8sTRkhGqgt8/EG/tglUh0B20wehDq4mkLpxEoHgtyNDbqB08DjpePt60kYsjhLvFNO7HwhpvoYNCzFmkZCTn asgard@asgard
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDTmSMy8hAfbcdxv91t5AiL85XXDfqrvVdej/iftgJq9OfOSEfx6LC9obiyiWDyATgSxfzSuI3dTfhIXWMeKhXC8zhdeShnMKLOZfRu8UXYrUPHLD+ajy2RDpVk4r4Wlquiq6mCBXiFxkz6TeFWPSHV9UxuIzvJng38y0FuTbh0TUsrGfaejYaID5+SlJdLBBTSGPcOxJCqerfsMLQHHqOff/heY9m/hmNs3oTRHyR1q/XGNUBk5gYqqr6/zSLTspU9aT7BbLQ5ZXB1nNXUHBsboD3ZkRdsNCXXkKNW6iVwXxK/viymFYGqKfSSxHGLPVCiGd6pjjID9EBI4JjEdtVR henrique@henrique

ifconfig enp0s8 up
ifconfig enp0s9 up

#ATENÇÃO NO ENP0S8
#Controller: 10.0.0.11
#Computer: 10.0.0.31
#Block: 10.0.0.41

vim /etc/network/interfaces
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
auto enp0s3
iface enp0s3 inet dhcp

auto enp0s8
iface enp0s8 inet manual
        up ifconfig $IFACE 10.0.0.11 up
        up ip link set $IFACE promisc on
        down ip link set $IFACE promisc off
        down ifconfig $IFACE down

auto enp0s9
iface enp0s9 inet dhcp
:wq!

dhclient enp0s9
service networking restart
shutdown -t 0

VBoxManage export Controller -o IRONIC_Controller.ova
VBoxManage export Compute -o IRONIC_Compute.ova
VBoxManage export Block -o IRONIC_Block.ova

VBoxManage unregistervm Controller --delete
VBoxManage unregistervm Compute --delete
VBoxManage unregistervm Block --delete

vboxmanage import IRONIC_Controller.ova
vboxmanage import IRONIC_Compute.ova
vboxmanage import IRONIC_Block.ova

VBoxManage startvm Controller --type headless
VBoxManage startvm Compute --type headless
VBoxManage startvm Block --type headless
ssh controller@192.168.88.77
ssh compute@192.168.88.93
ssh block@192.168.88.54
-----------------------------
sudo vim /etc/hosts
127.0.0.1	localhost
# controller
10.0.0.11       controller
# Compute and compute2
10.0.0.31       Compute
# Block
10.0.0.41       Block

# The following lines are desirable for IPv6 capable hosts
::1	ip6-localhost	ip6-loopback
fe00::0	ip6-localnet
ff00::0	ip6-mcastprefix
ff02::1	ip6-allnodes
ff02::2	ip6-allrouters
ff02::3	ip6-allhosts
-----------------------------


VBoxManage export Controller -o IRONIC_Controller.ova
VBoxManage export Compute -o IRONIC_Compute.ova
VBoxManage export Block -o IRONIC_Block.ova

VBoxManage unregister Controller --delete
=========================================================
set vim Vagrantfile

# -*- mode: ruby -*-
# vi: set ft=ruby :

ENV["LC_ALL"] = "en_US.UTF-8"

Vagrant.configure("2") do |config|
  
############### start controller ###############
  config.vm.define "controller" do |controller|
    controller.vm.box = "ubuntu/xenial64"
    controller.vm.hostname = 'controller'
    controller.vm.network "private_network", ip: "10.0.0.11", netmask: "24"
    controller.vm.network "public_network", use_dhcp_assigned_default_route: true
    controller.vm.network "forwarded_port", guest: 2222, host: 22, host_ip: 10.0.2.1, protocol: "tcp"

    controller.vm.provider "virtualbox" do |vb|
      vb.memory = "10240"
      vb.cpus = "4"
      end
end
############### end controller ###############

############### start compute ###############
  config.vm.define "compute" do |compute|
    compute.vm.box = "ubuntu/xenial64"
    compute.vm.hostname = 'compute'
    compute.vm.network "private_network", ip: "10.0.0.11", netmask: "24"
    compute.vm.network "public_network", use_dhcp_assigned_default_route: true
    compute.vm.network "forwarded_port", guest: 2222, host: 22, host_ip: 10.0.2.1, protocol: "tcp"

    compute.vm.provider "virtualbox" do |vb|
      vb.memory = "10240"
      vb.cpus = "4"
      end
end
############### end compute ###############

############### start block ###############
  config.vm.define "block" do |block|
    block.vm.box = "ubuntu/xenial64"
    block.vm.hostname = 'block'
    block.network "private_network", ip: "10.0.0.11", netmask: "24"
    block.network "public_network", use_dhcp_assigned_default_route: true
    block.network "forwarded_port", guest: 2222, host: 22, host_ip: 10.0.2.1, protocol: "tcp"

    block.provider "virtualbox" do |vb|
      vb.memory = "10240"
      vb.cpus = "4"
      end
end
############### end block ###############

end

https://gist.github.com/guisjlender/7871913
