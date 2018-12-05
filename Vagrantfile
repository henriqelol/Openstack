# -*- mode: ruby -*-
# vi: set ft=ruby :

ENV["LC_ALL"] = "en_US.UTF-8"

Vagrant.configure("2") do |config|
	############### start controller ###############
	    config.vm.define "controller" do |controller|
	      	controller.vm.box = "ubuntu/xenial64"
	      	controller.vm.hostname = 'controller'
	      	controller.vm.network "private_network", ip: "10.0.0.11"
	      	controller.vm.network "public_network"

	      	controller.vm.provider "virtualbox" do |vb|
		        vb.memory = "2048"
		        vb.cpus = "2"
	      	end

	      	controller.vm.provision "shell", inline: <<-SHELL
			sudo su	      		
			echo "Install Openstack Ironici"
			
			echo "===Update do Sistema==="
			bash /Openstack/Ironic/All/update.sh

			echo "===Copiando Hosts==="
			cp /Openstack/Ironic/All/hosts /etc/

			echo "===Copiando Hosts==="
			cp /Openstack/Ironic/All/admin-openrc /etc/
			source /etc/admin-openrc

			echo "===Copiando Demo-openrc==="
			cp /Openstack/Ironic/All/demo-openrc /etc/
			source /etc/demo-openrc

			echo "===Instalando Chrony==="
			bash /Openstack/Ironic/Controller/chrony.sh

			echo "===Instalando PY Server e MYSQL Server==="
			bash /Openstack/Ironic/Controller/mysql_py.sh

			echo "===Instalando rabbitmq==="
			bash /Openstack/Ironic/Controller/rabbitmq.sh

			echo "===Instalando memcached==="
			bash /Openstack/Ironic/Controller/memcached.sh

			echo "===Instalando etcd==="
			bash /Openstack/Ironic/Controller/etcd.sh

			echo "===Instalando keystone==="
			bash /Openstack/Ironic/Controller/keystone.sh

			echo "===Instalando glance==="
			bash /Openstack/Ironic/Controller/glance.sh

			echo "===Instalando nova==="
			bash /Openstack/Ironic/Controller/nova.sh

			echo "===Instalando neutron==="
			bash /Openstack/Ironic/Controller/neutron.sh
			
			echo "===Movendo os Logs==="
			bash /Openstack/Ironic/Ironic/All/mv-log.sh
		SHELL
	    end
	############### end controller ###############
end
