mysql -u root -psenhaDaVMdoMato
CREATE DATABASE neutron;
GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'localhost' IDENTIFIED BY 'senhaDaVMdoMato';
GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'%' IDENTIFIED BY 'senhaDaVMdoMato';
exit;
source /home/vagrant/admin-openrc
openstack user create --domain default --password-prompt neutron
openstack role add --project service --user neutron admin
openstack service create --name neutron --description "OpenStack Networking" network
openstack endpoint create --region RegionOne network public http://controller:9696
openstack endpoint create --region RegionOne network internal http://controller:9696
openstack endpoint create --region RegionOne network admin http://controller:9696

echo "##Redes de Autoatendimento"
apt -qy install neutron-server neutron-plugin-ml2 neutron-linuxbridge-agent neutron-l3-agent neutron-dhcp-agent neutron-metadata-agent 2>> neutron-error.log

sed -i 's/sqlite:\/\/\/\/var\/lib\/neutron\/neutron.sqlite/mysql+pymysql:\/\/neutron:senhaDaVMdoMato@controller\/neutron/' /etc/neutron/neutron.conf
linhadefaultneutron=`awk '{if ($0 == "[DEFAULT]") {print NR;}}' /etc/neutron/neutron.conf`
sed -i "$[linhadefaultneutron+2] i\service_plugins = router" /etc/neutron/neutron.conf
sed -i "$[linhadefaultneutron+3] i\allow_overlapping_ips = true" /etc/neutron/neutron.conf
sed -i "$[linhadefaultneutron+4] i\transport_url = rabbit://openstack:senhaDaVMdoMato@controller" /etc/neutron/neutron.conf
sed -i "$[linhadefaultneutron+5] i\auth_strategy = keystone" /etc/neutron/neutron.conf
sed -i "$[linhadefaultneutron+6] i\notify_nova_on_port_status_changes = true" /etc/neutron/neutron.conf
sed -i "$[linhadefaultneutron+7] i\notify_nova_on_port_data_changes = true" /etc/neutron/neutron.conf
linhaauthtokenneutron=`awk '{if ($0 == "[keystone_authtoken]") {print NR;}}' /etc/neutron/neutron.conf`
sed -i "$[linhaauthtokenneutron+1] i\auth_uri = http://controller:5000" /etc/neutron/neutron.conf
sed -i "$[linhaauthtokenneutron+2] i\auth_url = http://controller:5000" /etc/neutron/neutron.conf
sed -i "$[linhaauthtokenneutron+3] i\memcached_servers = controller:11211" /etc/neutron/neutron.conf
sed -i "$[linhaauthtokenneutron+4] i\auth_type = password" /etc/neutron/neutron.conf
sed -i "$[linhaauthtokenneutron+5] i\project_domain_name = default" /etc/neutron/neutron.conf
sed -i "$[linhaauthtokenneutron+6] i\user_domain_name = default" /etc/neutron/neutron.conf
sed -i "$[linhaauthtokenneutron+7] i\project_name = service" /etc/neutron/neutron.conf
sed -i "$[linhaauthtokenneutron+8] i\username = neutron" /etc/neutron/neutron.conf
sed -i "$[linhaauthtokenneutron+9] i\password = senhaDaVMdoMato" /etc/neutron/neutron.conf
linhanovaneutron=`awk '{if ($0 == "[nova]") {print NR;}}' /etc/neutron/neutron.conf`
sed -i "$[linhanovaneutron+1] i\auth_url = http://controller:5000" /etc/neutron/neutron.conf
sed -i "$[linhanovaneutron+2] i\auth_type = password" /etc/neutron/neutron.conf
sed -i "$[linhanovaneutron+3] i\project_domain_name = default" /etc/neutron/neutron.conf
sed -i "$[linhanovaneutron+4] i\user_domain_name = default" /etc/neutron/neutron.conf
sed -i "$[linhanovaneutron+5] i\region_name = RegionOne" /etc/neutron/neutron.conf
sed -i "$[linhanovaneutron+6] i\project_name = service" /etc/neutron/neutron.conf
sed -i "$[linhanovaneutron+7] i\username = nova" /etc/neutron/neutron.conf
sed -i "$[linhanovaneutron+8] i\password = senhaDaVMdoMato" /etc/neutron/neutron.conf
linhaml2neutron=`awk '{if ($0 == "[ml2]") {print NR;}}' /etc/neutron/plugins/ml2/ml2_conf.ini`
sed -i "$[linhaml2neutron+1] i\type_drivers = flat,vlan,vxlan" /etc/neutron/plugins/ml2/ml2_conf.ini
sed -i "$[linhaml2neutron+2] i\tenant_network_types = vxlan" /etc/neutron/plugins/ml2/ml2_conf.ini
sed -i "$[linhaml2neutron+3] i\mechanism_drivers = linuxbridge,l2population" /etc/neutron/plugins/ml2/ml2_conf.ini
sed -i "$[linhaml2neutron+4] i\extension_drivers = port_security" /etc/neutron/plugins/ml2/ml2_conf.ini
linhaml2flatneutron=`awk '{if ($0 == "[ml2_type_flat]") {print NR;}}' /etc/neutron/plugins/ml2/ml2_conf.ini`
sed -i "$[linhaml2flatneutron+1] i\flat_networks = provider" /etc/neutron/plugins/ml2/ml2_conf.ini
linhaml2vxlanneutron=`awk '{if ($0 == "[ml2_type_vxlan]") {print NR;}}' /etc/neutron/plugins/ml2/ml2_conf.ini`
sed -i "$[linhaml2vxlanneutron+1] i\vni_ranges = 1:1000" /etc/neutron/plugins/ml2/ml2_conf.ini
linhasecuritygroupneutron=`awk '{if ($0 == "[securitygroup]") {print NR;}}' /etc/neutron/plugins/ml2/ml2_conf.ini`
sed -i "$[linhasecuritygroupneutron+1] i\enable_ipset = true" /etc/neutron/plugins/ml2/ml2_conf.ini
linhalinuxbridgeneutron=`awk '{if ($0 == "[linux_bridge]") {print NR;}}' /etc/neutron/plugins/ml2/linuxbridge_agent.ini`
sed -i "$[linhalinuxbridgeneutron+1] i\physical_interface_mappings = provider:enp0s9" /etc/neutron/plugins/ml2/linuxbridge_agent.ini
linhavxlanneutron=`awk '{if ($0 == "[vxlan]") {print NR;}}' /etc/neutron/plugins/ml2/linuxbridge_agent.ini`
sed -i "$[linhavxlanneutron+1] i\enable_vxlan = true" /etc/neutron/plugins/ml2/linuxbridge_agent.ini
sed -i "$[linhavxlanneutron+2] i\local_ip = 10.0.0.11" /etc/neutron/plugins/ml2/linuxbridge_agent.ini
sed -i "$[linhavxlanneutron+3] i\l2_population = true" /etc/neutron/plugins/ml2/linuxbridge_agent.ini
linhasecuritybridgeneutron=`awk '{if ($0 == "[securitygroup]") {print NR;}}' /etc/neutron/plugins/ml2/linuxbridge_agent.ini`
sed -i "$[linhasecuritybridgeneutron+1] i\enable_security_group = true" /etc/neutron/plugins/ml2/linuxbridge_agent.ini
sed -i "$[linhasecuritybridgeneutron+2] i\firewall_driver = neutron.agent.linux.iptables_firewall.IptablesFirewallDriver" /etc/neutron/plugins/ml2/linuxbridge_agent.ini
echo "IMPORTANTE SAIDA VALOR SYSCTL = 1"
sysctl net.bridge.bridge-nf-call-iptables 
sysctl net.bridge.bridge-nf-call-ip6tables
echo "============================"
linhadefaultl3neutron=`awk '{if ($0 == "[DEFAULT]") {print NR;}}' /etc/neutron/l3_agent.ini`
sed -i "$[linhadefaultl3neutron+1] i\interface_driver = linuxbridge" /etc/neutron/l3_agent.ini
linhadefaultdhcpneutron=`awk '{if ($0 == "[DEFAULT]") {print NR;}}' /etc/neutron/dhcp_agent.ini`
sed -i "$[linhadefaultdhcpneutron+1] i\interface_driver = linuxbridge" /etc/neutron/dhcp_agent.ini
sed -i "$[linhadefaultdhcpneutron+2] i\dhcp_driver = neutron.agent.linux.dhcp.Dnsmasq" /etc/neutron/dhcp_agent.ini
sed -i "$[linhadefaultdhcpneutron+3] i\enable_isolated_metadata = true" /etc/neutron/dhcp_agent.ini
linhadefaultmetadataneutron=`awk '{if ($0 == "[DEFAULT]") {print NR;}}' /etc/neutron/metadata_agent.ini`
sed -i "$[linhadefaultmetadataneutron+1] i\nova_metadata_host = controller" /etc/neutron/metadata_agent.ini
sed -i "$[linhadefaultmetadataneutron+2] i\metadata_proxy_shared_secret = senhaDaVMdoMato" /etc/neutron/metadata_agent.ini
linhaneutronnova=`awk '{if ($0 == "[neutron]") {print NR;}}' /etc/nova/nova.conf`
sed -i "$[linhaneutronnova+1] i\url = http://controller:9696" /etc/nova/nova.conf
sed -i "$[linhaneutronnova+2] i\auth_url = http://controller:5000" /etc/nova/nova.conf
sed -i "$[linhaneutronnova+3] i\auth_type = password" /etc/nova/nova.conf
sed -i "$[linhaneutronnova+4] i\project_domain_name = default" /etc/nova/nova.conf
sed -i "$[linhaneutronnova+5] i\user_domain_name = default" /etc/nova/nova.conf
sed -i "$[linhaneutronnova+6] i\region_name = RegionOne" /etc/nova/nova.conf
sed -i "$[linhaneutronnova+7] i\project_name = service" /etc/nova/nova.conf
sed -i "$[linhaneutronnova+8] i\username = neutron" /etc/nova/nova.conf
sed -i "$[linhaneutronnova+9] i\password = senhaDaVMdoMato" /etc/nova/nova.conf
sed -i "$[linhaneutronnova+10] i\service_metadata_proxy = true" /etc/nova/nova.conf
sed -i "$[linhaneutronnova+11] i\metadata_proxy_shared_secret = senhaDaVMdoMato" /etc/nova/nova.conf

su -s /bin/sh -c "neutron-db-manage --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/plugins/ml2/ml2_conf.ini upgrade head" neutron 2>> neutron-db-manage-error.log

service nova-api restart
service neutron-server restart
service neutron-linuxbridge-agent restart
service neutron-dhcp-agent restart
service neutron-metadata-agent restart
service neutron-l3-agent restart
