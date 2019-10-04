ORDERERS=3

echo "------------------------------------------------------------"
echo "Build the orderer configuration files"
echo "------------------------------------------------------------"
mkdir /home/t716/fabric-dbench/fabric-samples/orderer1.example.com
cp /home/t716/fabric-dbench/fabric-samples/bin/orderer /home/t716/fabric-dbench/fabric-samples/orderer1.example.com/
cp -rf /home/t716/fabric-dbench/fabric-samples/certs/ordererOrganizations/example.com/orderers/orderer1.example.com/* /home/t716/fabric-dbench/fabric-samples/orderer1.example.com/
cp /home/t716/fabric-dbench/fabric-samples/configyaml/orderer.yaml /home/t716/fabric-dbench/fabric-samples/orderer1.example.com/
mkdir /home/t716/fabric-dbench/fabric-samples/orderer1.example.com/data


for ((i=2;i<=$ORDERERS;i++))
do
    mkdir /home/t716/fabric-dbench/fabric-samples/orderer$i.example.com
    cp /home/t716/fabric-dbench/fabric-samples/bin/orderer /home/t716/fabric-dbench/fabric-samples/orderer$i.example.com/
    cp -rf /home/t716/fabric-dbench/fabric-samples/certs/ordererOrganizations/example.com/orderers/orderer$i.example.com/* /home/t716/fabric-dbench/fabric-samples/orderer$i.example.com/
    cp /home/t716/fabric-dbench/fabric-samples/configyaml/orderer.yaml /home/t716/fabric-dbench/fabric-samples/orderer$i.example.com/
    mkdir /home/t716/fabric-dbench/fabric-samples/orderer$i.example.com/data
done
