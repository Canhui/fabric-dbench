ORDERERS=3

echo "------------------------------------------------------------"
echo "Create genesis block and setup the network"
echo "------------------------------------------------------------"
cd /home/t716/fabric-dbench/fabric-samples
/home/t716/fabric-dbench/fabric-samples/bin/configtxgen -profile TwoOrgsOrdererGenesis -outputBlock /home/t716/fabric-dbench/fabric-samples/genesisblock
cp /home/t716/fabric-dbench/fabric-samples/genesisblock /home/t716/fabric-dbench/fabric-run/orderer/

for ((i=2;i<=$ORDERERS;i++))
do
    scp -r /home/t716/fabric-dbench/fabric-samples/genesisblock t716@orderer$i.example.com:/home/t716/fabric-dbench/fabric-run/orderer/
done

rm -rf /home/t716/fabric-dbench/fabric-samples/genesisblock
