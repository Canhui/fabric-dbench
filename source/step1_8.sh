echo "------------------------------------------------------------"
echo "Create genesis block and setup the network"
echo "------------------------------------------------------------"
cp $HOME/fabric-dbench/configs/configtx.yaml $HOME/fabric-samples
cd $HOME/fabric-samples
$HOME/fabric-samples/bin/configtxgen -profile TwoOrgsOrdererGenesis -outputBlock $HOME/fabric-dbench/genesisblock
cp $HOME/fabric-dbench/genesisblock $HOME/fabric-dbench/run/orderer/
rm -rf $HOME/fabric-dbench/genesisblock
