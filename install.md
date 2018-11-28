~~~
echo Y|apt install software-properties-common
add-apt-repository cloud-archive:queens
apt update && apt -y dist-upgrade
reboot
echo Y|apt install python-openstackclient
echo Y|apt-get install mysql-server
mysql -u root -psenhaDaVMdoMato
CREATE DATABASE keystone;
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' \
IDENTIFIED BY 'senhaDaVMdoMato';
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' \
IDENTIFIED BY 'senhaDaVMdoMato';
exit;
apt -y install keystone  apache2 libapache2-mod-wsgi
sed -i 's/connection\ \=\ sqlite\:\/\/\/\/var\/lib\/keystone\/keystone\.db/connection\ \=\ mysql\+pymysql\:\/\/keystone\:senhaDaVMdoMato\@localhost\/keystone/g' /etc/keystone/keystone.conf
sed -i '/^\[token\]/a provider = fernet' /etc/keystone/keystone.conf
keystone-manage db_sync
keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone
keystone-manage credential_setup --keystone-user keystone --keystone-group keystone
keystone-manage bootstrap --bootstrap-password senhaDaVMdoMato \
  --bootstrap-admin-url http://localhost:5000/v3/ \
  --bootstrap-internal-url http://localhost:5000/v3/ \
  --bootstrap-public-url http://localhost:5000/v3/ \
  --bootstrap-region-id RegionOne
echo "ServerName localhost" >> /etc/apache2/apache2.conf
service apache2 restart
echo "export OS_USERNAME=admin" >> /etc/profile
echo "export OS_PASSWORD=senhaDaVMdoMato" >> /etc/profile
echo "export OS_PROJECT_NAME=admin" >> /etc/profile
echo "export OS_USER_DOMAIN_NAME=Default" >> /etc/profile
echo "export OS_PROJECT_DOMAIN_NAME=Default" >> /etc/profile
echo "export OS_AUTH_URL=http://localhost:5000/v3" >> /etc/profile
echo "export OS_IDENTITY_API_VERSION=3" >> /etc/profile
reboot
printenv | grep OS
#ssh -l root -p 2222 localhost
openstack domain create --description "An Example Domain" example
openstack project create --domain default --description "Service Project" service
openstack project create --domain default --description "Demo Project" demo
openstack user create --domain default --password senhaDaVMdoMato demo
openstack role create user
openstack role add --project demo --user demo user

mysql -u root -psenhaDaVMdoMato
CREATE DATABASE glance;
GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'localhost' IDENTIFIED BY 'senhaDaVMdoMato';
GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'%' IDENTIFIED BY 'senhaDaVMdoMato';
exit;
openstack user create --domain default --password senhaDaVMdoMato glance
openstack service create --name glance --description "OpenStack Image" image
openstack endpoint create --region RegionOne image public http://localhost:9292
openstack endpoint create --region RegionOne image internal http://localhost:9292
openstack endpoint create --region RegionOne image admin http://localhost:9292
apt -y install glance
sed -i 's/connection\ \=\ sqlite\:\/\/\/\/var\/lib\/glance\/glance\.sqlite/connection\ \=\ mysql\+pymysql\:\/\/glance\:senhaDaVMdoMato\@localhost\/glance/g' /etc/glance/glance-api.conf
sed -i '/^\[keystone_authtoken\]/a auth_uri = http://localhost:5000 \nauth_url = http://localhost:5000 \nmemcached_servers = localhost:11211 \nauth_type = password \nproject_domain_name = Default \nuser_domain_name = Default \nproject_name = service \nusername = glance \npassword = senhaDaVMdoMato' /etc/glance/glance-api.conf
sed -i '/^\[glance_store\]/a stores = file,http \ndefault_store = file \nfilesystem_store_datadir = /var/lib/glance/images/' /etc/glance/glance-registry.conf
sed -i 's/connection\ \=\ sqlite\:\/\/\/\/var\/lib\/glance\/glance\.sqlite/connection\ \=\ mysql\+pymysql\:\/\/glance\:senhaDaVMdoMato\@localhost\/glance/g' /etc/glance/glance-registry.conf
sed -i '/^\[keystone_authtoken\]/a auth_uri = http://localhost:5000 \nauth_url = http://localhost:5000 \nmemcached_servers = localhost:11211 \nauth_type = password \nproject_domain_name = Default \nuser_domain_name = Default \nproject_name = service \nusername = glance \npassword = senhaDaVMdoMato' /etc/glance/glance-registry.conf
sed -i '/^\[paste_deploy\]/a flavor = keystone' /etc/glance/glance-registry.conf
/bin/sh -c "glance-manage db_sync" glance
service glance-registry restart
service glance-api restart

