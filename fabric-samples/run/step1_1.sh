echo "------------------------------------------------------------"
echo "Remove cluster configuration file at the master node"
echo "------------------------------------------------------------"
rm -rf $HOME/fabric-dbench/fabric-samples/certs
rm -rf $HOME/fabric-dbench/fabric-samples/genesisblock
rm -rf $HOME/fabric-dbench/fabric-samples/orderer1.example.com
rm -rf $HOME/fabric-dbench/fabric-samples/peer0.org*.example.com
