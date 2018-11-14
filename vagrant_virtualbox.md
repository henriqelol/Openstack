# Instalação Vagrant e VirtualBox
Para a criação do ambiente Openstack é obrigatoriamente necessario a utilização de VMs. Para o ambiente proposto foi utilizado o Software VirtualBox.
Durante o desenvolvimento foi criado primeiramente uma VM e devidamente configurado, como apresentado no README anterior, eapós isto, foi exportado a VM, gerando um **arquivo.OVA**.
Para toda nova criação de máquina, era apenas importado o **arquivo.OVA**.

Mesmo instalando um programa gráfico em um servidor, para utilizar sua interface é necessario apenas ao acessar via ssh incluir o -X.
ssh -X maquina@ip.da.maquina.X

## Update do Sistema
sudo apt-get update && sudo apt-get dist-upgrade && sudo apt-get autoremove

## Instalação do VirtualBox
### Remove Virtualbox com versão antiga instalada
sudo apt-get remove virtualbox-\*
sudo apt-get purge virtualbox-\*
sudo rm ~/"VirtualBox VMs" -Rf
sudo rm ~/.config/VirtualBox/ -Rf

### Criação de chaves de autenticação do Virtualbox 
wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -

### Inclução do Virtualbox no sistema e Instalação
sudo sh -c 'echo "deb http://download.virtualbox.org/virtualbox/debian $(lsb_release -sc) contrib" >> /etc/apt/sources.list'
sudo apt-get update
sudo apt-get install virtualbox-5.2
Caso haja versão mais atual, alterar a versão -5.2

Os passos apresentados permite a criação do ambiente proposto, porém ainda sim o desenvolvedor fica preso a interface gráfica, caso nao conheça os comandos necessarios para a configuração do VirtualBox por linhas de comandos

Uma outra ferramenta que possui uma fácil documentação e que permite facilitar a criação de VMs no Virtualbox é o **Vagrant**.
O **Vagrant** é um Software facilitador na criação e configuração de ambientes com máquinas virtuais, tanto com VirtualBox ou para VMWare.  

## Instalação do Vagrant
### Remove Vagrant com versão antiga  instalada
sudo apt remove vagrant
sudo apt purge vagrant
rm -rf /opt/vagrant
rm -f /usr/bin/vagrant

### Download e instalação do Vagrant
wget https://releases.hashicorp.com/vagrant/2.2.0/vagrant_2.2.0_x86_64.deb
sudo dpkg -i vagrant_2.2.0_x86_64.deb 
vagrant -v
which vagrant

O Vagrant é baseado em **box** para criação de VMs, para melhor entendimento e dúvidas, o seguinte link apresenta a documentação do mesmo.
**Link Documentação Vagrant** 

## Comandos básicos do Vagrant
### Importando box
vagrant box add ubuntu/xenial32
vagrant box add ubuntu/bionic32
### Listando box importadas
vagrant box list
### Criando o arquivo Vagrantfile - arquivo de configuração do ambiente
vagrant init

### Para editar o Vagrantfile
sudo vim Vagrantfile

### Criando a VM
vagrant up
Caso dentro do arquivo Vagrantfile tenha mais de uma máquina, e você queira que apenas suba uma determinada VM, basta especificar com o nome da máquina no momento de dar o **up**.
vagrant up nome_da_vm
Caso queira ver um debug durando o comando **up** basta apenas colocar o comando --debug
vagrant up nome_da_vm --debug

### Acessando a VM
vagrant ssh

### Outros Comandos
Saber o estado das VMs (Parado, rodando, congelada, etc).
vagrant global-status

Limpando VMs obsoletas
vagrant global-status --prune

Desligando todas VMs
vagrant halt
Desligando apenas uma VM
vagrant halt nome_da_vm

Religando todas VMs
vagrant reload
Religando apenas uma VMs
vagrant reload nome_da_vm

Destruir todas VMs
for i in `vagrant global-status | grep virtualbox | awk '{ print $1 }'` ; do vagrant destroy $i ; done