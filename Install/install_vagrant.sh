apt -y remove vagrant 2>> rm-vagrant.log && apt -y purge vagrant 2>> pg-vagrant.log

rm -rf /opt/vagrant 2>> rm-vagrant_opt.log & rm -f /usr/bin/vagrant 2>> rm-vagrant_bin.log

wget https://releases.hashicorp.com/vagrant/2.2.1/vagrant_2.2.1_x86_64.deb
dpkg -i vagrant_2.2.1_x86_64.deb
vagrant -v
which vagrant
