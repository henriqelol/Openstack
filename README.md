# Instalação do OpenStack Ironic e Kolla-Ansible
Este documento apresenta os links conforme foi implementado passo a passo a instalação do [**Openstack Ironic**](https://docs.openstack.org/ironic/latest/) e [**Openstack Kolla-Ansible**](https://docs.openstack.org/kolla-ansible/latest/).


## Guia de Instalação do OpenStack
Toda documentação foi feita a partir do [Guia de Instalação](https://docs.openstack.org/install-guide/), a versão utilizada foi a  [**queens**](https://www.openstack.org/software/queens/).  


### Máquina Servidor
Para instalação de Openstack, foi utilizado um servidor com as seguintes configurações:  
**Configurações de Hardware**: Processador: 8 Núcleos; Memória: 16 GB; HD: 1TB.  
**Configurações de Software**: Sistema: Ubuntu 16.04    
**Programas utilizados**:  
VirtualBox - *Versão 5.2.22 r126460 (Qt5.6.1).*   
Vagrant - *Versão 2.2.1*    
>>*Toda instalação de ambiente foi através de acesso SSH -X*.


### [Ambientes criados no VirtualBox/Vagrant](https://github.com/henriqelol/Openstack/blob/master/vagrant_virtualbox.md)
Para criações das VMs, utilizando [**VAGRANT**](https://github.com/henriqelol/Openstack/blob/master/vagrant_virtualbox.md) ou [**VIRTUALBOX**](https://github.com/henriqelol/Openstack/blob/master/vagrant_virtualbox.md), basta acessar o link e seguir os passos apresentados:

**Configurações das VMs: Controller/Compute/Block:**  
Processador: 4 Núcleos; Memória: 10 GB; HD: 40GB, Placa de Rede 1: host-only (vboxnet0), brigde enp10f0.  


### [Configuração de Rede do Ambiente](https://docs.openstack.org/install-guide/environment-networking.html)
Rede de hosts, com valores de interfaces e ips.  
![Plano de Rede](https://docs.openstack.org/install-guide/_images/networklayout.png)

#### [Controller](https://docs.openstack.org/install-guide/environment-networking-controller.html)
**Configurar interfaces de rede**
>>Configuração de interface da máquina **controller**.
1. Configure a primeira interface como a interface de gerenciamento:  
~~~
        IP address: 10.0.0.11  
        Network mask: 255.255.255.0 (or /24)  
        Default gateway: 10.0.0.1  
~~~

2. Configure a interface de rede editando o arquivo `/etc/network/interfaces`
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

3. Reinicie o sistema para ativar as mudanças.  
~~~
reboot
~~~

**Configurar resolução de nomes**
1. Defina o nome do host do nó para **controller**.  

2. Edite o arquivo `/etc/hosts`:
~~~
127.0.0.1       localhost
#127.0.1.1       controller

controller
10.0.0.11       controller
compute
10.0.0.31       compute
block
10.0.0.41       block
~~~

#### [Compute](https://docs.openstack.org/install-guide/environment-networking-compute.html)
Configuração de interface da máquina **compute**.  
~~~
        IP address: 10.0.0.31
        Network mask: 255.255.255.0 (or /24)
        Default gateway: 10.0.0.1
~~~

Configure a interface de rede editando o arquivo `/etc/network/interfaces`
~~~
sudo vim /etc/network/interfaces
~~~

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
sudo vim /etc/hosts
~~~

~~~
127.0.0.1       localhost
#127.0.1.1       compute

controller
10.0.0.11       controller
compute
10.0.0.31       compute
block
10.0.0.41       block
~~~

#### [Block](https://docs.openstack.org/install-guide/environment-networking-storage-cinder.html)
Configuração de interface da máquina **Block**  
>>*Mesmos passos anteriores, alterando apenas o valor final do endereço IP para o valor 41* 

### [Verificação de conectividade](https://docs.openstack.org/install-guide/environment-networking-verify.html)
~~~
ping -c 4 controller  
ping -c 4 compute  
ping -c 4 block  
~~~


### [Network Time Protocol (NTP)](https://docs.openstack.org/install-guide/environment-ntp.html)
#### Instalação e configuração de componentes

#### [Controller](https://docs.openstack.org/install-guide/environment-ntp-controller.html)
~~~
apt install chrony  
~~~

Edite o arquivo `/etc/chrony/chrony.conf`   
~~~
sudo vim /etc/chrony/chrony.conf
~~~

~~~
server NTP_SERVER iburst  
allow 10.0.0.0/24
~~~
>>*colocar endereço de NTP_SERVER válido*  

~~~
service chrony restart
~~~

#### [Outros Nós](https://docs.openstack.org/install-guide/environment-ntp-other.html)
~~~
apt install chrony
~~~

Edite o arquivo `/etc/chrony/chrony.conf`
~~~
sudo vim /etc/chrony/chrony.conf
~~~

~~~
server controller iburst
service chrony restart
~~~
>>*Comente a linha  pool 2.debian.pool.ntp.org offline iburst*   

### Verificando Operação
Execute em todas máquinas o comando.  
~~~
chronyc sources  
~~~

## [Instalação de Pacotes OpenStack no Ubuntu (Versão Queens)](https://docs.openstack.org/install-guide/environment-packages-ubuntu.html)
OpenStack Queens for Ubuntu 16.04 LTS:  
~~~
apt install software-properties-common  
add-apt-repository cloud-archive:queens  
~~~

Finalize a instalação  
~~~
apt update && apt dist-upgrade  
apt install python-openstackclient  
~~~

### [SQL Database](https://docs.openstack.org/install-guide/environment-sql-database-ubuntu.html)

A documentação do **Openstack Queens**, apresenta e utiliza o banco de dados MariaDB, porém para estudo foi utilizado o Mysql.
O tutorial apresenta guia dos dois banco de dados.    
>>*Execute os comandos que desejar (MariaDB ou Mysql) no* **Controller**. 

#### Mariadb
~~~
apt install mariadb-server python-pymysql
~~~

Crie e edite o arquivo `/etc/mysql/mariadb.conf.d/99-openstack.cnf`  
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

Finalize a instalação 
~~~
service mysql restart
mysql_secure_installation
~~~

### Mysql
~~~
apt-get install mysql-server python-pymysql
service mysql restart
~~~

### [Mensagem Queue](https://docs.openstack.org/install-guide/environment-messaging-ubuntu.html)
>>*Execute os comandos no* **Controller**.  

~~~
apt install rabbitmq-server
systemctl enable rabbitmq-server.service
systemctl start rabbitmq-server.service
rabbitmqctl add_user openstack senha
rabbitmqctl set_permissions openstack ".*" ".*" ".*"
~~~

### [Memcached](https://docs.openstack.org/install-guide/environment-memcached.html)
>>*Execute os comandos no* **Controller**.  

~~~
apt install memcached python-memcache
~~~

Edite o arquivo `/etc/memcached.conf`
~~~
vim /etc/memcached.conf
~~~  

~~~
-l 10.0.0.11
~~~

Altere a linha que possue o comando `-l 127.0.0.1`  

Restarte o serviço  
~~~
service memcached restart
~~~

### [ETCD](https://docs.openstack.org/install-guide/environment-etcd-ubuntu.html)
~~~
apt install etcd
~~~

Edite o arquivo `/etc/default/etcd`  
~~~
sudo vim /etc/default/etcd
~~~

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

### [Instalação de Serviços OpenStack](https://docs.openstack.org/install-guide/openstack-services.html)
* A seguir é apresentado os 4 principais serviços para implantação minima do Openstack na versão Queens, com mais dois serviços aconselháveis.  
* Serviço de Identidade - instalação do **keystone**.  
* Serviço de Imagem - instalação do **glance**   
* Serviço de Computação - instalação do **nova**   
* Serviço de Rede - instalação de **neutron**  

Demais serviços:  
* Dashboard - instalação do **horizon**  
* Serviço de armazenamento em bloco - instalação do **cinder**

### [Serviço de Identidade](https://docs.openstack.org/keystone/queens/install/)
#### Tutorial de instalação do keystone
>>*Execute os comandos no* **Controller**  

Acesse o banco de dados
~~~
mysql -u root -psenha

CREATE DATABASE keystone;
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' IDENTIFIED BY 'senha';
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' IDENTIFIED BY 'senha';
exit;
~~~

#### Instalar e configurar componentes
~~~
apt install keystone  apache2 libapache2-mod-wsgi
~~~

Configure o arquivo `/etc/keystone/keystone.conf`
~~~
sudo vim /etc/keystone/keystone.conf
~~~

~~~
[database]
connection = mysql+pymysql://keystone:KEYSTONE_DBPASS@controller/keystone

[token]
provider = fernet
~~~

Execute os comandos
~~~
su -s /bin/sh -c "keystone-manage db_sync" keystone
~~~

~~~
keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone  
keystone-manage credential_setup --keystone-user keystone --keystone-group keystone  

keystone-manage bootstrap --bootstrap-password senha \
  --bootstrap-admin-url http://controller:5000/v3/ \
  --bootstrap-internal-url http://controller:5000/v3/ \
  --bootstrap-public-url http://controller:5000/v3/ \
  --bootstrap-region-id RegionOne
~~~

### Configure o servidor Apache HTTP
Edite o arquivo `/etc/apache2/apache2.conf`
~~~
sudo vim /etc/apache2/apache2.conf
~~~

~~~
ServerName controller
~~~

Restart o serviço apache
~~~
service apache2 restart
~~~

Configure a conta de administração
~~~
export OS_USERNAME=admin
export OS_PASSWORD=senha
export OS_PROJECT_NAME=admin
export OS_USER_DOMAIN_NAME=Default
export OS_PROJECT_DOMAIN_NAME=Default
export OS_AUTH_URL=http://controller:5000/v3
export OS_IDENTITY_API_VERSION=3
~~~

### [Criando domínio, projeto, usuário e papéis](https://docs.openstack.org/keystone/queens/install/keystone-users-ubuntu.html)
>>Execute os comandos abaixo no **controller**.  
~~~
openstack domain create --description "An Example Domain" example
openstack project create --domain default --description "Service Project" service
openstack project create --domain default --description "Demo Project" demo
openstack user create --domain default --password senha demo
openstack role create user
openstack role add --project demo --user demo user
~~~

#### Verificando as operações
~~~
unset OS_AUTH_URL OS_PASSWORD
~~~

~~~
openstack --os-auth-url http://controller:5000/v3 \
  --os-project-domain-name Default --os-user-domain-name Default \
  --os-project-name admin --os-username admin token issue
~~~

~~~
openstack --os-auth-url http://controller:5000/v3 \
  --os-project-domain-name Default --os-user-domain-name Default \
  --os-project-name demo --os-username demo token issue
~~~

#### Criando scripts do ambiente do cliente Openstack
Criando os arquivos `admin-openrc` e `demon-openrc`.
~~~
sudo vim admin-openrc
~~~

Edite o arquivo admin-openrc
~~~
export OS_PROJECT_DOMAIN_NAME=Default
export OS_USER_DOMAIN_NAME=Default
export OS_PROJECT_NAME=admin
export OS_USERNAME=admin
export OS_PASSWORD=senha
export OS_AUTH_URL=http://controller:5000/v3
export OS_IDENTITY_API_VERSION=3
export OS_IMAGE_API_VERSION=2
~~~

~~~
sudo vim demon-openrc
~~~

Edite o arquivo demon-openrc
~~~
export OS_PROJECT_DOMAIN_NAME=Default
export OS_USER_DOMAIN_NAME=Default
export OS_PROJECT_NAME=demo
export OS_USERNAME=demo
export OS_PASSWORD=senha
export OS_AUTH_URL=http://controller:5000/v3
export OS_IDENTITY_API_VERSION=3
export OS_IMAGE_API_VERSION=2
~~~

Utilizando os scripts 
~~~
. admin-openrc
. demon-openrc
~~~

~~~
openstack token issue
~~~

## [Serviço de Image](https://docs.openstack.org/glance/queens/install/)
#### Instalação e Configuração
>>Execute os comandos abaixo no **controller**  
~~~
mysql -u root -psenha
CREATE DATABASE glance;
GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'localhost' IDENTIFIED BY 'GLANCE_DBPASS';
GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'%' IDENTIFIED BY 'GLANCE_DBPASS';
exit;
~~~

Crie as credenciais de Glance com os comandos abaixos
~~~
openstack user create --domain default --password senha glance
openstack role add --project service --user glance admin
openstack service create --name glance --description "OpenStack Image" image
openstack endpoint create --region RegionOne image public http://localhost:9292
openstack endpoint create --region RegionOne image internal http://localhost:9292
openstack endpoint create --region RegionOne image admin http://localhost:9292
~~~

### [Instale e configure os componentes](https://docs.openstack.org/glance/queens/install/install-ubuntu.html)
~~~
apt install glance
~~~

Edite o arquivo `/etc/glance/glance-api.conf`  
~~~
[database]
connection = mysql+pymysql://glance:GLANCE_DBPASS@controller/glance

[keystone_authtoken]
auth_uri = http://controller:5000
auth_url = http://controller:5000
memcached_servers = controller:11211
auth_type = password
project_domain_name = Default
user_domain_name = Default
project_name = service
username = glance
password = senha

[paste_deploy]
flavor = keystone

[glance_store]
stores = file,http
default_store = file
filesystem_store_datadir = /var/lib/glance/images/
~~~
>>*Comente ou remova demais opções da seção* `[keystone_authtoken]`  

Edite o arquivo `/etc/glance/glance-registry.conf`   
~~~
[database]
connection = mysql+pymysql://glance:GLANCE_DBPASS@controller/glance

[keystone_authtoken]
auth_uri = http://controller:5000
auth_url = http://controller:5000
memcached_servers = controller:11211
auth_type = password
project_domain_name = Default
user_domain_name = Default
project_name = service
username = glance
password = senha

[paste_deploy]
flavor = keystone
~~~

Execute o comando
~~~
su -s /bin/sh -c "glance-manage db_sync" glance
~~~

Finalize a instalação
~~~
service glance-registry restart
service glance-api restart
~~~

####  [Verificando Operação](https://docs.openstack.org/glance/queens/install/verify.html)
Download da imagem [CirrOs](http://launchpad.net/cirros)
~~~
wget http://download.cirros-cloud.net/0.4.0/cirros-0.4.0-x86_64-disk.img
~~~

Upload da imagem  
~~~
openstack image create "cirros" --file cirros-0.4.0-x86_64-disk.img --disk-format qcow2 --container-format bare --public
~~~

Confirmação do Upload da imagem  
~~~
openstack image list
~~~

## [Serviço de Compute](https://docs.openstack.org/nova/queens/install/)
#### Instalação e configurações
>>Execute os comandos abaixo no **controller**  
~~~
mysql -u root -psenha
CREATE DATABASE nova_api;
CREATE DATABASE nova;
CREATE DATABASE nova_cell0;

GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'localhost' IDENTIFIED BY 'senha';
GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'%' IDENTIFIED BY 'senha';
GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'localhost' IDENTIFIED BY 'senha';
GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'%' IDENTIFIED BY 'senha';
GRANT ALL PRIVILEGES ON nova_cell0.* TO 'nova'@'localhost' IDENTIFIED BY 'senha';
GRANT ALL PRIVILEGES ON nova_cell0.* TO 'nova'@'%' IDENTIFIED BY 'senha';
exit;
~~~

~~~
openstack user create --domain default --password senha nova
openstack role add --project service --user nova admin
openstack service create --name nova --description "OpenStack Compute" compute
openstack endpoint create --region RegionOne compute public http://localhost:8774/v2.1
openstack endpoint create --region RegionOne compute internal http://localhost:8774/v2.1
openstack endpoint create --region RegionOne compute admin http://localhost:8774/v2.1
openstack user create --domain default --password senha placement
openstack role add --project service --user placement admin
openstack service create --name placement --description "Placement API" placement
openstack endpoint create --region RegionOne placement public http://localhost:8778
openstack endpoint create --region RegionOne placement internal http://localhost:8778
openstack endpoint create --region RegionOne placement admin http://localhost:8778
~~~

#### Instale e configure componentes
~~~
apt -y install nova-api nova-conductor nova-consoleauth nova-novncproxy nova-scheduler nova-placement-api
~~~

Edite o arquivo `/etc/nova/nova.conf` 
~~~
[api_database]
connection = mysql+pymysql://nova:NOVA_DBPASS@controller/nova_api

[database]
connection = mysql+pymysql://nova:NOVA_DBPASS@controller/nova

[DEFAULT]
transport_url = rabbit://openstack:senha@controller
my_ip = 10.0.0.11
use_neutron = True
firewall_driver = nova.virt.firewall.NoopFirewallDriver

[api]
auth_strategy = keystone

[keystone_authtoken]
auth_url = http://controller:5000/v3
memcached_servers = controller:11211
auth_type = password
project_domain_name = default
user_domain_name = default
project_name = service
username = nova
password = senha

[vnc]
enabled = true
server_listen = $my_ip
server_proxyclient_address = $my_ip

[glance]
api_servers = http://controller:9292

[oslo_concurrency]
lock_path = /var/lib/nova/tmp

[placement]
os_region_name = RegionOne
project_domain_name = Default
project_name = service
auth_type = password
user_domain_name = Default
auth_url = http://controller:5000/v3
username = placement
password = senha
~~~
>>*Comente ou remova demais opções da seção* `[keystone_authtoken]`   

Execute os comandos
~~~
su -s /bin/sh -c "nova-manage api_db sync" nova
su -s /bin/sh -c "nova-manage cell_v2 map_cell0" nova
su -s /bin/sh -c "nova-manage cell_v2 create_cell --name=cell1 --verbose" nova 109e1d4b-536a-40d0-83c6-5f121b82b650
su -s /bin/sh -c "nova-manage db sync" nova
nova-manage cell_v2 list_cells
~~~

Finalize a instalação 
~~~
service nova-api restart
service nova-consoleauth restart
service nova-scheduler restart
service nova-conductor restart
service nova-novncproxy restart
~~~
 
#### Instale e configure os componentes
>>Execute os comandos abaixo no **compute**.
~~~
apt install nova-compute
~~~

Edite o arquivo `etc/nova/nova.conf`
~~~
sudo vim etc/nova/nova.conf
~~~

~~~
[DEFAULT]
transport_url = rabbit://openstack:senha@controller
my_ip = MANAGEMENT_INTERFACE_IP_ADDRESS
use_neutron = True
firewall_driver = nova.virt.firewall.NoopFirewallDriver

[api]
auth_strategy = keystone

[keystone_authtoken]
auth_url = http://controller:5000/v3
memcached_servers = controller:11211
auth_type = password
project_domain_name = default
user_domain_name = default
project_name = service
username = nova
password = senha

[vnc]
enabled = True
server_listen = 0.0.0.0
server_proxyclient_address = $my_ip
novncproxy_base_url = http://controller:6080/vnc_auto.html

[glance]
api_servers = http://controller:9292

[oslo_concurrency]
lock_path = /var/lib/nova/tmp

[placement]
os_region_name = RegionOne
project_domain_name = Default
project_name = service
auth_type = password
user_domain_name = Default
auth_url = http://controller:5000/v3
username = placement
password = senha
~~~
>>*Comente ou remova demais opções da seção* `[keystone_authtoken]`  
>>*Remova a opção* **log_dir** *da seção* `[DEFAULT]`  

Finalize a instalação
~~~
egrep -c '(vmx|svm)' /proc/cpuinfo
~~~

Edite o arquivo `/etc/nova/nova-compute.conf`
~~~
sudo vim /etc/nova/nova-compute.conf
~~~

~~~
[libvirt]
virt_type = qemu
~~~

Restarte o serviço
~~~
service nova-compute restart
~~~

#### Adicione a máquina Compute para o banco de dados do cell
>>Execute os comandos abaixo no **controller**.
~~~
openstack compute service list --service nova-compute
su -s /bin/sh -c "nova-manage cell_v2 discover_hosts --verbose" nova
~~~

#### Verificando Operação
~~~
openstack compute service list
openstack catalog list
openstack image list
nova-status upgrade check
~~~

## [Serviço de Networking](https://docs.openstack.org/neutron/queens/install/)
#### Instalação e Configuração
~~~
mysql -u root -psenha
CREATE DATABASE neutron;
GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'localhost' IDENTIFIED BY 'senha';
GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'%' IDENTIFIED BY 'senha';
exit;
~~~

~~~
openstack user create --domain default --password-prompt neutron
openstack role add --project service --user neutron admin
openstack service create --name neutron --description "OpenStack Networking" network
openstack endpoint create --region RegionOne network public http://controller:9696
openstack endpoint create --region RegionOne network internal http://controller:9696
openstack endpoint create --region RegionOne network admin http://controller:9696
~~~

#### Configurar opções de Redes
Para configuração de rede existe duas opções que permites configurar para serviços específicos:   
- Rede 1: Redes de Provedores
- Rede 2: Redes de Autoatendimento

### Rede 1: [Redes de Provedores](https://docs.openstack.org/neutron/queens/install/controller-install-option1-ubuntu.html)
#### Instalação de componentes
>>Execute os comandos abaixo no **compute**.
~~~
apt install neutron-server neutron-plugin-ml2 neutron-linuxbridge-agent neutron-dhcp-agent neutron-metadata-agent
~~~

Edite o arquivo `/etc/neutron/neutron.conf` 
~~~
sudo vim /etc/neutron/neutron.conf 
~~~

~~~
[database]
connection = mysql+pymysql://neutron:NEUTRON_DBPASS@controller/neutron

[DEFAULT]
core_plugin = ml2
service_plugins =
transport_url = rabbit://openstack:senha@controller
auth_strategy = keystone
notify_nova_on_port_status_changes = true
notify_nova_on_port_data_changes = true

[keystone_authtoken]
auth_uri = http://controller:5000
auth_url = http://controller:5000
memcached_servers = controller:11211
auth_type = password
project_domain_name = default
user_domain_name = default
project_name = service
username = neutron
password = senha

[nova]
auth_url = http://controller:5000
auth_type = password
project_domain_name = default
user_domain_name = default
region_name = RegionOne
project_name = service
username = nova
password = senha
~~~
>>*Comente ou remova demais opções da seção* `[keystone_authtoken]`  

#### Configure o Plug-in modeular Layer 2 (ML2)
Edite o arquivo `/etc/neutron/plugins/ml2/ml2_conf.ini`
~~~
sudo vim /etc/neutron/plugins/ml2/ml2_conf.ini
~~~

~~~
[ml2]
type_drivers = flat,vlan
tenant_network_types =
mechanism_drivers = linuxbridge
extension_drivers = port_security

[securitygroup]
enable_ipset = true
~~~

#### Configure o Bridge do Linux
Edite o arquivo `/etc/neutron/plugins/ml2/linuxbridge_agent.ini`
~~~
sudo vim /etc/neutron/plugins/ml2/linuxbridge_agent.ini
~~~

~~~
[linux_bridge]
physical_interface_mappings = provider:PROVIDER_INTERFACE_NAME

[vxlan]
enable_vxlan = false

[securitygroup]
enable_security_group = true
firewall_driver = neutron.agent.linux.iptables_firewall.IptablesFirewallDriver
~~~

Certifique-se de que o kernel do seu sistema operacional Linux suporta filtros de ponte de rede, verificando se todos os valores **sysctl** a seguir estão definidos como 1:
~~~
net.bridge.bridge-nf-call-iptables 
net.bridge.bridge-nf-chamada-ip6tables
~~~

#### Configurar o agente DHCP

Edite o arquivo `/etc/neutron/dhcp_agent.ini`
~~~
sudo vim /etc/neutron/dhcp_agent.ini
~~~

~~~
[DEFAULT]
interface_driver = linuxbridge
dhcp_driver = neutron.agent.linux.dhcp.Dnsmasq
enable_isolated_metadata = true
~~~

### Rede 2: [Redes de Autoatendimento](https://docs.openstack.org/neutron/queens/install/controller-install-option2-ubuntu.html)
#### Instalação de componentes
>>Execute os comandos abaixo no **controller**.
~~~
apt install neutron-server neutron-plugin-ml2 neutron-linuxbridge-agent neutron-l3-agent neutron-dhcp-agent neutron-metadata-agent
~~~

Edite o arquivo `/etc/neutron/neutron.conf` 
~~~
sudo vim /etc/neutron/neutron.conf 
~~~

~~~
[database]
connection = mysql+pymysql://neutron:NEUTRON_DBPASS@controller/neutron

[DEFAULT]
core_plugin = ml2
service_plugins = router
allow_overlapping_ips = true
transport_url = rabbit://openstack:senha@controller
auth_strategy = keystone
notify_nova_on_port_status_changes = true
notify_nova_on_port_data_changes = true


[keystone_authtoken]
auth_uri = http://controller:5000
auth_url = http://controller:5000
memcached_servers = controller:11211
auth_type = password
project_domain_name = default
user_domain_name = default
project_name = service
username = neutron
password = senha

[nova]
auth_url = http://controller:5000
auth_type = password
project_domain_name = default
user_domain_name = default
region_name = RegionOne
project_name = service
username = nova
password = senha
~~~
>>*Comente ou remova demais opções da seção* `[keystone_authtoken]` 

#### Configure o Plug-in modeular Layer 2 (ML2)

Edite o arquivo `/etc/neutron/plugins/ml2/ml2_conf.ini`
~~~
sudo vim /etc/neutron/plugins/ml2/ml2_conf.ini
~~~

~~~
[ml2]
type_drivers = flat,vlan, vxlan
tenant_network_types = vxlan
mechanism_drivers = linuxbridge,l2population
extension_drivers = port_security

[ml2_type_flat]
flat_networks = provider

[ml2_type_vxlan]
vni_ranges = 1:1000

[securitygroup]
enable_ipset = true
~~~

#### Configure o Bridge do Linux 

Edite o arquivo `/etc/neutron/plugins/ml2/linuxbridge_agent.ini`
~~~
sudo vim /etc/neutron/plugins/ml2/linuxbridge_agent.ini
~~~

~~~
[linux_bridge]
physical_interface_mappings = provider:PROVIDER_INTERFACE_NAME

[vxlan]
enable_vxlan = true
local_ip = OVERLAY_INTERFACE_IP_ADDRESS
l2_population = true

[securitygroup]
enable_security_group = true
firewall_driver = neutron.agent.linux.iptables_firewall.IptablesFirewallDriver
~~~

Certifique-se de que o kernel do seu sistema operacional Linux suporta filtros de ponte de rede, verificando se todos os valores **sysctl** a seguir estão definidos como 1:
~~~
net.bridge.bridge-nf-call-iptables 
net.bridge.bridge-nf-chamada-ip6tables
~~~

#### Configure o layer-3

Edite o arquivo `/etc/neutron/l3_agent.ini`
~~~
sudo vim /etc/neutron/l3_agent.ini
~~~

~~~
[DEFAULT]
interface_driver = linuxbridge
~~~

#### Configure o agente DHCP

Edite o arquivo `/etc/neutron/dhcp_agent.ini`
~~~
sudo vim /etc/neutron/dhcp_agent.ini
~~~

~~~
[DEFAULT]
interface_driver = linuxbridge
dhcp_driver = neutron.agent.linux.dhcp.Dnsmasq
enable_isolated_metadata = true
~~~

#### Configure o agente de metadados 

Edite o arquivo `/etc/neutron/metadata_agent.ini` 
~~~
sudo vim /etc/neutron/metadata_agent.ini
~~~

~~~
[DEFAULT]
nova_metadata_host = controller
metadata_proxy_shared_secret = METADATA_SECRET
~~~


#### Configure o serviço do Compute para usar o serviço de rede
Edite o arquivo `/etc/nova/nova.conf`
~~~
sudo vim /etc/nova/nova.conf
~~~

~~~
[neutron]
url = http://controller:9696
auth_url = http://controller:5000
auth_type = password
project_domain_name = default
user_domain_name = default
region_name = RegionOne
project_name = service
username = neutron
password = senha
service_metadata_proxy = true
metadata_proxy_shared_secret = METADATA_SECRET
~~~

#### Finalize a instalação
Preencha o banco de dados:  
~~~
su -s /bin/sh -c "neutron-db-manage --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/plugins/ml2/ml2_conf.ini upgrade head" neutron
~~~

Reinicie o serviço da Compute API: 
~~~
service nova-api restart
~~~

Reinicie os serviços de rede, para ambas as opções de rede (Rede 1 ou Rede 2):  
~~~
service neutron-server restart
service neutron-linuxbridge-agent restart
service neutron-dhcp-agent restart
service neutron-metadata-agent restart
~~~

Para a opção de Rede 2, reinicie também o serviço de camada 3:  
~~~
service neutron-l3-agent restart
~~~

## [Dashboard](https://docs.openstack.org/horizon/queens/install/)
#### Guia de instalação
Instale e configure os componentes da rede no **controller**.

#### [Instalação e configuração](https://docs.openstack.org/horizon/queens/install/install-ubuntu.html)
Instale o dashboard
~~~
apt install openstack-dashboard
~~~

Edite o arquivo `/etc/openstack-dashboard/local_settings.py`
~~~
sudo vim /etc/openstack-dashboard/local_settings.py
~~~
~~~
OPENSTACK_HOST = "controller"
ALLOWED_HOSTS = ['one.example.com', 'two.example.com']

SESSION_ENGINE = 'django.contrib.sessions.backends.cache'

CACHES = {
    'default': {
         'BACKEND': 'django.core.cache.backends.memcached.MemcachedCache',
         'LOCATION': 'controller:11211',
    }
}

OPENSTACK_KEYSTONE_URL = "http://%s:5000/v3" % OPENSTACK_HOST

OPENSTACK_KEYSTONE_MULTIDOMAIN_SUPPORT = True

OPENSTACK_API_VERSIONS = {
    "identity": 3,
    "image": 2,
    "volume": 2,
}

OPENSTACK_KEYSTONE_DEFAULT_DOMAIN = "Default"

OPENSTACK_KEYSTONE_DEFAULT_ROLE = "user"
~~~
- Não edite o parâmetro **ALLOWED_HOSTS** na seção de configuração do Ubuntu.  
- **ALLOWED_HOSTS** também pode ser ['*'] para aceitar todos os hosts. Isso pode ser útil para o trabalho de desenvolvimento, mas é potencialmente inseguro e não deve ser usado na produção. 
>> Comente qualquer outra configuração de armazenamento de sessão.  

Caso tenha escolhido a opção de Rede 1, desative o suporte para Layer-3 do serviço de Rede:
~~~
OPENSTACK_NEUTRON_NETWORK = {
    ...
    'enable_router': False,
    'enable_quotas': False,
    'enable_ipv6': False,
    'enable_distributed_router': False,
    'enable_ha_router': False,
    'enable_lb': False,
    'enable_firewall': False,
    'enable_vpn': False,
    'enable_fip_topology_check': False,
}
~~~

~~~
TIME_ZONE = "TIME_ZONE"
~~~

Edite o arquivo `/etc/apache2/conf-available/openstack-dashboard.conf`
~~~
sudo vim /etc/apache2/conf-available/openstack-dashboard.conf 
~~~

Inclua a seguinte linha
~~~
WSGIApplicationGroup %{GLOBAL}
~~~

#### Finalize a instalação
service apache2 reload

### [Verificando Operação](https://docs.openstack.org/horizon/queens/install/verify-ubuntu.html)
Acesse o painel usando um navegador Web em http://controller/horizon.  
Acesse usando **admin** ou **demo user** e credenciais **default** de domínio.

### [Serviço de Armazenamento de Bloco](https://docs.openstack.org/cinder/queens/install/)
#### Instalação e configuração
>> Execute estas etapas no nó de armazenamento (**Block**).  

~~~
apt install lvm2 thin-provisioning-tools
~~~

Crie o volume `/dev/sdb`
~~~
pvcreate /dev/sdb
vgcreate cinder-volumes /dev/sdb
~~~

Edite o arquivo `/etc/lvm/lvm.conf` 
~~~
sudo vim /etc/lvm/lvm.conf 
~~~
~~~
devices {
filter = [ "a/sdb/", "r/.*/"]
~~~

### Instale e configure os componentes - Máquina Block
Instale e configure os componentes da rede no **Block**.  
~~~
apt install cinder-volume
~~~

Edite o arquivo `/etc/cinder/cinder.conf` 
~~~
sudo vim /etc/cinder/cinder.conf 
~~~
~~~
[database]
connection = mysql+pymysql://cinder:CINDER_DBPASS@controller/cinder

[DEFAULT]
transport_url = rabbit://openstack:senha@controller
auth_strategy = keystone
my_ip = 10.0.0.41
enabled_backends = lvm
glance_api_servers = http://controller:9292

[keystone_authtoken]
auth_uri = http://controller:5000
auth_url = http://controller:5000
memcached_servers = controller:11211
auth_type = password
project_domain_id = default
user_domain_id = default
project_name = service
username = cinder
password = senha

[lvm]
volume_driver = cinder.volume.drivers.lvm.LVMVolumeDriver
volume_group = cinder-volumes
iscsi_protocol = iscsi
iscsi_helper = tgtadm

[oslo_concurrency]
lock_path = /var/lib/cinder/tmp
~~~
>>*Comente ou remova demais opções da seção* `[keystone_authtoken]`

#### Finalize a instalação
~~~
service tgt restart
service cinder-volume restart
~~~

### [Instale e configure os componentes - Máquina Controller](https://docs.openstack.org/cinder/queens/install/cinder-controller-install-ubuntu.html)
Instale e configure os componentes da rede no **Controller**.  
~~~
mysql -u root -psenha
CREATE DATABASE cinder;
GRANT ALL PRIVILEGES ON cinder.* TO 'cinder'@'localhost' IDENTIFIED BY 'CINDER_DBPASS';
GRANT ALL PRIVILEGES ON cinder.* TO 'cinder'@'%' IDENTIFIED BY 'CINDER_DBPASS';
exit;
~~~

~~~
. admin-openrc
~~~

~~~
openstack user create --domain default --password-prompt cinder
openstack role add --project service --user cinder admin
openstack service create --name cinderv2 --description "OpenStack Block Storage" volumev2
openstack service create --name cinderv3 --description "OpenStack Block Storage" volumev3
openstack endpoint create --region RegionOne volumev2 public http://controller:8776/v2/%\(project_id\)s
openstack endpoint create --region RegionOne volumev2 internal http://controller:8776/v2/%\(project_id\)s
openstack endpoint create --region RegionOne volumev2 admin http://controller:8776/v2/%\(project_id\)s
openstack endpoint create --region RegionOne volumev3 public http://controller:8776/v3/%\(project_id\)s
openstack endpoint create --region RegionOne volumev3 internal http://controller:8776/v3/%\(project_id\)s
openstack endpoint create --region RegionOne volumev3 admin http://controller:8776/v3/%\(project_id\)s
~~~

#### Instalação e configuração de componentes
~~~
apt install cinder-api cinder-scheduler
~~~

Edite o arquivo `/etc/cinder/cinder.conf`
~~~
sudo vim /etc/cinder/cinder.conf
~~~

~~~
[database]
connection = mysql+pymysql://cinder:CINDER_DBPASS@controller/cinder

[DEFAULT]
transport_url = rabbit://openstack:senha@controller
auth_strategy = keystone
my_ip = 10.0.0.11

[keystone_authtoken]
auth_uri = http://controller:5000
auth_url = http://controller:5000
memcached_servers = controller:11211
auth_type = password
project_domain_id = default
user_domain_id = default
project_name = service
username = cinder
password = senha

[oslo_concurrency]
lock_path = /var/lib/cinder/tmp
~~~

~~~
su -s /bin/sh -c "cinder-manage db sync" cinder
~~~

#### Configure compute para usar o armazenamento em Bloco
Edite o arquivo `etc/nova/nova.conf`
~~~
sudo vim etc/nova/nova.conf
~~~

~~~
[cinder]
os_region_name = RegionOne
~~~

#### Finalize a instalação
~~~
service nova-api restart
service cinder-scheduler restart
service apache2 restart
~~~

### [Instale e configure o serviço de backup (Opcional)](https://docs.openstack.org/cinder/queens/install/cinder-backup-install-ubuntu.html)
Instale e configure os componentes da rede no **Block**.
~~~
apt install cinder-backup
~~~

Edite o arquivo  `/etc/cinder/cinder.conf` 
~~~
sudo vim  /etc/cinder/cinder.conf 
~~~

~~~
[DEFAULT]
backup_driver = cinder.backup.drivers.swift
backup_swift_url = SWIFT_URL
~~~

~~~
openstack catalog show object-store
~~~

#### Finalize a instalação
~~~
service cinder-backup restart
~~~

### [Verificando Openração Cinder](https://docs.openstack.org/cinder/queens/install/cinder-verify.html)
Verificando a operação do serviço de armazenamento em bloco.  
~~~
openstack volume service list
~~~