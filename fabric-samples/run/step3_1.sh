channel_name="mychannel2"
ORGS=3


echo "------------------------------------------------------------"
echo "Clean channel environment"
echo "------------------------------------------------------------"
rm -rf /home/t716/fabric-dbench/fabric-samples/channeltx/*
rm -rf /home/t716/fabric-dbench/fabric-samples/Admin\@org*.example.com/tlsca.example.com-cert.pem


echo "------------------------------------------------------------"
echo "Create Channel.tx"
echo "------------------------------------------------------------"
mkdir /home/t716/fabric-dbench/fabric-samples/channeltx
/home/t716/fabric-dbench/fabric-samples/bin/configtxgen -profile TwoOrgsChannel -outputCreateChannelTx /home/t716/fabric-dbench/fabric-samples/channeltx/$channel_name.tx -channelID $channel_name



echo "------------------------------------------------------------"
echo "Configure Anchor Peers"
echo "------------------------------------------------------------"
for ((i=1;i<=$ORGS;i++))
do
    /home/t716/fabric-dbench/fabric-samples/bin/configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate /home/t716/fabric-dbench/fabric-samples/channeltx/Org${i}MSPanchors.tx -channelID $channel_name -asOrg Org${i}MSP
done


echo "------------------------------------------------------------"
echo "Configure TLS for Admins"
echo "------------------------------------------------------------"
for ((i=1;i<=$ORGS;i++))
do
    cp /home/t716/fabric-dbench/fabric-samples/certs/ordererOrganizations/example.com/tlsca/tlsca.example.com-cert.pem  /home/t716/fabric-dbench/fabric-samples/Admin\@org${i}.example.com/
done


echo "------------------------------------------------------------"
echo "Org1 Generates Channel.block and Copy Channel.block to channeltx Folder"
echo "------------------------------------------------------------"
cd /home/t716/fabric-dbench/fabric-samples/Admin\@org1.example.com
/home/t716/fabric-dbench/fabric-samples/Admin\@org1.example.com/peer.sh channel create -o orderer1.example.com:7050 -c $channel_name -f /home/t716/fabric-dbench/fabric-samples/channeltx/$channel_name.tx --tls true --cafile tlsca.example.com-cert.pem
cp $channel_name.block /home/t716/fabric-dbench/fabric-samples/channeltx/


echo "------------------------------------------------------------"
echo "All Peers Join the Channel"
echo "------------------------------------------------------------"
for ((i=1;i<=$ORGS;i++))
do 
    cd /home/t716/fabric-dbench/fabric-samples/Admin\@org$i.example.com
    ./peer.sh channel join -b /home/t716/fabric-dbench/fabric-samples/channeltx/$channel_name.block
done
