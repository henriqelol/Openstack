mysql -u root -psenhaDaVMdoMato
CREATE DATABASE keystone;
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' IDENTIFIED BY 'senhaDaVMdoMato';
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' IDENTIFIED BY 'senhaDaVMdoMato';
exit;

apt -qy install keystone 2>> keystone-error.log

apt -qy install apache2 2>> apache2-error.log

apt -qy install libapache2-mod-wsgi 2>> libapache2-mod-wsgi-error.log 

sed -i 's/^#memcache_servers = localhost:11211/memcache_servers = controller:11211/' /etc/keystone/keystone.conf
sed -i 's/connection\ \=\ sqlite\:\/\/\/\/var\/lib\/keystone\/keystone\.db/connection\ \=\ mysql\+pymysql\:\/\/keystone\:senhaDaVMdoMato\@controller\/keystone/g' /etc/keystone/keystone.conf
sed -i '/^\[token\]/a provider = fernet' /etc/keystone/keystone.conf
su -s /bin/sh -c "keystone-manage db_sync" keystone
keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone
keystone-manage credential_setup --keystone-user keystone --keystone-group keystone
keystone-manage bootstrap --bootstrap-password senhaDaVMdoMato \
  --bootstrap-admin-url http://controller:5000/v3/ \
  --bootstrap-internal-url http://controller:5000/v3/ \
  --bootstrap-public-url http://controller:5000/v3/ \
  --bootstrap-region-id RegionOne

echo "ServerName controller" >> /etc/apache2/apache2.conf
service apache2 restart

openstack token issue
openstack domain create --description "An Example Domain" example
openstack project create --domain default --description "Service Project" service
openstack project create --domain default --description "Demo Project" demo
openstack user create --domain default --password senhaDaVMdoMato demo
openstack role create user
openstack role add --project demo --user demo user
