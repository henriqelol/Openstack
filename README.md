# Instalação do OpenStack Ironic e Kolla-Ansible
Este documento apresenta os links conforme foi implementado passo a passo a instalação do [**Openstack Ironic**](https://docs.openstack.org/ironic/latest/) e [**Openstack Kolla-Ansible**](https://docs.openstack.org/kolla-ansible/latest/).


## Guia de Instalação do OpenStack
Toda documentação foi feita a partir do [Guia de Instalação](https://docs.openstack.org/install-guide/), a versão utilizada foi a  [**queens**](https://www.openstack.org/software/queens/).  

***
### Máquina Servidor
Para instalação de Openstack, foi utilizado um servidor com as seguintes configurações:  
**Configurações de Hardware**: Processador: 8 Núcleos; Memória: 16 GB; HD: 1TB.  
**Configurações de Software**: Sistema: Ubuntu 16.04    
**Programas utilizados**:  
VirtualBox - *Versão 5.2.22 r126460 (Qt5.6.1)*.   
Vagrant - *Versão 2.2.1*.    
>>*Toda instalação de ambiente foi através de acesso SSH -X*.
***

### [Ambientes criados no VirtualBox/Vagrant](https://github.com/henriqelol/Openstack/blob/master/vagrant_virtualbox.md)
Para criações das VMs, utilizando [**VAGRANT**](https://github.com/henriqelol/Openstack/blob/master/vagrant_virtualbox.md) ou [**VIRTUALBOX**](https://github.com/henriqelol/Openstack/blob/master/vagrant_virtualbox.md), basta acessar o link e seguir os passos apresentados:

**Configurações das VMs: Controller/Compute/Block:**  
Processador: 4 Núcleos; Memória: 10 GB; HD: 40GB, Placa de Rede 1: host-only (vboxnet0), brigde enp10f0.  
***

### [Configuração de Rede do Ambiente](https://docs.openstack.org/install-guide/environment-networking.html)
Rede de hosts, com valores de interfaces e ips.  
![Plano de Rede](https://docs.openstack.org/install-guide/_images/networklayout.png)
***

### [Controller](https://docs.openstack.org/install-guide/environment-networking-controller.html)
**Configurar interfaces de rede**
1. Configure a primeira interface como a interface de gerenciamento:  
~~~
        IP address: 10.0.0.11  
        Network mask: 255.255.255.0 (or /24)  
        Default gateway: 10.0.0.1  
~~~

2. Configure a interface de rede editando o arquivo `/etc/network/interfaces`:
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

3. Reinicie o sistema para ativar as mudanças:  
~~~
reboot
~~~

**Configurar nomes**
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
***

### [Compute](https://docs.openstack.org/install-guide/environment-networking-compute.html)
**Configurar interfaces de rede**
1. Configure a primeira interface como a interface de gerenciamento: 
~~~
        IP address: 10.0.0.31
        Network mask: 255.255.255.0 (or /24)
        Default gateway: 10.0.0.1
~~~

2. Configure a interface de rede editando o arquivo `/etc/network/interfaces`:
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
3. Reinicie o sistema para ativar as mudanças:  
~~~
reboot
~~~

**Configurar nomes**
1. Defina o nome do host do nó para **compute**.  

2. Edite o arquivo `/etc/hosts`:
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
***

### [Block](https://docs.openstack.org/install-guide/environment-networking-storage-cinder.html)
**Configurar interfaces de rede**
>>Configuração de interface da máquina **block**. 
>>*Mesmos passos anteriores, alterando apenas o valor final do endereço IP para o valor 41*. 
***

### [Verificação de conectividade](https://docs.openstack.org/install-guide/environment-networking-verify.html)
1. Teste o acesso da rede entre os nós executando os comandos em todos:
~~~
ping -c 4 controller  
ping -c 4 compute  
ping -c 4 block  
~~~
***
***

### [Network Time Protocol (NTP)](https://docs.openstack.org/install-guide/environment-ntp.html)
Para sincronizar corretamente os serviços entre nós, é preciso instalar o Chrony, uma implementação do NTP.  

#### [Controller](https://docs.openstack.org/install-guide/environment-ntp-controller.html)
1. Instale os pacotes:
~~~
apt install chrony  
~~~

2. Edite o arquivo `/etc/chrony/chrony.conf`:   
~~~
server NTP_SERVER iburst  
allow 10.0.0.0/24
~~~
>>*colocar endereço de NTP_SERVER válido*  

3. Reinicie o serviço NTP:
~~~
service chrony restart
~~~

#### [Outros Nós](https://docs.openstack.org/install-guide/environment-ntp-other.html)
1. Instale os pacotes:
~~~
apt install chrony
~~~

2. Edite o arquivo `/etc/chrony/chrony.conf`.
~~~
server controller iburst
~~~
>>*Comente a linha  pool 2.debian.pool.ntp.org offline iburst*   

3. Reinicie o serviço NTP:
~~~
service chrony restart
~~~
***

#### [Verificando Operação](https://docs.openstack.org/install-guide/environment-ntp-verify.html)
1. Execute em todas máquinas o comando.  
~~~
chronyc sources  
~~~
***
***

## [Instalação de Pacotes OpenStack no Ubuntu (Versão Queens)](https://docs.openstack.org/install-guide/environment-packages-ubuntu.html)
**OpenStack Queens for Ubuntu 16.04 LTS:**  
~~~
apt install software-properties-common  
add-apt-repository cloud-archive:queens  
~~~

#### Finalize a instalação
1. Atualize os pacotes em todos os nós:
~~~
apt update && apt dist-upgrade  
~~~
>>Se o processo de atualização incluir um novo kernel, reinicie seu host para ativá-lo.

2. Instale o cliente OpenStack:
~~~
apt install python-openstackclient  
~~~
***

### [SQL Database](https://docs.openstack.org/install-guide/environment-sql-database-ubuntu.html)
A documentação do **Openstack Queens**, apresenta e utiliza o banco de dados MariaDB, porém para estudo foi utilizado o Mysql.
O tutorial apresenta guia dos dois banco de dados.    
>>*Execute os comandos que desejar (MariaDB ou Mysql) no* **Controller**. 

#### Mariadb
1. Instale os pacotes:
~~~
apt install mariadb-server python-pymysql
~~~

2. Crie e edite o arquivo `/etc/mysql/mariadb.conf.d/99-openstack.cnf`  
~~~ 
[mysqld]
bind-address = 10.0.0.11

default-storage-engine = innodb
innodb_file_per_table = on
max_connections = 4096
collation-server = utf8_general_ci
character-set-server = utf8
~~~

3. Reinicie o serviço de banco de dados, e escolha uma senha segura: 
~~~
service mysql restart
mysql_secure_installation
~~~

#### Mysql

1. Instale os pacotes:
~~~
apt-get install mysql-server python-pymysql
~~~

2. Reinicie o serviço de banco de dados:
~~~
service mysql restart
~~~
***

### [Mensagem Queue](https://docs.openstack.org/install-guide/environment-messaging-ubuntu.html)
>>*Execute os comandos no* **Controller**.  

1. Instale o pacote:
~~~
apt install rabbitmq-server
~~~

2. Adicione o usuário **openstack** e permita configuração, gravação e acesso de leitura:
~~~
rabbitmqctl add_user openstack senha
rabbitmqctl set_permissions openstack ".*" ".*" ".*"
~~~

3. Restarte o serviço rabbitmq
~~~
systemctl enable rabbitmq-server.service
systemctl start rabbitmq-server.service
~~~
***

### [Memcached](https://docs.openstack.org/install-guide/environment-memcached.html)
>>*Execute os comandos no* **Controller**.  

1. Instale o pacote:
~~~
apt install memcached python-memcache
~~~

2. Edite o arquivo `/etc/memcached.conf`.
~~~
-l 10.0.0.11
~~~
>>Altere a linha que possue o comando `-l 127.0.0.1`  

3. Restarte o serviço:  
~~~
service memcached restart
~~~
***

### [ETCD](https://docs.openstack.org/install-guide/environment-etcd-ubuntu.html)
>>*Execute os comandos no* **Controller**.  

1. Instale o pacote:
~~~
apt install etcd
~~~

2. Edite o arquivo `/etc/default/etcd`  
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

3. Ative e inicie o serviço do etcd:  
~~~
systemctl enable etcd
systemctl start etcd
~~~
***
***

## [Instalação de Serviços OpenStack](https://docs.openstack.org/install-guide/openstack-services.html)
No mínimo, você precisa instalar os seguintes serviços. Instale os serviços na ordem especificada abaixo:  
* Serviço de Identidade - instalação do **Keystone**.  
* Serviço de Imagem - instalação do **Glance**   
* Serviço de Computação - instalação do **Nova**   
* Serviço de Rede - instalação de **Neutron**  

Aconselhamos também instalar os seguintes componentes depois de instalar os serviços de implantação mínimos: 
* Dashboard - instalação do **Horizon**  
* Serviço de armazenamento em bloco - instalação do **Cinder**
***

### [Serviço de Identidade - Instalação do Keystone](https://docs.openstack.org/keystone/queens/install/)
>>*Execute os comandos no* **Controller**  

#### Pré-requisitos

1. Acesse e crie um banco de dados para **keystone**:
~~~
mysql -u root -psenha

CREATE DATABASE keystone;
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' IDENTIFIED BY 'senha';
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' IDENTIFIED BY 'senha';
exit;
~~~

#### Instalar e configurar componentes
1. Instale os pacotes: 
~~~
apt install keystone  apache2 libapache2-mod-wsgi
~~~

2. Configure o arquivo `/etc/keystone/keystone.conf`
~~~
[database]
connection = mysql+pymysql://keystone:senha@controller/keystone

[token]
provider = fernet
~~~
>>*Comente ou remova quaisquer outras opções na seção [database].*

3. Preencha o banco de dados do serviço de identidade:
~~~
su -s /bin/sh -c "keystone-manage db_sync" keystone
~~~

4. Inicialize os repositórios de keys:
~~~
keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone  
keystone-manage credential_setup --keystone-user keystone --keystone-group keystone  
~~~

5. Inicialize o serviço de identidade:
~~~
keystone-manage bootstrap --bootstrap-password senha \
  --bootstrap-admin-url http://controller:5000/v3/ \
  --bootstrap-internal-url http://controller:5000/v3/ \
  --bootstrap-public-url http://controller:5000/v3/ \
  --bootstrap-region-id RegionOne
~~~

#### Configure o servidor Apache HTTP
1. Edite o arquivo `/etc/apache2/apache2.conf`
~~~
ServerName controller
~~~

2. Restart o serviço apache
~~~
service apache2 restart
~~~

3. Configure a conta de administração
~~~
export OS_USERNAME=admin
export OS_PASSWORD=senha
export OS_PROJECT_NAME=admin
export OS_USER_DOMAIN_NAME=Default
export OS_PROJECT_DOMAIN_NAME=Default
export OS_AUTH_URL=http://controller:5000/v3
export OS_IDENTITY_API_VERSION=3
~~~

### [Criando domain, projects, users, e roles](https://docs.openstack.org/keystone/queens/install/keystone-users-ubuntu.html)
>>Execute os comandos abaixo no **controller**.  

1. Execute os comandos para criar um dominio, um projeto de serviço, um usuário:
~~~
openstack domain create --description "An Example Domain" example
openstack project create --domain default --description "Service Project" service
openstack project create --domain default --description "Demo Project" demo
openstack user create --domain default --password senha demo
openstack role create user
openstack role add --project demo --user demo user
~~~
>>*Você pode repetir este procedimento para criar projetos e usuários adicionais.*

#### [Verificando as operações](https://docs.openstack.org/keystone/queens/install/keystone-verify-ubuntu.html)
1. Desative as variáveis temporárias:
~~~
unset OS_AUTH_URL OS_PASSWORD
~~~

2. Execute os seguintes comandos
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

#### [Criando scripts do ambiente do cliente Openstack](https://docs.openstack.org/keystone/queens/install/keystone-openrc-ubuntu.html)
1. Criando os arquivos `admin-openrc` e `demon-openrc`.

2. Crie e edite o admin-openrc
~~~
vim admin-openrc
~~~

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

3. Crie e edite o demon-openrc
~~~
vim demon-openrc
~~~

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

#### Utilizando os scripts 
1. Carregue os scripts
~~~
. admin-openrc
. demon-openrc
~~~

2. Solicite um token de autenticação
~~~
openstack token issue
~~~
***

### [Serviço de Image - Instalação do Glance](https://docs.openstack.org/glance/queens/install/)
#### [Instalação e configuração](https://docs.openstack.org/glance/queens/install/install-ubuntu.html)
>>Execute os comandos abaixo no **controller**  

1. Para criar o banco de dados, conclua estas etapas:
~~~
mysql -u root -psenha
CREATE DATABASE glance;
GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'localhost' IDENTIFIED BY 'senha';
GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'%' IDENTIFIED BY 'senha';
exit;
~~~

2. Crie as credenciais de Glance com os comandos abaixos
~~~
openstack user create --domain default --password senha glance
openstack role add --project service --user glance admin
openstack service create --name glance --description "OpenStack Image" image
openstack endpoint create --region RegionOne image public http://localhost:9292
openstack endpoint create --region RegionOne image internal http://localhost:9292
openstack endpoint create --region RegionOne image admin http://localhost:9292
~~~

#### Instale e configure os componentes
1. Instale o pacote:
~~~
apt install glance
~~~

2. Edite o arquivo `/etc/glance/glance-api.conf`  
~~~
[database]
connection = mysql+pymysql://glance:senha@controller/glance

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

3. Edite o arquivo `/etc/glance/glance-registry.conf`   
~~~
[database]
connection = mysql+pymysql://glance:senha@controller/glance

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

4. Preencha o banco de dados do serviço de imagem:
~~~
su -s /bin/sh -c "glance-manage db_sync" glance
~~~
>>*Ignore todas as mensagens de reprovação nesta saída.*  

#### Finalize a instalação
1. Reinicie os serviços de imagem:  
~~~
service glance-registry restart
service glance-api restart
~~~

####  [Verificando Operação](https://docs.openstack.org/glance/queens/install/verify.html)
1. Download da imagem [CirrOs](http://launchpad.net/cirros)
~~~
wget http://download.cirros-cloud.net/0.4.0/cirros-0.4.0-x86_64-disk.img
~~~

2. Upload da imagem  
~~~
openstack image create "cirros" \
--file cirros-0.4.0-x86_64-disk.img \
--disk-format qcow2 --container-format bare \
--public
~~~

3. Confirmação do Upload da imagem  
~~~
openstack image list
~~~
***

### [Serviço de Computação - Instalação do Nova](https://docs.openstack.org/nova/queens/install/)
#### [Instalação e configuração do controller](https://docs.openstack.org/nova/queens/install/controller-install-ubuntu.html)
>>Execute os comandos abaixo no **controller**.  

1. Para criar os bancos de dados, conclua estas etapas:
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

3. Crie as credenciais de serviço de computação:
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

#### Instalação e configuração dos componentes
1. Instale os pacotes:
~~~
apt -y install nova-api nova-conductor nova-consoleauth nova-novncproxy nova-scheduler nova-placement-api
~~~

2. Edite o arquivo `/etc/nova/nova.conf` 
~~~
[api_database]
connection = mysql+pymysql://nova:senha@controller/nova_api

[database]
connection = mysql+pymysql://nova:senha@controller/nova

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
>>*Comente ou remova demais opções da seção* `[keystone_authtoken]`.  

3. Execute os comandos:
~~~
su -s /bin/sh -c "nova-manage api_db sync" nova
su -s /bin/sh -c "nova-manage cell_v2 map_cell0" nova
su -s /bin/sh -c "nova-manage cell_v2 create_cell --name=cell1 --verbose" nova 109e1d4b-536a-40d0-83c6-5f121b82b650
su -s /bin/sh -c "nova-manage db sync" nova
nova-manage cell_v2 list_cells
~~~

4. Finalize a instalação, restarte os serviços: 
~~~
service nova-api restart
service nova-consoleauth restart
service nova-scheduler restart
service nova-conductor restart
service nova-novncproxy restart
~~~
 
#### [Instalação e configuração do compute](https://docs.openstack.org/nova/queens/install/compute-install.html)
>>Execute os comandos abaixo no **compute**.

1. Instale os pacotes:
~~~
apt install nova-compute
~~~

2. Edite o arquivo `etc/nova/nova.conf`
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

3. Finalize a instalação
~~~
egrep -c '(vmx|svm)' /proc/cpuinfo
~~~

4. Edite o arquivo `/etc/nova/nova-compute.conf`
~~~
[libvirt]
virt_type = qemu
~~~

5. Restarte o serviço
~~~
service nova-compute restart
~~~

#### Adicione a máquina Compute para o banco de dados do cell
>>Execute os comandos abaixo no **controller**.
~~~
openstack compute service list --service nova-compute
su -s /bin/sh -c "nova-manage cell_v2 discover_hosts --verbose" nova
~~~
>>Alternativamente, você pode definir um intervalo apropriado em: /etc/nova/nova.conf:
~~~
[scheduler]
discover_hosts_in_cells_interval = 300
~~~

#### Verificando Operação
1. Execute os comandos abaixo para listar:
~~~
openstack compute service list
openstack catalog list
openstack image list
nova-status upgrade check
~~~
***

### [Serviço de Networking - Instalação do Neutron](https://docs.openstack.org/neutron/queens/install/)
#### [Instalação e configuração do controller](https://docs.openstack.org/neutron/queens/install/controller-install-obs.html)

1. Para criar o banco de dados, conclua estas etapas:
~~~
mysql -u root -psenha
CREATE DATABASE neutron;
GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'localhost' IDENTIFIED BY 'senha';
GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'%' IDENTIFIED BY 'senha';
exit;
~~~

2. Para criar as credenciais de serviço, conclua estas etapas:
~~~
openstack user create --domain default --password-prompt neutron
openstack role add --project service --user neutron admin
openstack service create --name neutron --description "OpenStack Networking" network
openstack endpoint create --region RegionOne network public http://controller:9696
openstack endpoint create --region RegionOne network internal http://controller:9696
openstack endpoint create --region RegionOne network admin http://controller:9696
~~~

#### Configurar opções de Redes - Controller
Para configuração de rede existe duas opções que permites configurar para serviços específicos:   
- [Rede 1: Redes de Provedores](https://docs.openstack.org/neutron/queens/install/controller-install-option1-ubuntu.html)
- [Rede 2: Redes de Autoatendimento](https://docs.openstack.org/neutron/queens/install/controller-install-option2-ubuntu.html)

***
### [Rede 1: Redes de Provedores](https://docs.openstack.org/neutron/queens/install/controller-install-option1-ubuntu.html)
#### Instalação de componentes
>>Execute os comandos abaixo no **controller**.  

1. Instale os pacotes:
~~~
apt install neutron-server neutron-plugin-ml2 \
neutron-linuxbridge-agent neutron-dhcp-agent \
neutron-metadata-agent
~~~

2. Edite o arquivo `/etc/neutron/neutron.conf` 
~~~
[database]
connection = mysql+pymysql://neutron:senha@controller/neutron

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

1. Edite o arquivo `/etc/neutron/plugins/ml2/ml2_conf.ini`
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
1. Edite o arquivo `/etc/neutron/plugins/ml2/linuxbridge_agent.ini`
~~~
[linux_bridge]
physical_interface_mappings = provider:PROVIDER_INTERFACE_NAME

[vxlan]
enable_vxlan = false

[securitygroup]
enable_security_group = true
firewall_driver = neutron.agent.linux.iptables_firewall.IptablesFirewallDriver
~~~

2. Certifique-se de que o kernel do seu sistema operacional Linux suporta filtros de ponte de rede, verificando se todos os valores **sysctl** a seguir estão definidos como 1:
~~~
net.bridge.bridge-nf-call-iptables 
net.bridge.bridge-nf-chamada-ip6tables
~~~

#### Configurar o agente DHCP

1. Edite o arquivo `/etc/neutron/dhcp_agent.ini`
~~~
[DEFAULT]
interface_driver = linuxbridge
dhcp_driver = neutron.agent.linux.dhcp.Dnsmasq
enable_isolated_metadata = true
~~~
>> Retornar para a configuração do nó controlador de rede.
***

### [Rede 2: Redes de Autoatendimento](https://docs.openstack.org/neutron/queens/install/controller-install-option2-ubuntu.html)
#### Instalação de componentes
>>Execute os comandos abaixo no **controller**.

1. Instale os pacotes:
~~~
apt install neutron-server neutron-plugin-ml2 \
neutron-linuxbridge-agent neutron-l3-agent neutron-dhcp-agent \
neutron-metadata-agent
~~~

2. Edite o arquivo `/etc/neutron/neutron.conf` 
~~~
[database]
connection = mysql+pymysql://neutron:senha@controller/neutron

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

1. Edite o arquivo `/etc/neutron/plugins/ml2/ml2_conf.ini`
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

1. Edite o arquivo `/etc/neutron/plugins/ml2/linuxbridge_agent.ini`
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

2. Certifique-se de que o kernel do seu sistema operacional Linux suporta filtros de ponte de rede, verificando se todos os valores **sysctl** a seguir estão definidos como 1:
~~~
net.bridge.bridge-nf-call-iptables 
net.bridge.bridge-nf-chamada-ip6tables
~~~

#### Configure o layer-3

1. Edite o arquivo `/etc/neutron/l3_agent.ini`
~~~
[DEFAULT]
interface_driver = linuxbridge
~~~

#### Configure o agente DHCP

1. Edite o arquivo `/etc/neutron/dhcp_agent.ini`
~~~
[DEFAULT]
interface_driver = linuxbridge
dhcp_driver = neutron.agent.linux.dhcp.Dnsmasq
enable_isolated_metadata = true
~~~
>> Retornar para a configuração do nó controlador de rede.
***

#### Configure o agente de metadados 

1. Edite o arquivo `/etc/neutron/metadata_agent.ini` 
~~~
[DEFAULT]
nova_metadata_host = controller
metadata_proxy_shared_secret = METADATA_SECRET
~~~

#### Configure o serviço do Compute para usar o serviço de rede

1. Edite o arquivo `/etc/nova/nova.conf`
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

1. Preencha o banco de dados:  
~~~
su -s /bin/sh -c "neutron-db-manage --config-file /etc/neutron/neutron.conf \
--config-file /etc/neutron/plugins/ml2/ml2_conf.ini upgrade head" neutron
~~~

2. Reinicie o serviço da Compute API: 
~~~
service nova-api restart
~~~

3. Reinicie os serviços de rede, para ambas as opções de rede (Rede 1 ou Rede 2):  
~~~
service neutron-server restart
service neutron-linuxbridge-agent restart
service neutron-dhcp-agent restart
service neutron-metadata-agent restart
~~~

4. Para a opção de **Rede 2**, reinicie também o serviço de camada 3:  
~~~
service neutron-l3-agent restart
~~~
***

#### [Instalação e configuração do compute](https://docs.openstack.org/neutron/queens/install/compute-install-ubuntu.html)
>>Execute os comandos abaixo no **compute**.

1. Instale os pacotes:  
`apt install neutron-linuxbridge-agent`

2. Edite o arquivo `/etc/neutron/neutron.conf`:
~~~
[DEFAULT]
transport_url = rabbit://openstack:RABBIT_PASS@controller
auth_strategy = keystone

[keystone_authtoken]
auth_uri = http://controller:5000
auth_url = http://controller:5000
memcached_servers = controller:11211
auth_type = password
project_domain_name = default
user_domain_name = default
project_name = service
username = neutron
password = NEUTRON_PASS
~~~
>>Comente ou remova quaisquer outras opções na seção [keystone_authtoken].

#### Configurar opções de Redes - Compute
Escolha a mesma opção de rede escolhida para o nó do controlador para configurar serviços específicos para ele. 
- [Rede 1: Redes de Provedores](https://docs.openstack.org/neutron/queens/install/compute-install-option1-ubuntu.html)
- [Rede 2: Redes de Autoatendimento](https://docs.openstack.org/neutron/queens/install/compute-install-option2-ubuntu.html)

***
### [Rede 1: Redes de Provedores](https://docs.openstack.org/neutron/queens/install/compute-install-option1-ubuntu.html)
#### Configure o Bridge do Linux 

1. Edite o arquivo `/etc/neutron/plugins/ml2/linuxbridge_agent.ini`
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

2. Certifique-se de que o kernel do seu sistema operacional Linux suporta filtros de ponte de rede, verificando se todos os valores **sysctl** a seguir estão definidos como 1:
~~~
net.bridge.bridge-nf-call-iptables 
net.bridge.bridge-nf-chamada-ip6tables
~~~
>>Retornar à configuração do nó compute de rede.
***

### [Rede 2: Redes de Autoatendimento](https://docs.openstack.org/neutron/queens/install/compute-install-option2-ubuntu.html)
#### Configure o Bridge do Linux 

1. Edite o arquivo `/etc/neutron/plugins/ml2/linuxbridge_agent.ini`
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

2. Certifique-se de que o kernel do seu sistema operacional Linux suporta filtros de ponte de rede, verificando se todos os valores **sysctl** a seguir estão definidos como 1:
~~~
net.bridge.bridge-nf-call-iptables 
net.bridge.bridge-nf-chamada-ip6tables
~~~
>>Retornar à configuração do nó compute de rede.
***

#### Configurar o serviço compute para usar o serviço de rede:
3. Edite `/etc/nova/nova.conf`
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
~~~

4. Finalize a instalação:
~~~
service nova-compute restart
service neutron-linuxbridge-agent restart
~~~

### Verificando operação
1. Execute os comandos:
~~~
openstack extension list --network
~~~

2. Para opção de **Rede 1**, execute:
~~~
openstack network agent list
~~~
>>A saída deve indicar três agentes no nó do controller e um agente em cada nó compute.


3. Para opção de **Rede 2**, execute:
~~~
openstack network agent list
~~~
>>A saída deve indicar quatro agentes no nó do controller e um agente em cada nó compute.
***

### [Dashboard - Instalação do Horizon](https://docs.openstack.org/horizon/queens/install/)
#### [Instalação e configuração](https://docs.openstack.org/horizon/queens/install/install-ubuntu.html)
>>Execute os comandos abaixo no **controller**.

1. Instale o pacote:
~~~
apt install openstack-dashboard
~~~

2. Edite o arquivo `/etc/openstack-dashboard/local_settings.py`
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

- Caso tenha escolhido a opção de Rede 1, desative o suporte para Layer-3 do serviço de Rede:
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
>>Substitua [TIME_ZONE](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones) por um identificador de fuso horário apropriado. 

3. Edite o arquivo `/etc/apache2/conf-available/openstack-dashboard.conf`
~~~
WSGIApplicationGroup %{GLOBAL}
~~~

#### Finalize a instalação
1. Restarte o serviço:
~~~
service apache2 reload
~~~

### [Verificando Operação](https://docs.openstack.org/horizon/queens/install/verify-ubuntu.html)
Acesse o painel usando um navegador Web em http://controller/horizon.  
Acesse usando **admin** ou **demo user** e credenciais **default** de domínio.
***

### [Serviço de Armazenamento em Bloco - Instalação do Cinder](https://docs.openstack.org/cinder/queens/install/)
#### [Instalação e configuração do block](https://docs.openstack.org/cinder/queens/install/cinder-storage-install-ubuntu.html)
>>Execute estas etapas em **block**.  

1. Instale os pacotes de utilitários de suporte:
~~~
apt install lvm2 thin-provisioning-tools
~~~

2. Crie o volume `/dev/sdb`
~~~
pvcreate /dev/sdb
vgcreate cinder-volumes /dev/sdb
~~~

3. Edite o arquivo `/etc/lvm/lvm.conf` 
~~~
devices {
filter = [ "a/sdb/", "r/.*/"]
~~~

### Instalação e configuração de componentes
1. Instale os pacotes:  
~~~
apt install cinder-volume
~~~

2. Edite o arquivo `/etc/cinder/cinder.conf` 
~~~
[database]
connection = mysql+pymysql://cinder:senha@controller/cinder

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
1. Restarte os serviços:
~~~
service tgt restart
service cinder-volume restart
~~~

### [Instalação e configuração do controller](https://docs.openstack.org/cinder/queens/install/cinder-controller-install-ubuntu.html)
>>Execute estas etapas em **controller**.  

1. Para criar o banco de dados, conclua estas etapas:  
~~~
mysql -u root -psenha
CREATE DATABASE cinder;
GRANT ALL PRIVILEGES ON cinder.* TO 'cinder'@'localhost' IDENTIFIED BY 'senha';
GRANT ALL PRIVILEGES ON cinder.* TO 'cinder'@'%' IDENTIFIED BY 'senha';
exit;
~~~

2. Para criar as credenciais de serviço, conclua estas etapas:
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
1. Instale os pacotes:
~~~
apt install cinder-api cinder-scheduler
~~~

2. Edite o arquivo `/etc/cinder/cinder.conf`
~~~
[database]
connection = mysql+pymysql://cinder:senha@controller/cinder

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

3. Preencha o banco de dados do Armazenamento em Bloco:
~~~
su -s /bin/sh -c "cinder-manage db sync" cinder
~~~

4. Edite o arquivo `etc/nova/nova.conf`.
~~~
[cinder]
os_region_name = RegionOne
~~~

#### Finalize a instalação
1. Reinicie os serviços:
~~~
service nova-api restart
service cinder-scheduler restart
service apache2 restart
~~~

### [Instalação e configuração do serviço de backup (Opcional)](https://docs.openstack.org/cinder/queens/install/cinder-backup-install-ubuntu.html)
>>Execute estas etapas em **block**.  

1. Instale o pacote:
~~~
apt install cinder-backup
~~~

2. Edite o arquivo  `/etc/cinder/cinder.conf`.
~~~
[DEFAULT]
backup_driver = cinder.backup.drivers.swift
backup_swift_url = SWIFT_URL
~~~

3. Execute o comando:
~~~
openstack catalog show object-store
~~~

#### Finalize a instalação
1. Restarte o serviço do cinder:
~~~
service cinder-backup restart
~~~

### [Verificando Operação Cinder](https://docs.openstack.org/cinder/queens/install/cinder-verify.html)
1. Verificando a operação do serviço de armazenamento em bloco:  
~~~
openstack volume service list
~~~
***

## [Finalizando Instalação Ironic](https://docs.openstack.org/ironic/queens/install/install-ubuntu.html)
1. Configurando o banco de dados:
~~~
mysql -u root -psenha
CREATE DATABASE ironic CHARACTER SET utf8;
GRANT ALL PRIVILEGES ON ironic.* TO 'ironic'@'localhost' \
       IDENTIFIED BY 'senha';
GRANT ALL PRIVILEGES ON ironic.* TO 'ironic'@'%' \
       IDENTIFIED BY 'senha';
exit;
~~~

2. Instale os pacotes;
~~~
apt-get install ironic-api ironic-conductor python-ironicclient
~~~

3. Edite o arquivo `/etc/ironic/ironic.conf`.
~~~
[database]
connection=mysql+pymysql://ironic:senha@DB_IP/ironic?charset=utf8

[DEFAULT]
transport_url = rabbit://RPC_USER:RPC_PASSWORD@RPC_HOST:RPC_PORT/
auth_strategy=keystone

[keystone_authtoken]
auth_type=password
www_authenticate_uri=http://PUBLIC_IDENTITY_IP:5000
auth_url=http://PRIVATE_IDENTITY_IP:35357
username=ironic
password=IRONIC_PASSWORD
project_name=service
project_domain_name=Default
user_domain_name=Default
~~~
>>Substitua **PUBLIC_IDENTITY_IP** pelo IP público do servidor de identidade,
>>**PRIVATE_IDENTITY_IP** pelo IP privado do servidor de identidade.

4. Crie as tabelas do banco de dados de serviço Bare Metal:
~~~
ironic-dbsync --config-file /etc/ironic/ironic.conf create_schema
~~~

5. Reinicie o serviço ironic-api:
~~~
sudo service ironic-api restart
~~~

### Configurando irônico-api com mod_wsgi
1. Instale o serviço do apache:
~~~
apt-get install apache2
~~~

2. Copie o arquivo `etc/apache2/ironic`
~~~
cp etc/apache2/ironic /etc/apache2/sites-available/ironic.conf
~~~
3. Edite o arquivo copiado ` <apache-configuration-dir>/ironic.conf`  
- Modificar as variáveis **WSGIDaemonProcess**, **APACHE_RUN_USER** e **APACHE_RUN_GROUP** para definir os valores de usuário e grupo para um usuário apropriado em seu servidor.  
- Modifique a variável **WSGIScriptAlias** para apontar para o ironic-api-wsgiscript gerado automaticamente localizado no diretório IRONIC_BIN .  
- Modifique a variável **Directory** para definir o caminho para o código da Ironic API.  
- Modifique os logs **ErrorLog** e **CustomLog** para o diretório correto.  
>>O arquivo ironic-api-wsgi é gerado automaticamente pelo pbr e está disponível no diretório IRONIC_BIN . Não deve ser modificado.  

4. Ative o apache ironic no site e recarregue:
~~~
sudo a2ensite ironic
sudo service apache2 reload
~~~
#### Configurando o serviço de condutor irônico
1. Substitua HOST_IP por IP do host do condutor.
~~~
[DEFAULT]
my_ip=HOST_IP
~~~

2. Configure a localização do banco de dados.
~~~
[database]
connection=mysql+pymysql://ironic:senha@DB_IP/ironic?charset=utf8
~~~

3. Configure o serviço de condutor irônico para usar o intermediário de mensagem RabbitMQ configurando a opção a seguir.
~~~
[DEFAULT]
transport_url = rabbit://RPC_USER:RPC_PASSWORD@RPC_HOST:RPC_PORT/
~~~

4. Configure credenciais para acessar outros serviços do OpenStack.
- [neutron] - para acessar o serviço OpenStack Networking  
- [glance] - para acessar o serviço OpenStack Image  
- [swift] - para acessar o serviço OpenStack Object Storage  
- [inspector] - para acessar o serviço OpenStack Bare Metal Introspection  
- [service_catalog] - uma seção especial que contém credenciais que o serviço Bare Metal usará para descobrir seu próprio ponto de extremidade de URL da API, conforme registrado no catálogo do serviço OpenStack Identity.  

>> Não foi colocado o código, pois é conforme a necessidade do usuário, para mais detalhes visita a [página](https://docs.openstack.org/ironic/queens/install/install-ubuntu.html) .

5. Reinicie o serviço de condutores irônicos:
~~~
sudo service ironic-conductor restart
~~~