wget http://download.cirros-cloud.net/0.4.0/cirros-0.4.0-x86_64-disk.img
openstack image create "cirros" --file cirros-0.4.0-x86_64-disk.img --disk-format qcow2 --container-format bare --public

mysql -u root -psenhaDaVMdoMato
CREATE DATABASE nova_api;
CREATE DATABASE nova;
CREATE DATABASE nova_cell0;
GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'localhost' IDENTIFIED BY 'senhaDaVMdoMato';
GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'%' IDENTIFIED BY 'senhaDaVMdoMato';
GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'localhost' IDENTIFIED BY 'senhaDaVMdoMato';
GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'%' IDENTIFIED BY 'senhaDaVMdoMato';
GRANT ALL PRIVILEGES ON nova_cell0.* TO 'nova'@'localhost' IDENTIFIED BY 'senhaDaVMdoMato';
GRANT ALL PRIVILEGES ON nova_cell0.* TO 'nova'@'%' IDENTIFIED BY 'senhaDaVMdoMato';
exit;
openstack user create --domain default --password senhaDaVMdoMato nova
openstack role add --project service --user nova admin
openstack service create --name nova --description "OpenStack Compute" compute
openstack endpoint create --region RegionOne compute public http://localhost:8774/v2.1
openstack endpoint create --region RegionOne compute internal http://localhost:8774/v2.1
openstack endpoint create --region RegionOne compute admin http://localhost:8774/v2.1
openstack user create --domain default --password senhaDaVMdoMato placement
openstack role add --project service --user placement admin
openstack service create --name placement --description "Placement API" placement
openstack endpoint create --region RegionOne placement public http://localhost:8778
openstack endpoint create --region RegionOne placement internal http://localhost:8778
openstack endpoint create --region RegionOne placement admin http://localhost:8778
apt -y install nova-api nova-conductor nova-consoleauth nova-novncproxy nova-scheduler nova-placement-api

sed -i 's/connection\ \=\ sqlite\:\/\/\/\/var\/lib\/nova\/nova_api\.sqlite/connection\ \=\ mysql\+pymysql\:\/\/nova\:senhaDaVMdoMato\@localhost\/nova_api/g' /etc/nova/nova.conf 
sed -i 's/connection\ \=\ sqlite\:\/\/\/\/var\/lib\/nova\/nova\.sqlite/connection\ \=\ mysql\+pymysql\:\/\/nova\:senhaDaVMdoMato\@localhost\/nova/g' /etc/nova/nova.conf 
sed -i '/^\[DEFAULT\]/a transport_url = rabbit://openstack:senhaDaVMdoMato@localhost \nmy_ip = 127.0.0.1 \nuse_neutron = true \nfirewall_driver = nova.virt.firewall.NoopFirewallDriver' /etc/nova/nova.conf
sed -i '/^\[api\]/a auth_strategy = keystone' /etc/nova/nova.conf
sed -i '/^\[keystone_authtoken\]/a auth_url = http://localhost:5000/v3 \nmemcached_servers = localhost:11211 \nauth_type = password \nproject_domain_name = default \nuser_domain_name = default \nproject_name = service \nusername = nova \npassword = senhaDaVMdoMato' /etc/nova/nova.conf
sed -i '/^\[vnc\]/a enabled = true \nserver_listen = $my_ip \nserver_proxyclient_address = $my_ip' /etc/nova/nova.conf
sed -i '/^\[glance\]/a api_servers = http://localhost:9292' /etc/nova/nova.conf
sed -i '/^\[oslo_concurrency\]/a lock_path = /var/lib/nova/tmp' /etc/nova/nova.conf
sed -i 's/os_region_name = openstack/#os_region_name = openstack/g' /etc/nova/nova.conf
sed -i '/^\[placement\]/a os_region_name = RegionOne \nproject_domain_name = Default \nproject_name = service \nauth_type = password \nuser_domain_name = Default \nauth_url = http://localhost:5000/v3 \nusername = placement \npassword = senhaDaVMdoMato' /etc/nova/nova.conf
/bin/sh -c "nova-manage api_db sync" nova
/bin/sh -c "nova-manage cell_v2 map_cell0" nova
apt -y install rabbitmq-server

