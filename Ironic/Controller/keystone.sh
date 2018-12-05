echo "Create BD keystone"
mysql -u root -psenhaDaVMdoMato
CREATE DATABASE keystone;
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' IDENTIFIED BY 'senhaDaVMdoMato';
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' IDENTIFIED BY 'senhaDaVMdoMato';
exit;
echo "install keystone apache2"
apt -y install keystone 2>> keystone-error.log
apt -y install apache2 2>> apache2-error.log
apt -y install libapache2-mod-wsgi 2>> libapache2-mod-wsgi-error.log 
#apt -qy install python-oauth2client 2>> oauth2client-error.log
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

echo "export OS_USERNAME=admin" >> /home/vagrant/admin-openrc
echo "export OS_PASSWORD=senhaDaVMdoMato" >> /home/vagrant/admin-openrc
echo "export OS_PROJECT_NAME=admin" >> /home/vagrant/admin-openrc
echo "export OS_USER_DOMAIN_NAME=Default" >> /home/vagrant/admin-openrc
echo "export OS_PROJECT_DOMAIN_NAME=Default" >> /home/vagrant/admin-openrc
echo "export OS_AUTH_URL=http://localhost:5000/v3" >> /home/vagrant/admin-openrc
echo "export OS_IDENTITY_API_VERSION=3" >> /home/vagrant/admin-openrc

echo "export OS_PROJECT_DOMAIN_NAME=Default" >> /home/vagrant/demon-openrc
echo "export OS_USER_DOMAIN_NAME=Default" >> /home/vagrant/demon-openrc
echo "export OS_PROJECT_NAME=demo" >> /home/vagrant/demon-openrc
echo "export OS_USERNAME=demo" >> /home/vagrant/demon-openrc
echo "export OS_PASSWORD=senhaDaVMdoMato" >> /home/vagrant/demon-openrc
echo "export OS_AUTH_URL=http://controller:5000/v3" >> /home/vagrant/demon-openrc
echo "export OS_IDENTITY_API_VERSION=3" >> /home/vagrant/demon-openrc
echo "export OS_IMAGE_API_VERSION=2" >> /home/vagrant/demon-openrc

mv /home/vagrant/backup/admin-openrc /home/vagrant/
mv /home/vagrant/backup/demon-openrc /home/vagrant/

source /home/vagrant/admin-openrc
source /home/vagrant/demon-openrc

openstack token issue

echo "Openstack"
openstack domain create --description "An Example Domain" example
openstack project create --domain default --description "Service Project" service
openstack project create --domain default --description "Demo Project" demo
openstack user create --domain default --password senhaDaVMdoMato demo
openstack role create user
openstack role add --project demo --user demo user
echo "Finish"
