echo "------------------------------------------------------------"
echo "Remove cluster configuration file at the master node"
echo "------------------------------------------------------------"
rm -rf $HOME/fabric-dbench/fabric-samples/certs
rm -rf $HOME/fabric-dbench/fabric-samples/genesisblock
rm -rf $HOME/fabric-dbench/fabric-samples/orderer*.example.com
sudo rm -rf $HOME/fabric-dbench/fabric-samples/peer0.org*.example.com