systemctl enable rabbitmq-server.service
systemctl start rabbitmq-server.service
rabbitmqctl add_user openstack senhaDaVMdoMato
rabbitmqctl set_permissions openstack "." "." ".*"
rabbitmqctl start_app
/bin/sh -c "nova-manage cell_v2 create_cell --name=cell1 --verbose" nova
/bin/sh -c "nova-manage db sync" nova
service nova-api restart
service nova-consoleauth restart
service nova-scheduler restart
service nova-conductor restart
service nova-novncproxy restart


apt -y install nova-compute
sed -i '/^\[vnc\]/a novncproxy\_base\_url\ \=\ http\:\/\/localhost\:6080\/vnc\_auto\.html' /etc/nova/nova.conf

sed -i 's/log_dir/#log_dir/' /etc/nova/nova.conf
egrep -c '(vmx|svm)' /proc/cpuinfo

if [ $(egrep -c '(vmx|svm)' /proc/cpuinfo) -eq 0 ]; then sed -i 's/virt_type\=kvm/virt_type\=qemu/g' /etc/nova/nova-compute.conf; fi
service nova-compute restart

Precisa criar a VM primeiro? não deu com: nova boot --flavor m1.tiny --image cirros --min-count 1 node1

openstack compute service list --service nova-compute --debug

==
https://docs.openstack.org/neutron/queens/install/install-ubuntu.html

#Edite o /etc/hosts nas máquinas **controller**, **compute1** e **block1**

# controller
10.0.0.11       controller
# compute1
10.0.0.31       compute1
# block1
10.0.0.41       block1

mysql -u root -psenhaDaVMdoMato
CREATE DATABASE neutron;
GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'localhost' IDENTIFIED BY 'senhaDaVMdoMato';
GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'%' IDENTIFIED BY 'senhaDaVMdoMato';
exit;

. admin-openrc

#openstack user create --domain default --password-prompt neutron
openstack role add --project service --user neutron admin
openstack service create --name neutron --description "OpenStack Networking" network
openstack endpoint create --region RegionOne network public http://controller:9696
openstack endpoint create --region RegionOne network internal http://controller:9696
openstack endpoint create --region RegionOne network admin http://controller:9696
apt install neutron-server neutron-plugin-ml2 neutron-linuxbridge-agent neutron-dhcp-agent neutron-metadata-agent

/etc/neutron/neutron.conf
[database]
# ...
connection = mysql+pymysql://neutron:NEUTRON_DBPASS@controller/neutron
#Comentar alem de connection

[DEFAULT]
# ...
transport_url = rabbit://openstack:RABBIT_PASS@controller

[DEFAULT]
# ...
auth_strategy = keystonekrak

[keystone_authtoken]
# ...
auth_uri = http://controller:5000
auth_url = http://controller:5000
memcached_servers = controller:11211
auth_type = password
project_domain_name = default
user_domain_name = default
project_name = service
username = neutron
password = NEUTRON_PASS

[DEFAULT]
# ...
notify_nova_on_port_status_changes = true
notify_nova_on_port_data_changes = true

[nova]
# ...
auth_url = http://controller:5000
auth_type = password
project_domain_name = default
user_domain_name = default
region_name = RegionOne
project_name = service
username = nova
password = NOVA_PASS

/etc/neutron/plugins/ml2/linuxbridge_agent.ini
[linux_bridge]
physical_interface_mappings = provider:PROVIDER_INTERFACE_NAME
PROVIDER_INTERFACE_NAME é o nome da interface

[vxlan] 
enable_vxlan  =  false

[securitygroup] 
# ... 
enable_security_group  =  true 
firewall_driver  =  neutrron.agent.linux.iptables_firewall.IptablesFirewallDriver

