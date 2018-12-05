echo "Verificando Operações"
hostname

echo "Ping"
ping -c 4 controller  
ping -c 4 compute  
ping -c 4 block  

echo "Chrony"
chronyc sources