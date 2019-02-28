#!/bin/bash
echo "Atualizar o Sistema ? [S][N]"
read att
[ "$att" == "S" ] && apt -qy update  2>> ../logs/update-error.log && apt -qy dist-upgrade  2>> ../logs/dist-upgrade.log && apt -qy autoremove 2>> ../logs/autoremove-error.log

vagrant -v
if [[ $? -eq 0 ]];then
	echo "Vagrant já se encontra instalado!!"
else 
	apt -y remove vagrant 2>> rm-vagrant.log && apt -y purge vagrant 2>> pg-vagrant.log
	rm -rf /opt/vagrant 2>> rm-vagrant_opt.log & rm -f /usr/bin/vagrant 2>> rm-vagrant_bin.log
	#wget https://releases.hashicorp.com/vagrant/2.2.1/vagrant_2.2.1_x86_64.deb
	#dpkg -i vagrant_2.2.1_x86_64.deb
	wget https://releases.hashicorp.com/vagrant/2.2.4/vagrant_2.2.4_x86_64.deb
	dpkg -i vagrant_2.2.4_x86_64.deb
	vagrant -v
	which vagrant
	echo "Vagrant Instalado com sucesso!!"
fi