net.bridge.bridge-nf-call-iptables
net.bridge.bridge-nf-call-ip6tables

/etc/neutron/dhcp_agent.ini
[DEFAULT]
# ...
interface_driver = linuxbridge
dhcp_driver = neutron.agent.linux.dhcp.Dnsmasq
enable_isolated_metadata = truehttps://docs.openstack.org/neutron/queens/install/install-ubuntu.html
https://docs.openstack.org/neutron/queens/install/install-ubuntu.html
controller: 96
computer: 98
block: 75

===================================================
------------Config Network Interfaces--------------
===================================================

sudo vim /etc/network/interfaces
auto enp0s3
iface enp0s3 inet manual
        up ifconfig $IFACE 10.0.0.11 up
        up ip link set $IFACE promisc on
        down ip link set $IFACE promisc off
        down ifconfig $IFACE down

auto enp0s8
iface enp0s8 inet dhcp

sudo vim /etc/hosts
# localhost
10.0.0.11       localhost
# compute1
10.0.0.31       compute1
# block1
10.0.0.41       block1


===================================================
--------------Configuração Controller--------------
===================================================
mysql -u root -psenhaDaVMdoMato
CREATE DATABASE neutron;
GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'localhost' IDENTIFIED BY 'senhaDaVMdoMato';
GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'%' IDENTIFIED BY 'senhaDaVMdoMato';

. admin-openrc

openstack user create --domain default --password senhaDaVMdoMato neutron
openstack role add --project service --user neutron admin
openstack service create --name neutron --description "OpenStack Networking" network
openstack endpoint create --region RegionOne network public http://localhost:9696
openstack endpoint create --region RegionOne network internal http://localhost:9696
openstack endpoint create --region RegionOne network admin http://localhost:9696


###################################################
===================================================
-----------Configuração Rede Controller------------
===================================================

apt install neutron-server neutron-plugin-ml2 neutron-linuxbridge-agent neutron-dhcp-agent neutron-metadata-agent

/etc/neutron/neutron.conf
[database]
connection = mysql+pymysql://neutron:senhaDaVMdoMato@localhost/neutron
#Comentar alem de connection

[DEFAULT]
core_plugin = ml2
service_plugins =
transport_url = rabbit://openstack:senhaDaVMdoMato@localhost
auth_strategy = keystone
notify_nova_on_port_status_changes = true
notify_nova_on_port_data_changes = true

[keystone_authtoken]
auth_uri = http://localhost:5000
auth_url = http://localhost:5000
memcached_servers = localhost:11211
auth_type = password
project_domain_name = default
user_domain_name = default
project_name = service
username = neutron
password = senhaDaVMdoMato

[nova]
auth_url = http://localhost:5000
auth_type = password
project_domain_name = default
user_domain_name = default
region_name = RegionOne
project_name = service
username = nova
password = senhaDaVMdoMato

/etc/neutron/plugins/ml2/ml2_conf.ini
[ml2]
type_drivers = flat,vlan
tenant_network_types =
mechanism_drivers = linuxbridge
extension_drivers = port_security

[ml2_type_flat]
flat_networks = provider

[securitygroup]
enable_ipset = true


/etc/neutron/plugins/ml2/linuxbridge_agent.ini
[linux_bridge]
physical_interface_mappings = provider:enp0s8

[vxlan] 
enable_vxlan  =  false

[securitygroup] 
enable_security_group  =  true 
firewall_driver  =  neutrron.agent.linux.iptables_firewall.IptablesFirewallDriver

net.bridge.bridge-nf-call-iptables
net.bridge.bridge-nf-call-ip6tables

/etc/neutron/dhcp_agent.ini
[DEFAULT]
interface_driver = linuxbridge
dhcp_driver = neutron.agent.linux.dhcp.Dnsmasq
enable_isolated_metadata = true


###################################################
===================================================
-----------Configuração Rede Computer--------------
===================================================
##Preciso passar isto para a linha de comando

apt install neutron-linuxbridge-agent
/etc/neutron/neutron.conf
[DEFAULT]
transport_url = rabbit://openstack:senhaDaVMdoMato@localhost
auth_strategy = keystone

