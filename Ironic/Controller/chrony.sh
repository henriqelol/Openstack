apt -qy install chrony 2>> apt-chrony-error.log

sh -c "echo 'server 3.br.pool.ntp.org iburst' >> /etc/chrony/chrony.conf"
sh -c "echo 'server 0.south-america.pool.ntp.org iburst' >> /etc/chrony/chrony.conf"
sh -c "echo 'server 3.south-america.pool.ntp.org iburst' >> /etc/chrony/chrony.conf"
sh -c "echo 'allow 10.0.0.0/24' >> /etc/chrony/chrony.conf"

service chrony restart