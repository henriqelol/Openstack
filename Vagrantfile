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
		        vb.memory = "10240"
		        vb.cpus = "4"
	      	end

	      	controller.vm.provision "shell", inline: <<-SHELL
			sudo su

			echo "Baixando git"
			git clone https://github.com/henriqelol/Openstack.git --quiet
			if [ $? -ne 0 ]; then echo "Erro de Download"; fi
			chown -R vagrant.vagrant necos

			echo "Install Openstack Ironic"
			
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
	    ############### start compute ###############
        config.vm.define "compute" do |compute|
            compute.vm.box = "ubuntu/xenial64"
            compute.vm.hostname = 'compute'
            compute.vm.network "private_network", ip: "10.0.0.31"
            compute.vm.network "public_network"

            compute.vm.provider "virtualbox" do |vb|
                vb.memory = "5120"
                vb.cpus = "2"
            end

            compute.vm.provision "shell", inline: <<-SHELL
			sudo su

			echo "Baixando git"
			git clone https://github.com/henriqelol/Openstack.git --quiet
			if [ $? -ne 0 ]; then echo "Erro de Download"; fi
			chown -R vagrant.vagrant necos

			echo "Install Openstack Ironic"
			
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
			bash /Openstack/Ironic/Compute/chrony_others.sh

			echo "===Instalando nova==="
			bash /Openstack/Ironic/Compute/nova_compute.sh

			echo "===Instalando neutron==="
			bash /Openstack/Ironic/Compute/neutron_compute.sh

			echo "===Movendo os Logs==="
			bash /Openstack/Ironic/Ironic/All/mv-log.sh
	      	SHELL
        end
    ############### end compute ###############
    ############### start block ###############
        config.vm.define "block" do |block|
            block.vm.box = "ubuntu/xenial64"
            block.vm.hostname = 'block' 	
            block.vm.network "private_network", ip: "10.0.0.41"
            block.vm.network "public_network"

            block.vm.provider "virtualbox" do |vb|
                vb.memory = "5120"
                vb.cpus = "2"
            end

            compute.vm.provision "shell", inline: <<-SHELL
			sudo su

			echo "Baixando git"
			git clone https://github.com/henriqelol/Openstack.git --quiet
			if [ $? -ne 0 ]; then echo "Erro de Download"; fi
			chown -R vagrant.vagrant necos

			echo "Install Openstack Ironic"
			
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
			bash /Openstack/Ironic/Block/chrony_others.sh

			echo "===Instalando nova==="
			bash /Openstack/Ironic/Block/nova_compute.sh

			echo "===Instalando neutron==="
			bash /Openstack/Ironic/Block/neutron_compute.sh

			echo "===Movendo os Logs==="
			bash /Openstack/Ironic/Ironic/All/mv-log.sh
	      	SHELL
        end
    ############### end block ###############
end
