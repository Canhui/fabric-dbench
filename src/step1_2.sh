#Hostname="t716"
#Password="T716rrs722"
#Number_of_Organizations=2

echo "------------------------------------------------------------"
echo "Remove and rebuild fabric data file of all peers"
echo "------------------------------------------------------------"

ssh $1@peer0.org1.example.com "echo [$2] | sudo rm -rf $HOME/fabric-dbench/solo/*"
ssh $1@peer0.org1.example.com "mkdir -p $HOME/fabric-dbench/solo/orderer"
ssh $1@peer0.org1.example.com "mkdir -p $HOME/fabric-dbench/solo/peer"

if (($3 > 1)); then
    for ((i=2;i<=$3;i++))
    do
        ssh $1@peer0.org$i.example.com "echo [$2] | sudo rm -rf $HOME/fabric-dbench/solo/*"
        ssh $1@peer0.org$i.example.com "mkdir -p $HOME/fabric-dbench/solo/orderer"
        ssh $1@peer0.org$i.example.com "mkdir -p $HOME/fabric-dbench/solo/peer"
    done
fi
