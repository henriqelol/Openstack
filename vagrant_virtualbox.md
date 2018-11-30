# Instalação Vagrant e VirtualBox
Para o ambiente proposto foram utilizados os softwares [Vagrant](https://www.vagrantup.com/) e [VirtualBox](https://www.virtualbox.org/).   
Para cada máquina proposta no README foi criado uma VM, configurado sua interface e exportado a VM, gerando um **arquivo.OVA**.  
Para uma seguinte criação de nova máquina, apenas importe o **arquivo.OVA**.  

Para utilizar sua interface é necessario apenas acesso ssh -X: `ssh -X maquina@ip.da.maquina `
>Documentação de instalação do Vagrant **versão 2.2.1** e VirtualBox **versão 5.2.22** em sistema **Ubuntu Linux**.   

### Update do Sistema
1. De permissão total para executar os próximos comandos: `sudo su`.  
2. Atualize seu sistema: 
~~~
apt-get update && apt-get dist-upgrade && apt-get autoremove
~~~
3. Confira se o seu sistema é de 32 bits ou 64 bits.  
~~~
unane -m
~~~
***
## Instalação do VirtualBox
#### Remova Virtualbox com versão antiga instalada
~~~
apt-get remove virtualbox-\*
apt-get purge virtualbox-\*
rm ~/"VirtualBox VMs" -Rf
rm ~/.config/VirtualBox/ -Rf
~~~

#### Criação de chaves de autenticação do Virtualbox 
~~~
wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | apt-key add -
wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | apt-key add -
~~~

#### Inclução do Virtualbox no sistema e Instalação
~~~
sh -c 'echo "deb http://download.virtualbox.org/virtualbox/debian $(lsb_release -sc) contrib" >> /etc/apt/sources.list'
apt-get update
apt-get install virtualbox-5.2
~~~
>Caso haja versão mais atual, alterar a versão -5.2
***
#### Criação de VM com linhas de comando
1. [Download do sistema exemplo: Ubuntu Server 16.04](http://releases.ubuntu.com/16.04/)  
~~~
wget http://releases.ubuntu.com/16.04/ubuntu-16.04.4-server-amd64.iso
~~~
2. Criação da VM:  
- Crie uma pasta para deixar a VM:
~~~
mkdir /media/vm/maquinas/
~~~
- Crie a VM com nome **teste** com sistema operacional **Ubuntu 64** dentro da pasta **/media/vm/maquinas/**
~~~
VBoxManage createvm --name TestMachine --ostype Ubuntu_64 --register --basefolder /media/vm/maquinas/
~~~
- Altere alguns parâmetros usando o comando *modifyvm*. 
- Defina a quantidade de cpu como **2**, a memória para o tamanho de **1024mb**, vídeo com **9mb** e uma placa de redes em modo **nat** no porta eth0.
~~~
VBoxManage modifyvm "TestMachine" --cpus 2 --memory 1024 --vram 9 --nic1 nat 
~~~
- Crie um HD com tamanho de 10gb no arquivo teste-10gb.vdi
~~~
VBoxManage createhd --filename /media/vm/hds/TestMachine-10gb.vdi --size 10240 --format VDI --variant Standard 
~~~
- Anexe o HD a nossa máquina:
~~~
VBoxManage storagectl TestMachine --name "TestMachine SATA" --add sata --bootable on
VBoxManage storageattach TestMachine --storagectl "TestMachine SATA" --port 0 --device 0 --type hdd --medium /media/vm/hds/TestMachine-10gb.vdi
~~~
- Adicione a IDE a nossa máquina:
~~~
VBoxManage storagectl TestMachine --name "IDE TestMachine" --add ide
~~~
- Processo de montagem de imagem:
~~~
VBoxManage storageattach TestMachine --storagectl "IDE TestMachine" --port 0  --device 0 --type dvddrive --medium /home/asgard/ubuntu-16.04.4-server-amd64.iso
~~~
- Inicie a máquina:
~~~
VBoxManage startvm TestMachine
~~~

- Após instalação do sistema é possivel você ligar a máquina em modo headless:
~~~
VBoxHeadless --startvm testMachine
~~~
Para dúvidas, acesse a documentação do [VBoxManage](https://www.virtualbox.org/manual/ch08.html).  
[Tutorial 1](https://goo.gl/XivPbE).  
[Tutorial 2](https://goo.gl/fp6zHw).  
***
### Configuração de Rede do Ambiente e Verificação de conectividade 
Os seguintes passos podem ser encontrados no arquivo [README](https://github.com/henriqelol/Openstack), nos tópicos [Configuração de Rede do Ambiente](https://docs.openstack.org/install-guide/environment-networking.html) e [Verificação de conectividade](https://docs.openstack.org/install-guide/environment-networking-verify.html)·  

Os passos apresentados permite a criação do ambiente proposto, porém ainda sim o desenvolvedor fica preso a interface gráfica, caso não conheça os comandos necessários para a configuração do VirtualBox por linhas de comandos

Uma outra ferramenta que possui uma fácil documentação e que permite facilitar a criação de VMs no Virtualbox é o **Vagrant**.
O **Vagrant** é um Software facilitador na criação e configuração de ambientes com máquinas virtuais, tanto com VirtualBox ou para VMWare.  
***
***
## Instalação do Vagrant
#### Remova Vagrant com versão antiga instalada
~~~
apt remove vagrant
apt purge vagrant
rm -rf /opt/vagrant
rm -f /usr/bin/vagrant
~~~

#### Download e instalação do Vagrant
Antes de realizar a instalação, verifique a ultima [release do vagrant](https://releases.hashicorp.com/vagrant/).
~~~
wget https://releases.hashicorp.com/vagrant/2.2.1/vagrant_2.2.1_x86_64.deb
dpkg -i vagrant_2.2.1_x86_64.deb
vagrant -v
which vagrant
~~~
O Vagrant é baseado em **box** para criação de VMs, para melhor entendimento e dúvidas, acesse a [documentação](https://www.vagrantup.com/docs/index.html).  
***
## Comandos básicos do Vagrant
#### Box
+ Adiciona um novo box a sua lista de box
  - `vagrant box add name url`
+ Lista suas box para utilização
  - `vagrant box list`
+ Remove um box da lista de box
  - `vagrant box remove name`

#### Init
+ Cria o arquivo Vagrantfile com as configurações do box que você informou no [box-name], caso você não tenha o box ainda adicionado é obrigatório passar o [box-url] para que ele possa baixa-lo
  - `vagrant init [box-name] [box-url]`

#### Up
+ Cria e inicia a instancia após o comando vagrant init
  - `vagrant up`

#### Reload
+ Reinicia a instancia do box ativo
  - `vagrant reload`

#### Suspend
+ Stopa a instancia ativa, congelando seu estado atual
  - `vagrant suspend`

#### Resume
+ Ativa a instancia suspensa, até então, pelo comando vagrant suspend
  - `vagrant resume`

#### Halt
+ Manda um comando para desligar a instancia ativa, finalizando todos os processos antes de finalizar
  - `vagrant halt`
  - `vagrant halt name_vm`

#### Destroy
+ Destroy a instancia ativa
  - `vagrant destroy`

#### SSH
+ Acessa a instancia ativa via ssh
  - `vagrant ssh`

#### Status
+ Informa o status atual da instancia
  - `vagrant status`
+ Informa o status atual de todas instancias (Parado, rodando, congelada, etc).
  - `vagrant global-status`

#### Global-Status --Prune 
+ Limpando VMs obsoletas
  - `vagrant global-status --prune`

#### Destruir todas VMs
~~~
for i in `vagrant global-status | grep virtualbox | awk '{ print $1 }'` ; do vagrant destroy $i ; done
~~~
***

### Criando ambiente Openstack com Vagrant
#### Importando box
`vagrant box add ubuntu/xenial64`
#### Listando box importadas
`vagrant box list`
#### Criando o arquivo Vagrantfile - arquivo de configuração do ambiente
`vagrant init`
>O arquivo Vagrantfile é onde descrevemos toda a estrutura das nossas VMs.
#### Editando arquivo Vagrantfile
`vim Vagrantfile`

#### Criando a VM
`vagrant up`
>Caso dentro do arquivo Vagrantfile tenha mais de uma máquina, e você queira que apenas suba uma determinada VM, basta especificar com o nome da máquina no momento de dar o **up**.
`vagrant up name_vm`
>Caso queira ver um debug durando o comando **up** basta apenas colocar o comando --debug
`vagrant up name_vm --debug`

#### Acessando a VM
`vagrant ssh` ou `vagrant ssh name_vm` 

### Editando Vagrantfile para criar máquinas controller/compute/block
~~~
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
    end
  ############### end controller ###############

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

  ############### start block ###############
    config.vm.define "block" do |block|
      block.vm.box = "ubuntu/xenial64"
      block.vm.hostname = 'block'
      block.vm.network "private_network", ip: "10.0.0.42"
      block.vm.network "public_network"

      block.vm.provider "virtualbox" do |vb|
        vb.memory = "10240"
        vb.cpus = "4"
      end
    end
  ############### end block ###############
end
~~~