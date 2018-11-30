apt -y remove virtualbox-\* 2>> rm-vb_vms.log && apt -y purge virtualbox-\* 2>> pg-vb_vms.log
rm ~/"VirtualBox VMs" -Rf 2>> rm-vb_vms.log && rm ~/.config/VirtualBox/ -Rf 2>> rm-vb_config.log 
apt -qy update  2>> apt-update-error.log && apt -qy dist-upgrade  2>> apt-dist-upgrade.log && apt -qy autoremove 2>> apt-autoremove-error.log
apt-get -y install gcc make linux-headers-$(uname -r) dkms
wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | apt-key add -
wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | apt-key add -
sh -c 'echo "deb http://download.virtualbox.org/virtualbox/debian $(lsb_release -sc) contrib" >> /etc/apt/sources.list'
apt update && apt list --upgradable
apt-get -qy install virtualbox-5.2