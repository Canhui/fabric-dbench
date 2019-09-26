echo "------------------------------------------------------------"
echo "Remove and rebuild fabric data file of all peers"
echo "------------------------------------------------------------"

ssh $1@peer0.org1.example.com "rm -rf $HOME/fabric-dbench/run/*"
ssh $1@peer0.org1.example.com "mkdir -p $HOME/fabric-dbench/run/orderer"
ssh $1@peer0.org1.example.com "mkdir -p $HOME/fabric-dbench/run/peer"

if (($2 > 1)); then
    for ((i=2;i<=$2;i++))
    do
        ssh $1@peer0.org$i.example.com "rm -rf $HOME/fabric-dbench/run/*"
        ssh $1@peer0.org$i.example.com "mkdir -p $HOME/fabric-dbench/run/orderer"
        ssh $1@peer0.org$i.example.com "mkdir -p $HOME/fabric-dbench/run/peer"
    done
fi