[keystone_authtoken]securitygroup]
auth_uri = http://localhost:5000
auth_url = http://localhost:5000
memcached_servers = localhost:11211
auth_type = password
project_domain_name = default
user_domain_name = default
project_name = service
username = neutron
password = senhaDaVMdoMato

 /etc/neutron/plugins/ml2/linuxbridge_agent.ini
[linux_bridge]
physical_interface_mappings = provider:enp0s8

[vxlan]
enable_vxlan = false

[securitygroup]
enable_security_group = true
firewall_driver = neutron.agent.linux.iptables_firewall.IptablesFirewallDriver

net.bridge.bridge-nf-call-iptables 
net.bridge.bridge-nf-call-ip6tables

#Falta instalação do Nova
/etc/nova/nova.conf
[neutron]
url = http://localhost:9696
auth_url = http://localhost:5000
auth_type = password
project_domain_name = default
user_domain_name = default
region_name = RegionOne
project_name = service
username = neutron
password = senhaDaVMdoMato

service nova-compute restart
service neutron-linuxbridge-agent restart

###################################################
===================================================
-------------Configuração Controller---------------
===================================================
service nova-compute restart
service neutron-linuxbridge-agent restart

/etc/neutron/metadata_agent.ini
[DEFAULT]
nova_metadata_host = controller
metadata_proxy_shared_secret = senhaDaVMdoMato

/etc/nova/nova.conf
[neutron]
url = http://localhost:9696
auth_url = http://localhost:5000
auth_type = password
project_domain_name = default
user_domain_name = default
region_name = RegionOne
project_name = service
username = neutron
password = senhaDaVMdoMato
service_metadata_proxy = true
metadata_proxy_shared_secret = senhaDaVMdoMato

su -s /bin/sh -c "neutron-db-manage --config-file /etc/neutron/neutron.conf  --config-file /etc/neutron/plugins/ml2/ml2_conf.ini upgrade head" neutron

service nova-api restart
service neutron-server restart
service neutron-linuxbridge-agent restart
service neutron-dhcp-agent restart
service neutron-metadata-agent restart

===================================================
--------------Configuração Controller--------------
===================================================

mysql -u root -psenhaDaVMdoMato
CREATE DATABASE neutron;
GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'localhost' IDENTIFIED BY 'senhaDaVMdoMato';
GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'%' IDENTIFIED BY 'senhaDaVMdoMato';
exit;
. admin-openrc
openstack user create --domain default --password senhaDaVMdoMato neutron
openstack role add --project service --user neutron admin
openstack service create --name neutron --description "OpenStack Networking" network
openstack endpoint create --region RegionOne network public http://localhost:9696
openstack endpoint create --region RegionOne network internal http://localhost:9696
openstack endpoint create --region RegionOne network admin http://localhost:9696
apt -y install neutron-server neutron-plugin-ml2 neutron-linuxbridge-agent neutron-dhcp-agent neutron-metadata-agent;
sed -i 's/sqlite:\/\/\/\/var\/lib\/neutron\/neutron.sqlite/mysql+pymysql://neutron:senhaDaVMdoMato@localhost/neutron/' /etc/neutron/neutron.conf

linhadefaultneutron=`sudo awk '{if ($0 == "[DEFAULT]") {print NR;}}' /etc/neutron/neutron.conf`
sudo sed -i "$[linhadefaultneutron+1] i\core_plugin = ml2" /etc/neutron/neutron.conf
sudo sed -i "$[linhadefaultneutron+2] i\service_plugins = " /etc/neutron/neutron.conf
sudo sed -i "$[linhadefaultneutron+4] i\transport_url = rabbit://openstack:senhaDaVMdoMato@localhost" /etc/neutron/neutron.conf
sudo sed -i "$[linhadefaultneutron+5] i\auth_strategy = keystone" /etc/neutron/neutron.conf
sudo sed -i "$[linhadefaultneutron+6] i\notify_nova_on_port_status_changes = true" /etc/neutron/neutron.conf
sudo sed -i "$[linhadefaultneutron+7] i\notify_nova_on_port_data_changes = true" /etc/neutron/neutron.conf

