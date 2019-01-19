echo "Verificando Operações"
hostname

echo "Ping"
ping -c 4 controller  
ping -c 4 compute  
ping -c 4 block  

echo "Chrony"
chronyc sources

#Adicione a máquina Compute para o banco de dados do cell
#Execute os comandos abaixo no controller.
openstack compute service list --service nova-compute
su -s /bin/sh -c "nova-manage cell_v2 discover_hosts --verbose" nova
sed -i '/^\[scheduler\]/a discover_hosts_in_cells_interval = 300' /etc/nova/nova.conf

openstack compute service list
openstack catalog list
openstack image list
nova-status upgrade check