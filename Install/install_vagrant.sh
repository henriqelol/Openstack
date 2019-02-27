echo "Atualizar o Sistema ? [S][N]"
read att
if [[ "$att" == "S" ]];then
	apt-get update && apt-get dist-upgrade && apt-get autoremove
else
	apt -y remove vagrant 2>> rm-vagrant.log && apt -y purge vagrant 2>> pg-vagrant.log
	rm -rf /opt/vagrant 2>> rm-vagrant_opt.log & rm -f /usr/bin/vagrant 2>> rm-vagrant_bin.log

	wget https://releases.hashicorp.com/vagrant/2.2.1/vagrant_2.2.1_x86_64.deb
	dpkg -i vagrant_2.2.1_x86_64.deb
	vagrant -v
	which vagrant
fi
echo "Vagrant Instalado com sucesso!!"

#echo "Vagrant Instalado com sucesso!!"
#	if [ $(vagrant -v) -eq 0 ]
#	then
#	    echo "sucesso"
#	fi