linhaauthtokenneutron=`sudo awk '{if ($0 == "[keystone_authtoken]") {print NR;}}' /etc/neutron/neutron.conf`
sudo sed -i "$[linhaauthtokenneutron+1] i\auth_uri = http://localhost:5000" /etc/neutron/neutron.conf
sudo sed -i "$[linhaauthtokenneutron+2] i\auth_url = http://localhost:5000" /etc/neutron/neutron.conf
sudo sed -i "$[linhaauthtokenneutron+3] i\memcached_servers = localhost:11211" /etc/neutron/neutron.conf
sudo sed -i "$[linhaauthtokenneutron+4] i\auth_type = password" /etc/neutron/neutron.conf
sudo sed -i "$[linhaauthtokenneutron+5] i\project_domain_name = default" /etc/neutron/neutron.conf
sudo sed -i "$[linhaauthtokenneutron+6] i\user_domain_name = default" /etc/neutron/neutron.conf
sudo sed -i "$[linhaauthtokenneutron+7] i\project_name = service" /etc/neutron/neutron.conf
sudo sed -i "$[linhaauthtokenneutron+8] i\username = neutron" /etc/neutron/neutron.conf
sudo sed -i "$[linhaauthtokenneutron+9] i\password = senhaDaVMdoMato" /etc/neutron/neutron.conf

linhanovaneutron=`sudo awk '{if ($0 == "[nova]") {print NR;}}' /etc/neutron/neutron.conf`
sudo sed -i "$[linhanovaneutron+1] i\auth_url = http://localhost:5000" /etc/neutron/neutron.conf
sudo sed -i "$[linhanovaneutron+2] i\auth_type = password" /etc/neutron/neutron.conf
sudo sed -i "$[linhanovaneutron+3] i\project_domain_name = default" /etc/neutron/neutron.conf
sudo sed -i "$[linhanovaneutron+4] i\user_domain_name = default" /etc/neutron/neutron.conf
sudo sed -i "$[linhanovaneutron+5] i\region_name = RegionOne" /etc/neutron/neutron.conf
sudo sed -i "$[linhanovaneutron+6] i\project_name = service" /etc/neutron/neutron.conf
sudo sed -i "$[linhanovaneutron+7] i\username = nova" /etc/neutron/neutron.conf
sudo sed -i "$[linhanovaneutron+8] i\password = senhaDaVMdoMato" /etc/neutron/neutron.conf

linhaml2neutron=`sudo awk '{if ($0 == "[ml2]") {print NR;}}' /etc/neutron/plugins/ml2/ml2_conf.ini`
sudo sed -i "$[linhaml2neutron+1] i\type_drivers = flat,vlan" /etc/neutron/plugins/ml2/ml2_conf.ini
sudo sed -i "$[linhaml2neutron+2] i\tenant_network_types = " /etc/neutron/plugins/ml2/ml2_conf.ini
sudo sed -i "$[linhaml2neutron+3] i\mechanism_drivers = linuxbridge" /etc/neutron/plugins/ml2/ml2_conf.ini
sudo sed -i "$[linhaml2neutron+4] i\extension_drivers = port_security" /etc/neutron/plugins/ml2/ml2_conf.ini

linhaml2flatneutron=`sudo awk '{if ($0 == "[ml2_type_flat]") {print NR;}}' /etc/neutron/plugins/ml2/ml2_conf.ini`
sudo sed -i "$[linhaml2flatneutron+1] i\flat_networks = provider" /etc/neutron/plugins/ml2/ml2_conf.ini

linhasecuritygroupneutron=`sudo awk '{if ($0 == "[securitygroup]") {print NR;}}' /etc/neutron/plugins/ml2/ml2_conf.ini`
sudo sed -i "$[linhasecuritygroupneutron+1] i\enable_ipset = true" /etc/neutron/plugins/ml2/ml2_conf.ini

linhalinuxbridgeneutron=`sudo awk '{if ($0 == "[linux_bridge]") {print NR;}}' /etc/neutron/plugins/ml2/linuxbridge_agent.ini`
sudo sed -i "$[linhalinuxbridgeneutron+1] i\physical_interface_mappings = provider:enp0s8" /etc/neutron/plugins/ml2/linuxbridge_agent.ini

