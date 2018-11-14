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
#VBoxManage modifyvm Controller --nic1 hostonly --hostonlyadapter1 'vboxnet0'
VBoxManage modifyvm Controller --nic2 bridged --bridgeadapter1 enp1s0f0
VBoxManage modifyvm Controller --nic3 nat
VBoxManage modifyvm Controller --natpf3 "ssh, tcp, 127.0.0.1,2222, 10.0.2.15, 22"
VBoxManage createhd --filename /var/box/Controller.vdi --size 40000 --format VDI --variant Standard
VBoxManage storagectl Controller --name "Controller SATA" --add sata --bootable on
VBoxManage storageattach Controller --storagectl "Controller SATA" --port 0 --device 0 --type hdd --medium /var/box/Controller.vdi
VBoxManage storagectl Controller --name "IDE Controller" --add ide
VBoxManage storageattach Controller --storagectl "IDE Controller" --port 0  --device 0 --type dvddrive --medium /home/asgard/ubuntu-16.04.4-server-amd64.iso

VBoxManage startvm Controller --type gui
VBoxManage controlvm Controller poweroff
VBoxManage showvminfo Controller
==============================
===========Compute1===========
VBoxManage createvm --name Compute1 --ostype "Ubuntu_64" --register --basefolder /var/vbox
VBoxManage modifyvm Compute1 --cpus 4 --memory 10240 --vram 9
#VBoxManage modifyvm Compute1 --nic1 hostonly --hostonlyadapter1 vboxnet0
VBoxManage modifyvm Compute1 --nic2 bridged --bridgeadapter1 enp1s0f0
VBoxManage modifyvm Compute1 --nic3 nat
VBoxManage modifyvm Compute1 --natpf3 "ssh, tcp, 127.0.0.1,2222, 10.0.2.15, 22"
VBoxManage createhd --filename /var/box/Compute1.vdi --size 40000 --format VDI --variant Standard
VBoxManage storagectl Compute1 --name "Compute1 SATA" --add sata --bootable on
VBoxManage storageattach Compute1 --storagectl "Compute1 SATA" --port 0 --device 0 --type hdd --medium /var/box/Compute1.vdi
VBoxManage storagectl Compute1 --name "IDE Compute1" --add ide
VBoxManage storageattach Compute1 --storagectl "IDE Compute1" --port 0  --device 0 --type dvddrive --medium /home/asgard/ubuntu-16.04.4-server-amd64.iso

VBoxManage startvm Compute1 --type gui
VBoxManage controlvm Compute1 poweroff
VBoxManage showvminfo Compute1
==============================
============Block1============
VBoxManage createvm --name Block1 --ostype "Ubuntu_64" --register --basefolder /var/vbox
VBoxManage modifyvm Block1 --cpus 4 --memory 10240 --vram 9
#VBoxManage modifyvm Block1 --nic1 hostonly --hostonlyadapter1 vboxnet0
VBoxManage modifyvm Block1 --nic2 bridged --bridgeadapter1 enp1s0f0
VBoxManage modifyvm Block1 --nic3 nat
VBoxManage modifyvm Block1 --natpf3 "ssh, tcp, 127.0.0.1,2222, 10.0.2.15, 22"
VBoxManage createhd --filename /var/box/Block1.vdi --size 40000 --format VDI --variant Standard
VBoxManage storagectl Block1 --name "Block1 SATA" --add sata --bootable on
VBoxManage storageattach Block1 --storagectl "Block1 SATA" --port 0 --device 0 --type hdd --medium /var/box/Block1.vdi
VBoxManage storagectl Block1 --name "IDE Block1" --add ide
VBoxManage storageattach Block1 --storagectl "IDE Block1" --port 0  --device 0 --type dvddrive --medium /home/asgard/ubuntu-16.04.4-server-amd64.iso

VBoxManage startvm Block1 --type gui
VBoxManage controlvm Block1 poweroff
VBoxManage showvminfo Block1
==============================
VBoxManage list vms

VBoxManage startvm Controller --type headless
ssh -l ubuntu -p 2222 localhost

ssh-keygen

