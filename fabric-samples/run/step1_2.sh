echo "------------------------------------------------------------"
echo "Remove and rebuild fabric data file at all cluster nodes"
echo "------------------------------------------------------------"
ansible all -m shell -a "echo [T716rrs722] | sudo rm -rf /home/t716/fabric-dbench/fabric-run/*"
ansible all -m file -a "path=/home/t716/fabric-dbench/fabric-run/orderer state=directory"
ansible all -m file -a "path=/home/t716/fabric-dbench/fabric-run/peer state=directory"
echo "<---------------Step 2 successfully finished--------------->"
