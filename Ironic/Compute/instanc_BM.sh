openstack baremetal driver list

openstack baremetal --os-baremetal-api-version 1.31 driver list --type dynamic

openstack baremetal driver property list ipmi

openstack baremetal node create --driver ipmi

bash ~/openstack/Ironic/config.bare.sh

openstack baremetal node show NODE_UUID

openstack baremetal --os-baremetal-api-version 1.31 node set $NODE_UUID --deploy-interface direct --raid-interface agent

openstack baremetal node set $NODE_UUID --driver-info ipmi_username=$USER --driver-info ipmi_password=$PASS --driver-info ipmi_address=$ADDRESS

openstack baremetal node set $NODE_UUID --driver-info ipmi_port=$PORT_NUMBER

openstack baremetal node create --driver ipmi --driver-info ipmi_username=$USER --driver-info ipmi_password=$PASS --driver-info ipmi_address=$ADDRESS

openstack baremetal node set $NODE_UUID --driver-info deploy_kernel=$DEPLOY_VMLINUZ_UUID --driver-info deploy_ramdisk=$DEPLOY_INITRD_UUID

openstack baremetal node set $NODE_UUID --driver-info cleaning_network=$CLEAN_UUID_OR_NAME --driver-info provisioning_network=$PROVISION_UUID_OR_NAME

openstack baremetal port create $MAC_ADDRESS --node $NODE_UUID

openstack --os-baremetal-api-version 1.21 baremetal node set $NODE_UUID --resource-class $CLASS_NAME

openstack --os-baremetal-api-version 1.21 baremetal node create --driver $DRIVER --resource-class $CLASS_NAME

openstack baremetal node set $NODE_UUID --property cpus=$CPU_COUNT --property memory_mb=$RAM_MB --property local_gb=$DISK_GB --property cpu_arch=$ARCH

openstack baremetal node create --driver ipmi --driver-info ipmi_username=$USER --driver-info ipmi_password=$PASS --driver-info ipmi_address=$ADDRESS --property cpus=$CPU_COUNT --property memory_mb=$RAM_MB --property local_gb=$DISK_GB --property cpu_arch=$ARCH

openstack baremetal node set $NODE_UUID --property capabilities=key1:val1,key2:val2

openstack baremetal node add trait $NODE_UUID CUSTOM_TRAIT1 HW_CPU_X86_VMX

openstack baremetal node validate $NODE_UUID

openstack baremetal --os-baremetal-api-version 1.11 node manage $NODE_UUID

openstack baremetal node show $NODE_UUID

nova-manage cell_v2 discover_hosts

openstack baremetal node create --driver ipmi --name BAREMETAL

openstack baremetal node show BAREMETAL

openstack baremetal --os-baremetal-api-version 1.31 driver show ipmi