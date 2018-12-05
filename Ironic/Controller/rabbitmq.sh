apt -qy install rabbitmq-server 2>> rabbitmq-error.log

systemctl enable rabbitmq-server.service
systemctl start rabbitmq-server.service
rabbitmqctl add_user openstack senhaDaVMdoMato
rabbitmqctl set_permissions openstack "." "." ".*"
rabbitmqctl start_app
