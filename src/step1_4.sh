echo "------------------------------------------------------------"
echo "Build the orderer configuration files"
echo "------------------------------------------------------------"
mkdir $HOME/fabric-dbench/orderer.example.com
cp $HOME/fabric-dbench/fabric-samples/bin/orderer $HOME/fabric-dbench/orderer.example.com/
cp -rf $HOME/fabric-dbench/fabric-samples/certs/ordererOrganizations/example.com/orderers/orderer.example.com/* $HOME/fabric-dbench/orderer.example.com/
cp $HOME/fabric-dbench/configs/orderer.yaml $HOME/fabric-dbench/orderer.example.com/
mkdir $HOME/fabric-dbench/orderer.example.com/data