sudo vim .ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC2IiP6qHRN/1jdOlmuQlpDcOEU+3iCwKgn0RnU5eWbcmUYKccXcB25fBCG308mp2YDyrFccIi0Imz6O0xzHXsLaGhzr9OU6cnF4dDYlAxq75TTuTkrSoF+cTDHr9QeEnmVXlw+qDVGVTXGXlj8aZ4o3zr8y7zwQz0+fopnD7Lh3tRSrydWNrDmqDTJ070ABD7oW6Flu0H0FwjBPVNKnGY3Sjw32xy5P44LKFYSZvkev3zGcVrLzeSYQoT4fomh1EHh8sTRkhGqgt8/EG/tglUh0B20wehDq4mkLpxEoHgtyNDbqB08DjpePt60kYsjhLvFNO7HwhpvoYNCzFmkZCTn asgard@asgard

sudo ifconfig enp0s8 up
sudo ifconfig enp0s9 up

sudo vim /etc/network/interfaces
# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
auto enp0s8
iface enp0s8 inet manual
	up ifconfig $IFACE 10.0.0.11 up
        up ip link set $IFACE promisc on
        down ip link set $IFACE promisc off
        down ifconfig $IFACE down

auto enp0s9
iface enp0s9 inet dhcp
:wq!

sudo dhclient enp0s8
sudo shutdown -t 0


VBoxManage startvm Compute1 --type headless
ssh -l Compute1 -p 2222 localhost

ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC2IiP6qHRN/1jdOlmuQlpDcOEU+3iCwKgn0RnU5eWbcmUYKccXcB25fBCG308mp2YDyrFccIi0Imz6O0xzHXsLaGhzr9OU6cnF4dDYlAxq75TTuTkrSoF+cTDHr9QeEnmVXlw+qDVGVTXGXlj8aZ4o3zr8y7zwQz0+fopnD7Lh3tRSrydWNrDmqDTJ070ABD7oW6Flu0H0FwjBPVNKnGY3Sjw32xy5P44LKFYSZvkev3zGcVrLzeSYQoT4fomh1EHh8sTRkhGqgt8/EG/tglUh0B20wehDq4mkLpxEoHgtyNDbqB08DjpePt60kYsjhLvFNO7HwhpvoYNCzFmkZCTn asgard@asgard

sudo ifconfig enp0s8 up
sudo ifconfig enp0s9 up

sudo vim /etc/network/interfaces
# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
auto enp0s8
iface enp0s8 inet manual
	up ifconfig $IFACE 10.0.0.11 up
        up ip link set $IFACE promisc on
        down ip link set $IFACE promisc off
        down ifconfig $IFACE down

auto enp0s9
iface enp0s9 inet dhcp
:wq!

sudo dhclient enp0s8
sudo shutdown -t 0

VBoxManage startvm Block1 --type headless
ssh -l Block1 -p 2222 localhost

ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC2IiP6qHRN/1jdOlmuQlpDcOEU+3iCwKgn0RnU5eWbcmUYKccXcB25fBCG308mp2YDyrFccIi0Imz6O0xzHXsLaGhzr9OU6cnF4dDYlAxq75TTuTkrSoF+cTDHr9QeEnmVXlw+qDVGVTXGXlj8aZ4o3zr8y7zwQz0+fopnD7Lh3tRSrydWNrDmqDTJ070ABD7oW6Flu0H0FwjBPVNKnGY3Sjw32xy5P44LKFYSZvkev3zGcVrLzeSYQoT4fomh1EHh8sTRkhGqgt8/EG/tglUh0B20wehDq4mkLpxEoHgtyNDbqB08DjpePt60kYsjhLvFNO7HwhpvoYNCzFmkZCTn asgard@asgard

sudo ifconfig enp0s8 up
sudo ifconfig enp0s9 up

sudo vim /etc/network/interfaces
# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
auto enp0s8
iface enp0s8 inet manual
	up ifconfig $IFACE 10.0.0.11 up
        up ip link set $IFACE promisc on
        down ip link set $IFACE promisc off
        down ifconfig $IFACE down

auto enp0s9
iface enp0s9 inet dhcp
:wq!

sudo dhclient enp0s8
sudo shutdown -t 0

VBoxManage export Controller -o IRONIC_Controller.ova
VBoxManage export Compute1 -o IRONIC_Compute1.ova
VBoxManage export Block1 -o IRONIC_Block1.ova


VBoxManage unregister Controller --delete