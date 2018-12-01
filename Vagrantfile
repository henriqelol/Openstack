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
        
        echo "Update do Sistema"
        bash backup/update.sh
        bash backup/py_mysql.sh
        echo "Move hosts"
        sudo mv backup/hosts /etc/
        rm -r backup/
      SHELL
    end
  ############### end controller ###############
end
