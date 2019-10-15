ORGS=3

echo "------------------------------------------------------------"
echo "Build the peer configuration files"
echo "------------------------------------------------------------"
mkdir /home/t716/fabric-dbench/fabric-samples/peer0.org1.example.com
cp /home/t716/fabric-dbench/fabric-samples/bin/peer /home/t716/fabric-dbench/fabric-samples/peer0.org1.example.com/
cp -rf /home/t716/fabric-dbench/fabric-samples/certs/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/* /home/t716/fabric-dbench/fabric-samples/peer0.org1.example.com/
cp /home/t716/fabric-dbench/fabric-samples/configyaml/core.yaml /home/t716/fabric-dbench/fabric-samples/peer0.org1.example.com
mkdir /home/t716/fabric-dbench/fabric-samples/peer0.org1.example.com/data

for ((i=2;i<=$ORGS;i++))
do
    cp -rf /home/t716/fabric-dbench/fabric-samples/peer0.org1.example.com/ /home/t716/fabric-dbench/fabric-samples/peer0.org$i.example.com/
    rm -rf /home/t716/fabric-dbench/fabric-samples/peer0.org$i.example.com/msp/
    rm -rf /home/t716/fabric-dbench/fabric-samples/peer0.org$i.example.com/tls/
    cp -rf /home/t716/fabric-dbench/fabric-samples/certs/peerOrganizations/org$i.example.com/peers/peer0.org$i.example.com/* /home/t716/fabric-dbench/fabric-samples/peer0.org$i.example.com/
    sed -i "s/peer0.org1.example.com/peer0\.org$i\.example.com/g" /home/t716/fabric-dbench/fabric-samples/peer0.org$i.example.com/core.yaml
    sed -i "s/Org1MSP/Org${i}MSP/g" /home/t716/fabric-dbench/fabric-samples/peer0.org$i.example.com/core.yaml
done
