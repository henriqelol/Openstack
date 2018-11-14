controller ALL=(ALL:ALL) NOPASSWD: ALL
=========================================
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
auto enp0s3
iface enp0s3 inet manual
	up ifconfig $IFACE 10.0.0.11 up
        up ip link set $IFACE promisc on
        down ip link set $IFACE promisc off
        down ifconfig $IFACE down

auto enp0s8
iface enp0s8 inet dhcp
==============================================
Permissão ao usuario
sudo usermod -aG sudo controller
===================================================


Instalação Ironic
[https://docs.openstack.org/ironic/queens/]


Guia de instalação
	*Service Bare Metal

Install and configure for Ubuntu
mysql -u root -p

mysql> CREATE DATABASE ironic CHARACTER SET utf8;
mysql> GRANT ALL PRIVILEGES ON ironic.* TO 'ironic'@'localhost' IDENTIFIED BY '123456';
mysql> GRANT ALL PRIVILEGES ON ironic.* TO 'ironic'@'%' IDENTIFIED BY '123456';
mysql> exi
t
sudo apt-get install ironic-api ironic-conductor python-ironicclient
sudo service ironic-api restart
sudo service ironic-api status
sudo service ironic-conductor restart
sudo service ironic-conductor status
sudo service python-ironicclient restart
sudo service python-ironicclient status

sudo vim /etc/ironic/ironic.conf

[database]
connection=mysql+pymysql://ironic:123456@192.168.88.80/ironic?charset=utf8

[DEFAULT]
transport_url = rabbit://ironic:123456@ironic:8000/

[DEFAULT]
auth_strategy=keystone

[keystone_authtoken]
auth_type=password
www_authenticate_uri=http://192.168.88.80:5000
auth_url=http://192.168.88.80:35357
username=ironic
password=123456
project_name=service
project_domain_name=Default
user_domain_name=Default
:wq!

sudo pip install psycopg2-binary
ironic-dbsync --config-file /etc/ironic/ironic.conf create_schema

sudo service ironic-api restart
sudo service ironic-api status

sudo apt-get install apache2
sudo service apache2 restart
sudo service apache2 status

sudo cp ironic/etc/apache2/ironic /etc/apache2/sites-available/ironic.conf
sudo vim /etc/apache2/sites-available/ironic.conf

#Edite
	user=ironic group=ironic
	WSGIScriptAlias / /home/ironic/ironic/.tox/py27/bin/ironic-api-wsgi
	<Directory /home/ironic/ironic/ironic/api>
:wq!
#

sudo a2ensite ironic
sudo service apache2 reload

sudo vim /etc/ironic/ironic.conf
[DEFAULT]
my_ip=192.168.88.80

[neutron]
auth_type = password
auth_url=https://IDENTITY_IP:5000/
username=ironic
password=IRONIC_PASSWORD
project_name=service
project_domain_id=default
user_domain_id=default
cafile=/opt/stack/data/ca-bundle.pem
region_name = RegionTwo
valid_interfaces=public

#Não Fiz [Acessando outro terminal para um serviço especifico]
[neutron] 
endpoint_override  =  <NEUTRON_API_ADDRESS>

#Configurando Drivers e Hardware [https://docs.openstack.org/ironic/queens/install/enabling-drivers.html]
#COnfiguração com protocolo IPMI e Redsifh

sudo vim /etc/ironic/ironic.conf
[DEFAULT] 
enabled_hardware_types = ipmi,redfish
enabled_boot_interfaces = pxe
enabled_console_interfaces = ipmitool-socat,no-console
enabled_deploy_interfaces = iscsi,direct
enabled_inspect_interfaces = inspector
enabled_management_interfaces = ipmitool,redfish
enabled_network_interfaces = flat,neutron
enabled_power_interfaces = ipmitool,redfish
enabled_raid_interfaces = agent
enabled_storage_interfaces = cinder,noop
enabled_vendor_interfaces = ipmitool,no-vendor

#Examples
#enabled_hardware_types = ipmi,redfish
#enabled_hardware_types = ipmi,ilo
#enabled_boot_interfaces = pxe,ilo-virtual-media
#enabled_hardware_types = ipmi,redfish
#enabled_deploy_interfaces = iscsi,direct
#enabled_hardware_types = ipmi,ilo,irmc
#enabled_inspect_interfaces = ilo,irmc,inspector
#enabled_hardware_types = ipmi,redfish,ilo,irmc
#enabled_management_interfaces = ipmitool,redfish,ilo,irmc
#enabled_hardware_types = ipmi,redfish,ilo,irmc
#enabled_power_interfaces = ipmitool,redfish,ilo,irmc
#enabled_hardware_types = ipmi,irmc
#enabled_storage_interfaces = cinder,noop
#enabled_hardware_types = ipmi,redfish,ilo,irmc
#enabled_vendor_interfaces = ipmitool,no-vendor

#Configurando PXE e IPXE
	#PXE Setup

	sudo mkdir -p /tftpboot
	sudo chown -R ironic /tftpboot
	sudo apt-get install xinetd tftpd-hpa syslinux-common pxelinux

sudo vim /etc/xinetd.d/tftp

service tftp
{
  protocol        = udp
  port            = 69
  socket_type     = dgram
  wait            = yes
  user            = root
  server          = /usr/sbin/in.tftpd
  server_args     = -v -v -v -v -v --map-file /tftpboot/map-file /tftpboot
  disable         = no
  # This is a workaround for Fedora, where TFTP will listen only on
  # IPv6 endpoint, if IPv4 flag is not used.
  flags           = IPv4
}

:wq!

sudo service xinetd restart
sudo cp /usr/lib/PXELINUX/pxelinux.0 /tftpboot
sudo cp /usr/lib/syslinux/modules/bios/chain.c32 /tftpboot
sudo cp /usr/lib/syslinux/modules/*/ldlinux.* /tftpboot
echo 're ^(/tftpboot/) /tftpboot/\2' > /tftpboot/map-file
echo 're ^/tftpboot/ /tftpboot/' >> /tftpboot/map-file
echo 're ^(^/) /tftpboot/\1' >> /tftpboot/map-file
echo 're ^([^/]) /tftpboot/\1' >> /tftpboot/map-file

sudo apt-get install grub-efi-amd64-signed shim-signed
sudo cp /usr/lib/shim/shimx64.efi.signed /tftpboot/bootx64.efi
sudo cp /usr/lib/grub/x86_64-efi-signed/grubnetx64.efi.signed /tftpboot/grubx64.efi

GRUB_DIR=/tftpboot/grub
sudo mkdir -p $GRUB_DIR

sudo vim /tftpboot/grub/grub.cfg
set default=master
set timeout=5
set hidden_timeout_quiet=false

menuentry "master"  {
configfile /tftpboot/$net_default_ip.conf
}
:wq!

sudo chmod 644 $GRUB_DIR/grub.cfg


---------------
/install-guide/environment.html
	-> Guia de Instalação do Armazenamento de Objetos para o Queens

Nome da Senha   Descrição

ADMIN_PASS		Senha do usuário admin
CINDER_DBPASS	Senha do banco de dados para o serviço Block Storage
CINDER_PASS		Senha do usuário do serviço de armazenamento em block cinder
DASH_DBPASS		Senha do banco de dados para o painel
DEMO_PASS		Senha do usuário demo
GLANCE_DBPASS	Senha do banco de dados para o serviço de imagem
GLANCE_PASS		Senha do usuário do serviço de imagem glance
KEYSTONE_DBPASS	Senha do banco de dados do serviço de identidade
METADATA_SECRET	Segredo para o proxy de metadados
NEUTRON_DBPASS	Senha do banco de dados para o serviço de rede
NEUTRON_PASS	Senha do usuário do serviço de rede neutron
NOVA_DBPASS		Senha do banco de dados para o serviço de computação
NOVA_PASS		Senha do usuário do serviço Compute nova
PLACEMENT_PASS	Senha do usuário do serviço de veiculação placement
RABBIT_PASS		Senha do usuário do RabbitMQ openstack


Usuarios
#rabbitmq-server
Nome do usuario: openstack

export OS_IDENTITY_API_VERSION=3
openstack --os-identity-api-version 3 

https://docs.openstack.org/keystone/queens/install/keystone-users-ubuntu.html

[keystone - Security Guide] (Dar uma olhada)
https://docs.openstack.org/security-guide/introduction/security-boundaries-and-threats.html


openstack project create --domain default --description "Service Project" service
keystone user-create --name=teste --pass=123456 

export OS_USERNAME=admin
export OS_PASSWORD=123456
export OS_PROJECT_NAME=admin
export OS_USER_DOMAIN_NAME=Default
export OS_PROJECT_DOMAIN_NAME=Default
export OS_AUTH_URL=http://controller:5000/v3
export OS_IDENTITY_API_VERSION=3


openstack project create --domain default --description "Service Project" service
openstack project create --domain default --description "Demo Project" demo
openstack user create --domain default --password-prompt demo

=====Instalação do NOVA
https://docs.openstack.org/nova/queens/install/

CREATE DATABASE nova_api;
CREATE DATABASE nova;
CREATE DATABASE nova_cell0;

GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'localhost' IDENTIFIED BY 'NOVA_DBPASS';
GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'%' IDENTIFIED BY 'NOVA_DBPASS';

GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'localhost' IDENTIFIED BY 'NOVA_DBPASS';
GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'%' IDENTIFIED BY 'NOVA_DBPASS';

GRANT ALL PRIVILEGES ON nova_cell0.* TO 'nova'@'localhost' IDENTIFIED BY 'NOVA_DBPASS';
GRANT ALL PRIVILEGES ON nova_cell0.* TO 'nova'@'%' IDENTIFIED BY 'NOVA_DBPASS';

openstack user create --domain default --password-prompt nova
openstack role add --project service --user nova admin

openstack service create --name nova  --description "OpenStack Compute" compute

d6ff8fc6a0cf4d1fb244b6f2abfe133c = compute

openstack endpoint create --region RegionOne d6ff8fc6a0cf4d1fb244b6f2abfe133c public http://controller:8774/v2.1
openstack endpoint create --region RegionOne d6ff8fc6a0cf4d1fb244b6f2abfe133c internal http://controller:8774/v2.1
openstack endpoint create --region RegionOne d6ff8fc6a0cf4d1fb244b6f2abfe133c admin http://controller:8774/v2.1

openstack user create --domain default --password-prompt placement

openstack role add --project service --user placement admin
openstack service create --name placement --description "Placement API" placement
openstack endpoint create --region RegionOne placement public http://controller:8778
openstack endpoint create --region RegionOne placement internal http://controller:8778
openstack endpoint create --region RegionOne placement admin http://controller:8778

apt install nova-api nova-conductor nova-consoleauth nova-novncproxy nova-scheduler nova-placement-api

[Edite /etc/nova/nova.conf]
[api_database]
connection = mysql+pymysql://nova:NOVA_DBPASS@controller/nova_api

[database]
connection = mysql+pymysql://nova:NOVA_DBPASS@controller/nova

[DEFAULT]
transport_url = rabbit://openstack:RABBIT_PASS@controller
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
password = NOVA_PASS

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
password = PLACEMENT_PASS

[Note]
>> Comment out or remove any other options in the [keystone_authtoken] section.
>> Due to a packaging bug, remove the log_dir option from the [DEFAULT] section.

sudo -s /bin/sh -c "nova-manage api_db sync" nova
sudo -s /bin/sh -c "nova-manage cell_v2 map_cell0" nova
sudo su -s /bin/sh -c "nova-manage cell_v2 create_cell --name=cell1 --verbose" nova 109e1d4b-536a-40d0-83c6-5f121b82b650
sudo su -s /bin/sh -c "nova-manage db sync" nova

sudo nova-manage cell_v2 list_cells

[Edite]
enable_new_services = true

sudo service nova-api restart
sudo service nova-api status
sudo service nova-consoleauth restart
sudo service nova-consoleauth status
sudo service nova-scheduler restart
sudo service nova-scheduler status
sudo service nova-conductor restart
sudo service nova-conductor status
sudo service nova-novncproxy restart
sudo service nova-novncproxy status


https://docs.openstack.org/nova/queens/install/compute-install-ubuntu.html
[In compute1]

sudo vim /etc/nova/nova.conf
[DEFAULT]
my_ip = 10.0.0.31
use_neutron = True
firewall_driver = nova.virt.firewall.NoopFirewallDriver
transport_url = rabbit://openstack:RABBIT_PASS@controller

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
password = NOVA_PASS
[Note]
>>Comment out or remove any other options in the [keystone_authtoken] section.

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
project_name = Service
auth_type = password
user_domain_name = Default
auth_url = http://controller:5000/v3
username = placement
password = PLACEMENT_PASS

[REMOVE log_dir in [DEFAULT]]

egrep -c '(vmx|svm)' /proc/cpuinfo [Case return 0]
sudo vim /etc/nova/nova-compute.conf

[libvirt]
virt_type = qemu

sudo service nova-compute restart
sudo service nova-compute status

https://docs.openstack.org/nova/queens/install/compute-install-ubuntu.html

====https://docs.openstack.org/nova/queens/install/compute-install-ubuntu.html
erro: openstack image list
install 
https://docs.openstack.org/ironic/queens/install/configure-glance-images.html


===Instalando o Glance e subindo Image
https://docs.openstack.org/glance/queens/install/install-ubuntu.html

mysql -u root -p

CREATE DATABASE glance;
SHOW DATABASES;
GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'localhost' IDENTIFIED BY 'GLANCE_PASSGLANCE_PASS';
GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'%' IDENTIFIED BY 'GLANCE_PASS';

SHOW GRANTS FOR 'glance'@'localhost';
SHOW GRANTS FOR 'glance'@'%';

. admin-openrc
openstack user create --domain default --password-prompt glance
openstack role add --project service --user glance admin
openstack service create --name glance --description "OpenStack Image" image
openstack endpoint create --region RegionOne image public http://controller:9292
openstack endpoint create --region RegionOne image internal http://controller:9292
openstack endpoint create --region RegionOne image admin http://controller:9292

##Install and configure components
sudo apt install glance

#Edite
sudo vim /etc/glance/glance-api.conf

[database]
# ...
connection = mysql+pymysql://glance:GLANCE_DBPASS@controller/glance

[keystone_authtoken]
# ...
auth_uri = http://controller:5000
auth_url = http://controller:5000
memcached_servers = controller:11211
auth_type = password
project_domain_name = Default
user_domain_name = Default
project_name = service
username = glance
password = GLANCE_PASS

[paste_deploy]
# ...
flavor = keystone

[glance_store]
# ...
stores = file,http
default_store = file
filesystem_store_datadir = /var/lib/glance/images/

#Edite
sudo vim /etc/glance/glance-registry.conf

[database]
# ...
connection = mysql+pymysql://glance:GLANCE_DBPASS@controller/glance

[keystone_authtoken]
# ...
auth_uri = http://controller:5000
auth_url = http://controller:5000
memcached_servers = controller:11211
auth_type = password
project_domain_name = Default
user_domain_name = Default
project_name = service
username = glance
password = GLANCE_PASS

[paste_deploy]
# ...
flavor = keystone

sudo su -s /bin/sh -c "glance-manage db_sync" glance

sudo service glance-registry restart
sudo service glance-api restart


#Criando Imagem 
https://docs.openstack.org/image-guide/

#Verify operation
wget http://download.cirros-cloud.net/0.4.0/cirros-0.4.0-x86_64-disk.img
openstack image create "cirros" --file cirros-0.4.0-x86_64-disk.img --disk-format qcow2 --container-format bare --public