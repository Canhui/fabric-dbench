echo "------------------------------------------------------------"
echo "Clean all configuration files at the master node"
echo "------------------------------------------------------------"
rm -rf $HOME/fabric-dbench/certs
rm -rf $HOME/fabric-dbench/genesisblock
rm -rf $HOME/fabric-dbench/orderer.example.com
rm -rf $HOME/fabric-dbench/peer0.org*.example.com
rm -rf $HOME/fabric-dbench/fabric-samples/configtx.yaml
