apt -qy install nova-compute 2>> nova-error.log

sed -i 's/^log_dir = \/var\/log\/nova/#log_dir = \/var\/log\/nova/' /etc/nova/nova.conf
sed -i '/^\[DEFAULT\]/a transport_url = rabbit://openstack:senhaDaVMdoMato@controller \nmy_ip = 10.0.0.41 \nuse_neutron = true \nfirewall_driver = nova.virt.firewall.NoopFirewallDriver' /etc/nova/nova.conf
sed -i '/^\[api\]/a auth_strategy = keystone' /etc/nova/nova.conf
sed -i '/^\[keystone_authtoken\]/a auth_url = http://controller:5000/v3 \nmemcached_servers = controller:11211 \nauth_type = password \nproject_domain_name = default \nuser_domain_name = default \nproject_name = service \nusername = nova \npassword = senhaDaVMdoMato' /etc/nova/nova.conf
sed -i '/^\[vnc\]/a enabled = true \nserver_listen = 0.0.0.0 \nserver_proxyclient_address = 10.0.0.41 \nnovncproxy_base_url = http://controller:6080/vnc_auto.html' /etc/nova/nova.conf
sed -i '/^\[glance\]/a api_servers = http://controller:9292' /etc/nova/nova.conf
sed -i '/^\[oslo_concurrency\]/a lock_path = /var/lib/nova/tmp' /etc/nova/nova.conf
sed -i 's/os_region_name = openstack/#os_region_name = openstack/g' /etc/nova/nova.conf
sed -i '/^\[placement\]/a os_region_name = RegionOne \nproject_domain_name = Default \nproject_name = service \nauth_type = password \nuser_domain_name = Default \nauth_url = http://controller:5000/v3 \nusername = placement \npassword = senhaDaVMdoMato' /etc/nova/nova.conf

egrep -c '(vmx|svm)' /proc/cpuinfo
sed -i 's/^virt_type=kvm/virt_type=qemu/' /etc/nova/nova-compute.conf

service nova-compute restart
