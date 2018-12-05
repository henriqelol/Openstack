wget http://releases.ubuntu.com/16.04/ubuntu-16.04.5-server-amd64.iso
mkdir -p /var/vbox
echo "Criando ModelOVA"
VBoxManage createvm --name ModelOVA --ostype "Ubuntu_64" --register --basefolder /var/vbox
VBoxManage modifyvm ModelOVA --cpus 2 --memory 3100 --vram 9
VBoxManage modifyvm ModelOVA --nic1 nat
VBoxManage modifyvm ModelOVA --natpf1 "ssh, tcp, 127.0.0.1,2222, 10.0.2.15, 22"
VBoxManage modifyvm ModelOVA --nic2 hostonly --hostonlyadapter2 vboxnet0
VBoxManage modifyvm ModelOVA --nic3 bridged --bridgeadapter3 eth0
VBoxManage createhd --filename /var/box/ModelOVA.vdi --size 40000 --format VDI --variant Standard
VBoxManage storagectl ModelOVA --name "ModelOVA SATA" --add sata --bootable on
VBoxManage storageattach ModelOVA --storagectl "ModelOVA SATA" --port 0 --device 0 --type hdd --medium /var/box/ModelOVA.vdi
VBoxManage storagectl ModelOVA --name "IDE ModelOVA" --add ide
VBoxManage storageattach ModelOVA --storagectl "IDE ModelOVA" --port 0  --device 0 --type dvddrive --medium ~/ubuntu-16.04.5-server-amd64.iso
echo "ModelOVA finalizado"
echo "====================="
VBoxManage showvminfo ModelOVA
sleep 15
echo "Ligando ModelOVA"
echo "Instale o sistema e configure a rede para acesso ssh"
VBoxManage startvm ModelOVA --type gui
echo "Sistema instalado"
vboxmanage export ModelOVA -o ModelOVA.ova
vboxmanage unregistervm ModelOVA --delete
vboxmanage import ModelOVA.ova
