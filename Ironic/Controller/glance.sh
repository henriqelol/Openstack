mysql -u root -psenhaDaVMdoMato
CREATE DATABASE glance;
GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'localhost' IDENTIFIED BY 'senhaDaVMdoMato';
GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'%' IDENTIFIED BY 'senhaDaVMdoMato';
exit;

openstack user create --domain default --password senhaDaVMdoMato glance
openstack service create --name glance --description "OpenStack Image" image
openstack endpoint create --region RegionOne image public http://controller:9292
openstack endpoint create --region RegionOne image internal http://controller:9292
openstack endpoint create --region RegionOne image admin http://controller:9292
apt -qy install glance 2>> glance-error.log

sed -i 's/connection\ \=\ sqlite\:\/\/\/\/var\/lib\/glance\/glance\.sqlite/connection\ \=\ mysql\+pymysql\:\/\/glance\:senhaDaVMdoMato\@controller\/glance/g' /etc/glance/glance-api.conf
sed -i '/^\[keystone_authtoken\]/a auth_uri = http://controller:5000 \nauth_url = http://controller:5000 \nmemcached_servers = controller:11211 \nauth_type = password \nproject_domain_name = Default \nuser_domain_name = Default \nproject_name = service \nusername = glance \npassword = senhaDaVMdoMato' /etc/glance/glance-api.conf
sed -i '/^\[glance_store\]/a stores = file,http \ndefault_store = file \nfilesystem_store_datadir = /var/lib/glance/images/' /etc/glance/glance-registry.conf
sed -i 's/connection\ \=\ sqlite\:\/\/\/\/var\/lib\/glance\/glance\.sqlite/connection\ \=\ mysql\+pymysql\:\/\/glance\:senhaDaVMdoMato\@controller\/glance/g' /etc/glance/glance-registry.conf
sed -i '/^\[keystone_authtoken\]/a auth_uri = http://controller:5000 \nauth_url = http://controller:5000 \nmemcached_servers = controller:11211 \nauth_type = password \nproject_domain_name = Default \nuser_domain_name = Default \nproject_name = service \nusername = glance \npassword = senhaDaVMdoMato' /etc/glance/glance-registry.conf
sed -i '/^\[paste_deploy\]/a flavor = keystone' /etc/glance/glance-registry.conf

/bin/sh -c "glance-manage db_sync" glance

service glance-registry restart
service glance-api restart

wget http://download.cirros-cloud.net/0.4.0/cirros-0.4.0-x86_64-disk.img
openstack image create "cirros" --file cirros-0.4.0-x86_64-disk.img --disk-format qcow2 --container-format bare --public
openstack image list
