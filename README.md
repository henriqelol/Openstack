#===Guia de Instalação do OpenStack=== 
https://docs.openstack.org/install-guide/

#Acesso máquina Servidor
ssh -X asgard@192.168.88.76

#Ambientes criados com Ubuntu 16.04

##Controller Node 1
Config: Memória: 10240 mb, Proc: 4 Nucleo, Placa de Rede 1: host-only (vboxnet0), brigde enp10f0.
##Compute Node 1
Config: Memória: 10240 mb, Proc: 4 Nucleo, Placa de Rede 1: host-only (vboxnet0), brigde enp10f0.
##Block Node 1
Config: Memória: 10240 mb, Proc: 4 Nucleo, Placa de Rede 1: host-only (vboxnet0), brigde enp10f0.
##Object Node 1
Config: Memória: 10240 mb, Proc: 4 Nucleo, Placa de Rede 1: host-only (vboxnet0), brigde enp10f0.
##Object Node 2
Config: Memória: 10240 mb, Proc: 4 Nucleo, Placa de Rede 1: host-only (vboxnet0), brigde enp10f0.

#Configuração de Rede do Ambiente
##Controller Node 1
https://docs.openstack.org/install-guide/environment-networking-controller.html
##Compute Node 1
https://docs.openstack.org/install-guide/environment-networking-compute.html
##Block Node 1, Object Node 1, Object Node 2
https://docs.openstack.org/install-guide/environment-networking-storage-cinder.html

#Verificação de Connectiividade
https://docs.openstack.org/install-guide/environment-networking-verify.html

#Instalação e Configuração de componentes
##Controller
https://docs.openstack.org/install-guide/environment-ntp-controller.html

##Outros Nós
https://docs.openstack.org/install-guide/environment-ntp-other.html

#Instalação de Pacotes OpenStack no Ubuntu (Versão Queens).
https://docs.openstack.org/install-guide/environment-packages-ubuntu.html

#SQL Database
https://docs.openstack.org/install-guide/environment-sql-database-ubuntu.html

#Mensagem Queue
https://docs.openstack.org/install-guide/environment-messaging-ubuntu.html

#Etcd para Ubuntu
https://docs.openstack.org/install-guide/environment-etcd-ubuntu.html

#Instalação de Serviços OpenStack
https://docs.openstack.org/install-guide/openstack-services.html#minimal-deployment-for-queens
##Serviço de Identidade
https://docs.openstack.org/keystone/queens/install/
##Serviço de Image
https://docs.openstack.org/glance/queens/install/
##Serviço de Compute
https://docs.openstack.org/nova/queens/install/
##Serviço de Networking
https://docs.openstack.org/neutron/queens/install/
##Dashboard
https://docs.openstack.org/horizon/queens/install/
##Serviço de Armazenamento de Bloco
https://docs.openstack.org/cinder/queens/install/

#Erros e Bugs
https://docs.openstack.org/install-guide/environment-ntp-other.html
https://stackoverflow.com/questions/39281594/error-1698-28000-access-denied-for-user-rootlocalhost
https://docs.openstack.org/install-guide/environment-messaging.html
mysql -u root -p

https://docs.openstack.org/install-guide/environment-messaging-ubuntu.html
	rabbitmqctl add_user openstack RABBIT_PASS

https://docs.openstack.org/install-guide/environment-etcd-ubuntu.html
https://docs.openstack.org/install-guide/openstack-services.html
https://docs.openstack.org/keystone/queens/install/keystone-users-ubuntu.html
https://docs.openstack.org/keystone/queens/code_documentation.html

https://docs.openstack.org/keystone/queens/install/index-ubuntu.html
https://docs.openstack.org/keystone/queens/install/keystone-verify-ubuntu.html

openstack --os-auth-url http://controller:5000/v3  --os-project-domain-name Default --os-user-domain-name Default  --os-project-name admin --os-username admin token issue

openstack --os-auth-url http://controller:5000/v3 --os-project-domain-name Default --os-user-domain-name Default --os-project-name demo --os-username demo token issue
https://docs.openstack.org/keystone/queens/install/keystone-users-ubuntu.html

