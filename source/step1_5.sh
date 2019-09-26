echo "------------------------------------------------------------"
echo "Build the peer configuration files"
echo "------------------------------------------------------------"
mkdir $HOME/fabric-dbench/peer0.org1.example.com
cp $HOME/fabric-samples/bin/peer $HOME/fabric-dbench/peer0.org1.example.com/
cp -rf $HOME/fabric-dbench/certs/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/* $HOME/fabric-dbench/peer0.org1.example.com/
cp $HOME/fabric-dbench/configs/core.yaml $HOME/fabric-dbench/peer0.org1.example.com/
mkdir $HOME/fabric-dbench/peer0.org1.example.com/data

if (($1 > 1)); then
    for ((i=2;i<=$1;i++))
	do
		cp -rf $HOME/fabric-dbench/peer0.org1.example.com/ $HOME/fabric-dbench/peer0.org$i.example.com/
		rm -rf $HOME/fabric-dbench/peer0.org$i.example.com/msp/
		rm -rf $HOME/fabric-dbench/peer0.org$i.example.com/tls/
		cp -rf $HOME/fabric-dbench/certs/peerOrganizations/org$i.example.com/peers/peer0.org$i.example.com/* $HOME/fabric-dbench/peer0.org$i.example.com/
		sed -i "s/peer0.org1.example.com/peer0\.org$i\.example.com/g" $HOME/fabric-dbench/peer0.org$i.example.com/core.yaml
		sed -i "s/Org1MSP/Org${i}MSP/g" $HOME/fabric-dbench/peer0.org$i.example.com/core.yaml
	done
fi
