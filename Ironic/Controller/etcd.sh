apt -qy install etcd 2>> apt-etcd-error.log

sed -i 's/# ETCD_NAME/ETCD_NAME/' /etc/default/etcd
sed -i 's/# ETCD_DATA_DIR/ETCD_DATA_DIR/' /etc/default/etcd
sed -i 's/# ETCD_INITIAL_CLUSTER_STATE/ETCD_INITIAL_CLUSTER_STATE/' /etc/default/etcd
sed -i 's/# ETCD_INITIAL_CLUSTER_TOKEN/ETCD_INITIAL_CLUSTER_TOKEN/' /etc/default/etcd
sed -i 's/# ETCD_INITIAL_CLUSTER/ETCD_INITIAL_CLUSTER/' /etc/default/etcd
sed -i 's/# ETCD_INITIAL_ADVERTISE_PEER_URLS/ETCD_INITIAL_ADVERTISE_PEER_URLS/' /etc/default/etcd
sed -i 's/# ETCD_ADVERTISE_CLIENT_URLS/ETCD_ADVERTISE_CLIENT_URLS/' /etc/default/etcd
sed -i 's/# ETCD_LISTEN_PEER_URLS/ETCD_LISTEN_PEER_URLS/' /etc/default/etcd
sed -i 's/# ETCD_LISTEN_CLIENT_URLS/ETCD_LISTEN_CLIENT_URLS/' /etc/default/etcd

sed -i 's/ETCD_NAME="hostname"/ETCD_NAME="controller"/g' /etc/default/etcd
sed -i 's/ETCD_DATA_DIR="\/var\/lib\/etcd\/default"/ETCD_DATA_DIR="\/var\/lib\/etcd"/' /etc/default/etcd
sed -i 's/ETCD_INITIAL_CLUSTER_STATE="existing"/ETCD_INITIAL_CLUSTER_STATE="new"/g' /etc/default/etcd
sed -i "s/new/\'new\'/" /etc/default/etcd
sed -i 's/etcd-cluster/etcd-cluster-01/' /etc/default/etcd
sed -i 's/ETCD_INITIAL_CLUSTER="default=http\:\/\/localhost\:2380,default=http\:\/\/localhost\:7001"/ETCD_INITIAL_CLUSTER="controller=http\:\/\/10.0.0.11\:2380"/g' /etc/default/etcd
sed -i 's/ETCD_INITIAL_ADVERTISE_PEER_URLS="http\:\/\/localhost\:2380,http\:\/\/localhost\:7001"/ETCD_INITIAL_ADVERTISE_PEER_URLS="http\:\/\/10.0.0.11\:2380"/g' /etc/default/etcd
sed -i 's/ETCD_ADVERTISE_CLIENT_URLS="http\:\/\/localhost\:2379,http\:\/\/localhost\:4001"/ETCD_ADVERTISE_CLIENT_URLS="http\:\/\/10.0.0.11\:2379"/g' /etc/default/etcd
sed -i 's/ETCD_LISTEN_PEER_URLS="http\:\/\/localhost\:2380,http\:\/\/localhost\:7001"/ETCD_LISTEN_PEER_URLS="http\:\/\/0.0.0.0\:2380"/g' /etc/default/etcd
sed -i 's/ETCD_LISTEN_CLIENT_URLS="http\:\/\/localhost\:2379,http\:\/\/localhost\:4001"/ETCD_LISTEN_CLIENT_URLS="http\:\/\/10.0.0.11\:2379"/g' /etc/default/etcd

sed -i 's/on-abnormal/on-failure/' /lib/systemd/system/etcd.service
sed -i 's/ExecStart=\/usr\/bin\/etcd \$DAEMON_ARGS/ExecStart=\/usr\/bin\/etcd \-\-config\-file \/etc\/default\/etcd/' /lib/systemd/system/etcd.service

sudo systemctl enable etcd >> etcd.log 2>> etcd-error.log
sudo systemctl start etcd