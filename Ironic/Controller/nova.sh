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
openstack endpoint create --region RegionOne compute public http://controller:8774/v2.1
openstack endpoint create --region RegionOne compute internal http://controller:8774/v2.1
openstack endpoint create --region RegionOne compute admin http://controller:8774/v2.1
openstack user create --domain default --password senhaDaVMdoMato placement
openstack role add --project service --user placement admin
openstack service create --name placement --description "Placement API" placement
openstack endpoint create --region RegionOne placement public http://controller:8778
openstack endpoint create --region RegionOne placement internal http://controller:8778
openstack endpoint create --region RegionOne placement admin http://controller:8778
apt -qy install nova-api nova-conductor nova-consoleauth nova-novncproxy nova-scheduler nova-placement-api 2>> nova-error.log

sed -i 's/connection\ \=\ sqlite\:\/\/\/\/var\/lib\/nova\/nova_api\.sqlite/connection\ \=\ mysql\+pymysql\:\/\/nova\:senhaDaVMdoMato\@controller\/nova_api/g' /etc/nova/nova.conf 
sed -i 's/connection\ \=\ sqlite\:\/\/\/\/var\/lib\/nova\/nova\.sqlite/connection\ \=\ mysql\+pymysql\:\/\/nova\:senhaDaVMdoMato\@controller\/nova/g' /etc/nova/nova.conf 
sed -i '/^\[DEFAULT\]/a transport_url = rabbit://openstack:senhaDaVMdoMato@controller \nmy_ip = 10.0.0.11 \nuse_neutron = true \nfirewall_driver = nova.virt.firewall.NoopFirewallDriver' /etc/nova/nova.conf
sed -i '/^\[api\]/a auth_strategy = keystone' /etc/nova/nova.conf
sed -i '/^\[keystone_authtoken\]/a auth_url = http://controller:5000/v3 \nmemcached_servers = controller:11211 \nauth_type = password \nproject_domain_name = default \nuser_domain_name = default \nproject_name = service \nusername = nova \npassword = senhaDaVMdoMato' /etc/nova/nova.conf
sed -i '/^\[vnc\]/a enabled = true \nserver_listen = $my_ip \nserver_proxyclient_address = $my_ip' /etc/nova/nova.conf
sed -i '/^\[glance\]/a api_servers = http://controller:9292' /etc/nova/nova.conf
sed -i '/^\[oslo_concurrency\]/a lock_path = /var/lib/nova/tmp' /etc/nova/nova.conf
sed -i 's/os_region_name = openstack/#os_region_name = openstack/g' /etc/nova/nova.conf
sed -i '/^\[placement\]/a os_region_name = RegionOne \nproject_domain_name = Default \nproject_name = service \nauth_type = password \nuser_domain_name = Default \nauth_url = http://controller:5000/v3 \nusername = placement \npassword = senhaDaVMdoMato' /etc/nova/nova.conf
su -s /bin/sh -c "nova-manage api_db sync" nova
su -s /bin/sh -c "nova-manage cell_v2 map_cell0" nova
su -s /bin/sh -c "nova-manage cell_v2 create_cell --name=cell1 --verbose" nova
su -s /bin/sh -c "nova-manage db sync" nova
service nova-api restart
service nova-consoleauth restart
service nova-scheduler restart
service nova-conductor restart
service nova-novncproxy restart

#Adicione a máquina Compute para o banco de dados do cell
#Execute os comandos abaixo no controller.
#openstack compute service list --service nova-compute
#su -s /bin/sh -c "nova-manage cell_v2 discover_hosts --verbose" nova
#sed -i '/^\[scheduler\]/a discover_hosts_in_cells_interval = 300' /etc/nova/nova.conf

openstack compute service list
openstack catalog list
openstack image list
nova-status upgrade check
