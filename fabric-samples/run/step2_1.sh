ORGS=3

echo "------------------------------------------------------------"
echo "Step 1: Create Admins"
echo "------------------------------------------------------------"

for ((i=1;i<=$ORGS;i++))
do
    rm -rf /home/t716/fabric-dbench/fabric-samples/Admin@org$i.example.com
done


mkdir /home/t716/fabric-dbench/fabric-samples/Admin@org1.example.com
cp -rf /home/t716/fabric-dbench/fabric-samples/certs/peerOrganizations/org1.example.com/users/Admin\@org1.example.com/* /home/t716/fabric-dbench/fabric-samples/Admin\@org1.example.com/
cp /home/t716/fabric-dbench/fabric-samples/peer0.org1.example.com/core.yaml  /home/t716/fabric-dbench/fabric-samples/Admin\@org1.example.com/
cat>/home/t716/fabric-dbench/fabric-samples/Admin\@org1.example.com/peer.sh<<EOF
#!/bin/bash
PATH=\`pwd\`/../bin:\$PATH
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
echo [T716rrs722] | sudo chmod +x /home/t716/fabric-dbench/fabric-samples/Admin\@org1.example.com/peer.sh


for ((i=2;i<=$ORGS;i++))
do
    cp -rf  /home/t716/fabric-dbench/fabric-samples/Admin\@org1.example.com/ /home/t716/fabric-dbench/fabric-samples/Admin\@org$i.example.com/
    rm -rf  /home/t716/fabric-dbench/fabric-samples/Admin\@org$i.example.com/msp/
    rm -rf  /home/t716/fabric-dbench/fabric-samples/Admin\@org$i.example.com/tls/
    cp -rf /home/t716/fabric-dbench/fabric-samples/certs/peerOrganizations/org$i.example.com/users/Admin\@org$i.example.com/* /home/t716/fabric-dbench/fabric-samples/Admin\@org$i.example.com/
    cp /home/t716/fabric-dbench/fabric-samples/peer0.org$i.example.com/core.yaml /home/t716/fabric-dbench/fabric-samples/Admin\@org$i.example.com/
    sed -i "s/org1/org$i/g" /home/t716/fabric-dbench/fabric-samples/Admin\@org$i.example.com/peer.sh
    sed -i "s/Org1/Org$i/g" /home/t716/fabric-dbench/fabric-samples/Admin\@org$i.example.com/peer.sh
    echo [T716rrs722] | sudo chmod +x /home/t716/fabric-dbench/fabric-samples/Admin\@org$i.example.com/peer.sh
done
echo "<---------------Step 1 successfully finished--------------->"
