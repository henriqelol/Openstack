dpkg --configure -a
apt-get -y update 2>> update-error.log && apt-get -y dist-upgrade 2>> dist-upgrade-error.log && apt-get -y autoremove

echo Y|apt-get install software-properties-common

echo Y|add-apt-repository cloud-archive:queens

apt-get -qy install python-openstackclient 2>> apt-openstackclient-error.log

echo "##Limpando sources.list"
>/etc/apt/sources.listNOVO
grep -v ^# /etc/apt/sources.list > /etc/apt/sources.listNOVO 
sed '/^$/d' /etc/apt/sources.listNOVO > /etc/apt/sources.list
rm /etc/apt/sources.listNOVO
echo "##Update Finalizado"