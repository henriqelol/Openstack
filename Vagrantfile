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
	      		echo "Que começa a poha toda"
		SHELL
	    end
	############### end controller ###############
end
