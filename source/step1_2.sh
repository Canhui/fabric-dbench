Total_Orgs=3
Your_Hostname="t716"

echo "------------------------------------------------------------"
echo "Remove and rebuild fabric data file of all peers"
echo "------------------------------------------------------------"
for ((i=1;i<=$Total_Orgs;i++))
do
    ssh $Your_Hostname@peer0.org$i.example.com "rm -rf $HOME/fabric-dbench/run/*"
    ssh $Your_Hostname@peer0.org$i.example.com "mkdir -p $HOME/fabric-dbench/run/orderer"
    ssh $Your_Hostname@peer0.org$i.example.com "mkdir -p $HOME/fabric-dbench/run/peer"
done


#ansible all -m shell -a "echo [T716rrs722] | sudo rm -rf /home/t716/joe/fabric/*"
#ansible all -m file -a "path=/home/t716/joe/fabric/orderer state=directory"
#ansible all -m file -a "path=/home/t716/joe/fabric/peer state=directory"


#for ((i=1;i<=$KAFKAS;i++))
#do
#    echo "$i, $1"
#    #echo "$i" | ssh t716@zookeeper$i "cat > /tmp/zookeeper/myid"
#done
