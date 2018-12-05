echo "Install PY Server and MYSQL Server"
echo Y|apt-get install python-openstackclient 2>> openstackclient-error.log mysql-server 2>> mysql-server.log

echo "Config Mysql"
sed -i 's/127.0.0.1/10.0.0.11/' /etc/mysql/mysql.conf.d/mysqld.cnf
sed -i 's/^#max_connections/max_connections/' /etc/mysql/mysql.conf.d/mysqld.cnf
sed -i 's/= 100$/= 4096/' /etc/mysql/mysql.conf.d/mysqld.cnf
service mysql restart

mysqladmin -u root -p '' password 'senhaDaVMdoMato'
#mysql -h localhost -u root -p
#uninstall plugin validate_password;
echo "finish"