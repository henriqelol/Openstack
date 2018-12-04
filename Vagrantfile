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
		        echo "Download teste.sh"
		        git clone https://github.com/henriqelol/backup.git --quiet
		        if [ $? -ne 0 ]; then echo "Erro"; fi
		        chown -R vagrant.vagrant backup
		        sudo su
		        echo "Update do Sistema"
		        bash backup/update.sh
		        bash backup/py_mysql.sh
		        echo "Move hosts"
		        mv backup/hosts /etc/
		        bash backup/rabbitmq.sh
		        bash backup/memcached.sh
		        bash backup/etcd.sh
		        #bash connection.sh
		        bash backup/keystone.sh
		        verify_keystone.sh

		        rm -r backup/
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
                vb.memory = "1024"
                vb.cpus = "1"
            end

            compute.vm.provision "shell", inline: <<-SHELL

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
                vb.memory = "1024"
                vb.cpus = "1"
            end

            block.vm.provision "shell", inline: <<-SHELL

	      	SHELL
        end
    ############### end block ###############
end