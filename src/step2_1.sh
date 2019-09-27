echo "------------------------------------------------------------"
echo "Create admins"
echo "------------------------------------------------------------"

rm -rf $HOME/fabric-dbench/Admin@org*.example.com
mkdir $HOME/fabric-dbench/Admin@org1.example.com
cp -rf $HOME/fabric-dbench/certs/peerOrganizations/org1.example.com/users/Admin\@org1.example.com/* $HOME/fabric-dbench/Admin\@org1.example.com/
cp -rf $HOME/fabric-dbench/peer0.org1.example.com/core.yaml $HOME/fabric-dbench/Admin\@org1.example.com/

cat>$HOME/fabric-dbench/Admin\@org1.example.com/peer.sh<<EOF
#!/bin/bash
PATH=\`pwd\`/../../fabric-samples/bin:\$PATH
export FABRIC_CFG_PATH=\`pwd\`
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_TLS_CERT_FILE=./tls/client.crt
export CORE_PEER_TLS_KEY_FILE=./tls/client.key
export CORE_PEER_MSPCONFIGPATH=./msp
export CORE_PEER_ADDRESS=peer0.org1.example.com:7051
export CORE_PEER_LOCALMSPID=Org1MSP
export CORE_PEER_TLS_ROOTCERT_FILE=./tls/ca.crt
export CORE_PEER_ID=cli
export CORE_LOGGING_LEVEL=INFO
peer \$*
EOF
chmod +x $HOME/fabric-dbench/Admin\@org1.example.com/peer.sh

if (($1 > 1)); then
	for ((i=2;i<=$1;i++))
	do
    	cp -rf $HOME/fabric-dbench/Admin\@org1.example.com/ $HOME/fabric-dbench/Admin\@org$i.example.com/
    	rm -rf $HOME/fabric-dbench/Admin\@org$i.example.com/msp/
    	rm -rf $HOME/fabric-dbench/Admin\@org$i.example.com/tls/
    	cp -rf $HOME/fabric-dbench/certs/peerOrganizations/org$i.example.com/users/Admin\@org$i.example.com/* $HOME/fabric-dbench/Admin\@org$i.example.com/
    	cp $HOME/fabric-dbench/peer0.org$i.example.com/core.yaml $HOME/fabric-dbench/Admin\@org$i.example.com/
    	sed -i "s/org1/org$i/g" $HOME/fabric-dbench/Admin\@org$i.example.com/peer.sh
    	sed -i "s/Org1/Org$i/g" $HOME/fabric-dbench/Admin\@org$i.example.com/peer.sh
        chmod +x $HOME/fabric-dbench/Admin\@org$i.example.com/peer.sh
	done
fi