linhavxlanneutron=`sudo awk '{if ($0 == "[vxlan]") {print NR;}}' /etc/neutron/plugins/ml2/linuxbridge_agent.ini`
sudo sed -i "$[linhavxlanneutron+1] i\enable_vxlan = false" /etc/neutron/plugins/ml2/linuxbridge_agent.ini

linhasecuritybridgeneutron=`sudo awk '{if ($0 == "[securitygroup]") {print NR;}}' /etc/neutron/plugins/ml2/linuxbridge_agent.ini`
sudo sed -i "$[linhasecuritybridgeneutron+1] i\enable_security_group = true" /etc/neutron/plugins/ml2/linuxbridge_agent.ini
sudo sed -i "$[linhasecuritybridgeneutron+2] i\firewall_driver = neutron.agent.linux.iptables_firewall.IptablesFirewallDriver" /etc/neutron/plugins/ml2/linuxbridge_agent.ini

linhadefaultneutron=`sudo awk '{if ($0 == "[DEFAULT]") {print NR;}}' /etc/neutron/dhcp_agent.ini`
sudo sed -i "$[linhadefaultneutron+1] i\interface_driver = linuxbridge" /etc/neutron/dhcp_agent.ini
sudo sed -i "$[linhadefaultneutron+2] i\dhcp_driver = neutron.agent.linux.dhcp.Dnsmasq" /etc/neutron/dhcp_agent.ini
sudo sed -i "$[linhadefaultneutron+3] i\enable_isolated_metadata = true" /etc/neutron/dhcp_agent.ini

service nova-compute restart
service neutron-linuxbridge-agent restart

linhadefaultneutron=`sudo awk '{if ($0 == "[DEFAULT]") {print NR;}}' /etc/neutron/metadata_agent.ini`
sudo sed -i "$[linhadefaultneutron+1] i\nova_metadata_host = controller" /etc/neutron/metadata_agent.ini
sudo sed -i "$[linhadefaultneutron+2] i\metadata_proxy_shared_secret = senhaDaVMdoMato" /etc/neutron/metadata_agent.ini


linhadefaultneutron=`sudo awk '{if ($0 == "[neutron]") {print NR;}}' /etc/nova/nova.conf`
sudo sed -i "$[linhadefaultneutron+1] i\url = http://localhost:9696" /etc/nova/nova.conf
sudo sed -i "$[linhadefaultneutron+2] i\auth_url = http://localhost:5000" /etc/nova/nova.conf
sudo sed -i "$[linhadefaultneutron+3] i\auth_type = password" /etc/nova/nova.conf
sudo sed -i "$[linhadefaultneutron+4] i\project_domain_name = default" /etc/nova/nova.conf
sudo sed -i "$[linhadefaultneutron+5] i\user_domain_name = default" /etc/nova/nova.conf
sudo sed -i "$[linhadefaultneutron+6] i\region_name = RegionOne" /etc/nova/nova.conf
sudo sed -i "$[linhadefaultneutron+7] i\project_name = service" /etc/nova/nova.conf
sudo sed -i "$[linhadefaultneutron+8] i\username = neutron" /etc/nova/nova.conf
sudo sed -i "$[linhadefaultneutron+9] i\password = senhaDaVMdoMato" /etc/nova/nova.conf
sudo sed -i "$[linhadefaultneutron+10] i\service_metadata_proxy = true" /etc/nova/nova.conf
sudo sed -i "$[linhadefaultneutron+11] i\metadata_proxy_shared_secret = senhaDaVMdoMato" /etc/nova/nova.conf

su -s /bin/sh -c "neutron-db-manage --config-file /etc/neutron/neutron.conf  --config-file /etc/neutron/plugins/ml2/ml2_conf.ini upgrade head" neutron

service nova-api restart
service neutron-server restart
service neutron-linuxbridge-agent restart
service neutron-dhcp-agent restart
service neutron-metadata-agent restart
~~~

===================================================
----------Finalizando a Instalação Ironic----------
===================================================
https://docs.openstack.org/ironic/queens/install/install-ubuntu.html

https://docs.openstack.org/ironic/queens/install/configure-integration.html