# -*- mode: ruby -*-
# vi: set ft=ruby :

ENV["LC_ALL"] = "en_US.UTF-8"

Vagrant.configure("2") do |config|
	############### start controller #############
	config.vm.define "controller" do |controller|
		controller.vm.box = "ubuntu/xenial64"
		controller.vm.hostname = 'controller'
		controller.vm.network "private_network", ip: "10.0.0.11"
		controller.vm.network "public_network"

		controller.vm.provider "virtualbox" do |vb|
			vb.memory = "10240"
			vb.cpus = "4"
		end
	end
	############### end controller ##############
	############### start compute ###############
	config.vm.define "compute" do |compute|
		compute.vm.box = "ubuntu/xenial64"
		compute.vm.hostname = 'compute'
		compute.vm.network "private_network", ip: "10.0.0.31"
		compute.vm.network "public_network"

		compute.vm.provider "virtualbox" do |vb|
			vb.memory = "10240"
			vb.cpus = "4"
		end
	end
	############### end compute ###############
end