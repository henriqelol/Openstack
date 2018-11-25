# Instalação do OpenStack
 Este documento apresenta os links conforme foi implementado passo a passo a instalação do **Openstack Ironic** e **Openstack Kolla-Ansible**.

#### Guia de Instalação do OpenStack
Toda documentação foi feita apartir do Guia de Instalação, a versão utilizada foi a  [**queens**](https://www.openstack.org/software/queens/).  
Guia instalação: https://docs.openstack.org/install-guide/  

### Máquina Servidor
Para instalação de Openstack, foi utilizado um servidor com as seguintes configurações:  
**Configurações de Hardware**:  
Processador: 8 Nucleos; Memória: 16 GB; HD: 1TB.  
**Configurações de Software**:  
Sistema: Ubuntu 16.04  

Programas utilizados: VirtualBox - Versão 5.2.22 r126460 (Qt5.6.1).  
                      Vagrant - Versão 2.2.1                                    

*Toda instalação de ambiente foi através de acesso SSH -X*.

### [Ambientes criados no VirtualBox/Vagrant](https://github.com/henriqelol/Openstack/blob/master/vagrant_virtualbox.md)
Para ambos situações de criações de VMs, utilizando o [**VAGRANT**](https://github.com/henriqelol/Openstack/blob/master/vagrant_virtualbox.md) ou o [**VIRTUALBOX**](https://github.com/henriqelol/Openstack/blob/master/vagrant_virtualbox.md), basta acessar o link e seguir os passos apresentados:

**Controller**
Config: Memória: 10240 mb, Proc: 4 Nucleos, HD: 40GB, Placa de Rede 1: host-only (vboxnet0), brigde enp10f0.  
**Compute/Block**
Config: Memória: 10240 mb, Proc: 4 Nucleos, HD: 40GB, Placa de Rede 1: host-only (vboxnet0), brigde enp10f0.  

### Configuração de Rede do Ambiente
#### [Controller](https://docs.openstack.org/install-guide/environment-networking-controller.html)

Configuração de interface da *máquina controller*.  
        IP address: 10.0.0.11  
        Network mask: 255.255.255.0 (or /24)  
        Default gateway: 10.0.0.1  

Configure a interface de rede editando o arquivo `/etc/network/interfaces`
~~~
auto enp0s3
iface enp0s3 inet manual
	up ifconfig $IFACE 10.0.0.11 up
        up ip link set $IFACE promisc on
        down ip link set $IFACE promisc off
        down ifconfig $IFACE down

auto enp0s8
iface enp0s8 inet dhcp
~~~
Edite o arquivo `/etc/hosts`
~~~
127.0.0.1       localhost
#127.0.1.1       controller
# controller
10.0.0.11       controller
# compute1
10.0.0.31       compute1
# block1
10.0.0.41       block1
~~~

#### [Compute](https://docs.openstack.org/install-guide/environment-networking-compute.html)

Configuração de interface da *máquina compute* 
        IP address: 10.0.0.31
        Network mask: 255.255.255.0 (or /24)
        Default gateway: 10.0.0.1

Configure a interface de rede editando o arquivo `/etc/network/interfaces`
~~~
auto enp0s3
iface enp0s3 inet manual
	up ifconfig $IFACE 10.0.0.31 up
        up ip link set $IFACE promisc on
        down ip link set $IFACE promisc off
        down ifconfig $IFACE down

auto enp0s8
iface enp0s8 inet dhcp
~~~

Edite o arquivo `/etc/hosts`
~~~
127.0.0.1       localhost
#127.0.1.1       compute
# controller
10.0.0.11       controller
# compute1
10.0.0.31       compute1
# block1
10.0.0.41       block1
~~~

#### [Block](https://docs.openstack.org/install-guide/environment-networking-storage-cinder.html)

Configuração de interface da máquina **Block**  
>>*Mesmos passos anteriores, alterando apenas o valor final do endereço IP para o valor 41* 

### [Verificação de Connectiividade](https://docs.openstack.org/install-guide/environment-networking-verify.html)
~~~
ping -c 4 controller  
ping -c 4 compute1  
ping -c 4 block1  
~~~

## [Network Time Protocol (NTP)](https://docs.openstack.org/install-guide/environment-ntp.html)
### Instalação e Configuração de componentes
#### [Controller](https://docs.openstack.org/install-guide/environment-ntp-controller.html)
~~~
apt install chrony  

/etc/chrony/chrony.conf   
server NTP_SERVER iburst  
allow 10.0.0.0/24
~~~
>> colocar endereço de NTP_SERVER válido  
~~~
service chrony restart
~~~

#### [Outros Nós](https://docs.openstack.org/install-guide/environment-ntp-other.html)
~~~
apt install chrony

/etc/chrony/chrony.conf
server controller iburst
service chrony restart
~~~
>>Comente a linha  pool 2.debian.pool.ntp.org offline iburst  

#### Verificando Operação
Execute em todas máquinas o comando
~~~
chronyc sources  
~~~

## [Instalação de Pacotes OpenStack no Ubuntu (Versão Queens)](https://docs.openstack.org/install-guide/environment-packages-ubuntu.html)
OpenStack Queens for Ubuntu 16.04 LTS:  
~~~
echo Y|apt install software-properties-common  
add-apt-repository cloud-archive:queens  
~~~
Finalize a instalação  
~~~
apt update && apt dist-upgrade  
apt install python-openstackclient  
~~~

## [SQL Database](https://docs.openstack.org/install-guide/environment-sql-database-ubuntu.html)
A documentação do **Openstack Queens**, apresenta e utiliza o banco de dados MariaDB, porém para estudo foi utilizado o Mysql.  
Execute os comandos que desejar (MariaDB ou Mysql) no **Controller**. 
#### Mariadb
~~~
apt install mariadb-server python-pymysql
~~~
Crie e edite o arquivo /etc/mysql/mariadb.conf.d/99-openstack.cnf  
~~~
vim /etc/mysql/mariadb.conf.d/99-openstack.cnf
~~~
~~~ 
[mysqld]
bind-address = 10.0.0.11

default-storage-engine = innodb
innodb_file_per_table = on
max_connections = 4096
collation-server = utf8_general_ci
character-set-server = utf8
~~~
Finalize a instalação.  
~~~
service mysql restart
mysql_secure_installation
~~~

#### Mysql
~~~
apt-get install mysql-server python-pymysql
service mysql restart
~~~

## [Mensagem Queue](https://docs.openstack.org/install-guide/environment-messaging-ubuntu.html)
Execute os comandos no **Controller**.  
~~~
apt install rabbitmq-server
systemctl enable rabbitmq-server.service
systemctl start rabbitmq-server.service
rabbitmqctl add_user openstack RABBIT_PASS
rabbitmqctl set_permissions openstack ".*" ".*" ".*"
~~~

## [Memcached](https://docs.openstack.org/install-guide/environment-memcached.html)
Execute os comandos no **Controller**.  
~~~
apt install memcached python-memcache
~~~
Edite o arquivo /etc/memcached.conf
~~~
vim /etc/memcached.conf
~~~  
~~~
-l 10.0.0.11
~~~
Altere a linha que possue o comando *-l 127.0.0.1*  
Restarte o serviço.  
~~~
service memcached restart
~~~

## [ETCD](https://docs.openstack.org/install-guide/environment-etcd-ubuntu.html)
~~~
apt install etcd
~~~
Edite o arquivo /etc/default/etcd  
~~~
ETCD_NAME="controller"
ETCD_DATA_DIR="/var/lib/etcd"
ETCD_INITIAL_CLUSTER_STATE="new"
ETCD_INITIAL_CLUSTER_TOKEN="etcd-cluster-01"
ETCD_INITIAL_CLUSTER="controller=http://10.0.0.11:2380"
ETCD_INITIAL_ADVERTISE_PEER_URLS="http://10.0.0.11:2380"
ETCD_ADVERTISE_CLIENT_URLS="http://10.0.0.11:2379"
ETCD_LISTEN_PEER_URLS="http://0.0.0.0:2380"
ETCD_LISTEN_CLIENT_URLS="http://10.0.0.11:2379"
~~~
Ative o serviço ETCD  
~~~
systemctl enable etcd
systemctl start etcd
~~~

## Instalação de Serviços OpenStack]
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