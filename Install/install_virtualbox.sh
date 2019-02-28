#!/bin/bash
echo "Atualizar o Sistema ? [S][N]"
read att
[ "$att" == "S" ] && apt -qy update  2>> ../logs/update-error.log && apt -qy dist-upgrade  2>> ../logs/dist-upgrade.log && apt -qy autoremove 2>> ../logs/autoremove-error.log

virtualbox -v
if [[ $? -eq 0 ]];then
	echo "VirtualBox já se encontra instalado!!"
else 
	apt -y remove virtualbox-5.\* 2>> rm-vb_vms.log && apt -y purge virtualbox-5.\* 2>> pg-vb_vms.log
	#rm ~/"VirtualBox VMs" -Rf 2>> rm-vb_vms.log && rm ~/.config/VirtualBox/ -Rf 2>> rm-vb_config.log 
	apt-get -y install gcc make linux-headers-$(uname -r) dkms
	wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | apt-key add -
	wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | apt-key add -
	sh -c 'echo "deb http://download.virtualbox.org/virtualbox/debian $(lsb_release -sc) contrib" >> /etc/apt/sources.list'
	apt remove virtualbox virtualbox-5.*
	apt update && apt list --upgradable
	apt-get -qy install virtualbox-6.0 2>> vb-erro.log
	echo "VirtualBox Instalado com sucesso!!"
fi