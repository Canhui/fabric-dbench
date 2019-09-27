echo "------------------------------------------------------------"
echo "Build the orderer configuration files"
echo "------------------------------------------------------------"
mkdir /home/t716/fabric-dbench/fabric-samples/orderer.example.com
cp /home/t716/fabric-dbench/fabric-samples/bin/orderer /home/t716/fabric-dbench/fabric-samples/orderer.example.com/
cp -rf /home/t716/fabric-dbench/fabric-samples/certs/ordererOrganizations/example.com/orderers/orderer.example.com/* /home/t716/fabric-dbench/fabric-samples/orderer.example.com/
cp /home/t716/fabric-dbench/fabric-samples/configyaml/orderer.yaml /home/t716/fabric-dbench/fabric-samples/orderer.example.com/
mkdir /home/t716/fabric-dbench/fabric-samples/orderer.example.com/data
