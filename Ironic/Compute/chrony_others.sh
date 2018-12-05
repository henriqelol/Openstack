echo "Network Time Protocol (NTP)"
echo "Chrony"

apt -qy install chrony 2>> apt-chrony-error.log

sudo sed -i 's/^pool/#pool/' /etc/chrony/chrony.conf
sh -c "echo 'server controller iburst' >> /etc/chrony/chrony.conf"

service chrony restart
if [ $? -ne 0 ]; then echo "Error"; fi