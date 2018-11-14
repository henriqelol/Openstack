# Instalação do OpenStack
 Este documento apresenta os links conforme foi implementado passo a passo a instalação do **Openstack Ironic** e **Openstack Kolla-Ansible**.

## Guia de Instalação do OpenStack
Toda documentação foi feita apartir do Guia de Instalação, a versão utilizada foi a  [**Queens**](https://www.openstack.org/software/queens/).  

https://docs.openstack.org/install-guide/


## Máquina Servidor
Para instalação de Openstack, foi utilizado um servidor com as seguintes  principais Configurações:
**Configurações de Hardware**: 
Processador: 8 Nucleos

Memória: 16 GB

HD: 1TB

*** Configurações de Software:***

Sistema: Ubuntu 16.04

Programa: VirtualBox -  Versão 5.2.20 

Toda instalação de ambiente foi através de acesso SSH -X.

## Ambientes criados no VirtualBox
### Controller Node 1
Config: Memória: 10240 mb, Proc: 4 Nucleo, Placa de Rede 1: host-only (vboxnet0), brigde enp10f0.
### Compute Node 1
Config: Memória: 10240 mb, Proc: 4 Nucleo, Placa de Rede 1: host-only (vboxnet0), brigde enp10f0.
### Block Node 1
Config: Memória: 10240 mb, Proc: 4 Nucleo, Placa de Rede 1: host-only (vboxnet0), brigde enp10f0.
### Object Node 1
Config: Memória: 10240 mb, Proc: 4 Nucleo, Placa de Rede 1: host-only (vboxnet0), brigde enp10f0.
### Object Node 2
Config: Memória: 10240 mb, Proc: 4 Nucleo, Placa de Rede 1: host-only (vboxnet0), brigde enp10f0.

## Configuração de Rede do Ambiente
### Controller Node 1
https://docs.openstack.org/install-guide/environment-networking-controller.html

Configuração de interface da máquina controller
IP address: 10.0.0.11
Network mask: 255.255.255.0 (or /24)
Default gateway: 10.0.0.1

/etc/network/interfaces
auto enp0s3
iface enp0s3 inet manual
	up ifconfig $IFACE 10.0.0.11 up
        up ip link set $IFACE promisc on
        down ip link set $IFACE promisc off
        down ifconfig $IFACE down

auto enp0s8
iface enp0s8 inet dhcp

/etc/hosts
#Comente 127.0.1.1
# controller
10.0.0.11       controller
# compute1
10.0.0.31       compute1
# block1
10.0.0.41       block1
:wq!
sudo reboot

### Compute Node 1
https://docs.openstack.org/install-guide/environment-networking-compute.html

Configuração de interface da máquina compute1
IP address: 10.0.0.31
Network mask: 255.255.255.0 (or /24)
Default gateway: 10.0.0.1

/etc/network/interfaces
auto enp0s3
iface enp0s3 inet manual
	up ifconfig $IFACE 10.0.0.31 up
        up ip link set $IFACE promisc on
        down ip link set $IFACE promisc off
        down ifconfig $IFACE down

auto enp0s8
iface enp0s8 inet dhcp

/etc/hosts
#Comente 127.0.1.1
# controller
10.0.0.11       controller
# compute1
10.0.0.31       compute1
# block1
10.0.0.41       block1
:wq!
sudo reboot

### Block Node 1, Object Node 1, Object Node 2
https://docs.openstack.org/install-guide/environment-networking-storage-cinder.html


Configuração de interface da máquina controller
IP address: 10.0.0.41
Network mask: 255.255.255.0 (or /24)
Default gateway: 10.0.0.1

/etc/network/interfaces
auto enp0s3
iface enp0s3 inet manual
	up ifconfig $IFACE 10.0.0.41 up
        up ip link set $IFACE promisc on
        down ip link set $IFACE promisc off
        down ifconfig $IFACE down

auto enp0s8
iface enp0s8 inet dhcp

/etc/hosts
#Comente 127.0.1.1
# controller
10.0.0.11       controller
# compute1
10.0.0.31       compute1
# block1
10.0.0.41       block1
:wq!
sudo reboot

## Verificação de Connectiividade
https://docs.openstack.org/install-guide/environment-networking-verify.html
ping -c 4 controller
ping -c 4 compute1
ping -c 4 block1


## Network Time Protocol (NTP)
## Instalação e Configuração de componentes
### Controller
https://docs.openstack.org/install-guide/environment-ntp-controller.html

sudo apt install chrony
/etc/chrony/chrony.conf
server NTP_SERVER iburst
>> colocar endereço de NTP_SERVER válido 
allow 10.0.0.0/24
:wq!
service chrony restart

### Outros Nós
https://docs.openstack.org/install-guide/environment-ntp-other.html
apt install chrony
/etc/chrony/chrony.conf
server controller iburst
#Comente a linha  pool 2.debian.pool.ntp.org offline iburst
:wq!
service chrony restart

##Verificando Operação
#Execute em todos o comando
chronyc sources

## Instalação de Pacotes OpenStack no Ubuntu (Versão Queens).
https://docs.openstack.org/install-guide/environment-packages-ubuntu.html
echo Y|apt install software-properties-common
add-apt-repository cloud-archive:queens

apt update && apt dist-upgrade
apt install python-openstackclient

## SQL Database
https://docs.openstack.org/install-guide/environment-sql-database-ubuntu.html
#Foi utilizado o mysql-server no lugar o mariadb-server
echo Y|apt-get install mysql-server python-pymysql
service mysql restart

## Mensagem Queue
https://docs.openstack.org/install-guide/environment-messaging-ubuntu.html
apt install rabbitmq-server
systemctl enable rabbitmq-server.service
systemctl start rabbitmq-server.service
rabbitmqctl add_user openstack senhaDaVMdoMato
rabbitmqctl set_permissions openstack ".*" ".*" ".*"

## Memcached
apt install memcached python-memcache
/etc/memcached.conf
-l 10.0.0.11
#Altere a linha -l 127.0.0.1.
:wq!
service memcached restart

## ETCD
https://docs.openstack.org/install-guide/environment-etcd-ubuntu.html
apt install etcd
/etc/default/etcd
ETCD_NAME="controller"
ETCD_DATA_DIR="/var/lib/etcd"
ETCD_INITIAL_CLUSTER_STATE="new"
ETCD_INITIAL_CLUSTER_TOKEN="etcd-cluster-01"
ETCD_INITIAL_CLUSTER="controller=http://10.0.0.11:2380"
ETCD_INITIAL_ADVERTISE_PEER_URLS="http://10.0.0.11:2380"
ETCD_ADVERTISE_CLIENT_URLS="http://10.0.0.11:2379"
ETCD_LISTEN_PEER_URLS="http://0.0.0.0:2380"
ETCD_LISTEN_CLIENT_URLS="http://10.0.0.11:2379"
:wq!
systemctl enable etcd
systemctl start etcd

## Instalação de Serviços OpenStack
https://docs.openstack.org/install-guide/openstack-services.html#minimal-deployment-for-queens
### Serviço de Identidade
https://docs.openstack.org/keystone/queens/install/
### Serviço de Image
https://docs.openstack.org/glance/queens/install/
### Serviço de Compute
https://docs.openstack.org/nova/queens/install/
### Serviço de Networking
https://docs.openstack.org/neutron/queens/install/
### Dashboard
https://docs.openstack.org/horizon/queens/install/
### Serviço de Armazenamento de Bloco
https://docs.openstack.org/cinder/queens/install/

#Erros e Bugs
(Nem eu sei o que são esses Erros e Bugs)
https://docs.openstack.org/install-guide/environment-ntp-other.html
https://stackoverflow.com/questions/39281594/error-1698-28000-access-denied-for-user-rootlocalhost
https://docs.openstack.org/install-guide/environment-messaging.html
mysql -u root -p

https://docs.openstack.org/install-guide/environment-messaging-ubuntu.html
	rabbitmqctl add_user openstack RABBIT_PASS

https://docs.openstack.org/install-guide/environment-etcd-ubuntu.html
https://docs.openstack.org/install-guide/openstack-services.html
https://docs.openstack.org/keystone/queens/install/keystone-users-ubuntu.html
https://docs.openstack.org/keystone/queens/code_documentation.html

https://docs.openstack.org/keystone/queens/install/index-ubuntu.html
https://docs.openstack.org/keystone/queens/install/keystone-verify-ubuntu.html

openstack --os-auth-url http://controller:5000/v3  --os-project-domain-name Default --os-user-domain-name Default  --os-project-name admin --os-username admin token issue

openstack --os-auth-url http://controller:5000/v3 --os-project-domain-name Default --os-user-domain-name Default --os-project-name demo --os-username demo token issue
https://docs.openstack.org/keystone/queens/install/keystone-users-ubuntu.html