chaincode_name="demo"
channel_name="mychannel"
ORGS=3
#endorsement_policy="OR('Org1MSP.member','Org2MSP.member','Org3MSP.member')"
endorsement_policy="AND('Org1MSP.member','Org2MSP.member','Org3MSP.member')"



echo "------------------------------------------------------------"
echo "Org1 Signs and Installs Chaincode"
echo "------------------------------------------------------------"
cd /home/t716/fabric-dbench/fabric-samples/Admin@org1.example.com
./peer.sh chaincode package demo-pack.out -n $chaincode_name -v 0.0.1 -s -S -p github.com/introclass/hyperledger-fabric-chaincodes/demo
./peer.sh chaincode signpackage demo-pack.out signed-demo-pack.out
./peer.sh chaincode install ./signed-demo-pack.out
./peer.sh chaincode list --installed


echo "------------------------------------------------------------"
echo "Copy and Install Chaincode to Other Organizations"
echo "------------------------------------------------------------"
for ((i=2;i<=$ORGS;i++))
do
    cp /home/t716/fabric-dbench/fabric-samples/Admin\@org1.example.com/signed-demo-pack.out /home/t716/fabric-dbench/fabric-samples/Admin\@org$i.example.com/
    cd /home/t716/fabric-dbench/fabric-samples/Admin\@org$i.example.com/
    ./peer.sh chaincode install ./signed-demo-pack.out
done


echo "------------------------------------------------------------"
echo "Org1 Initiates Chaincode"
echo "------------------------------------------------------------"
cd /home/t716/fabric-dbench/fabric-samples/Admin\@org1.example.com/
./peer.sh chaincode instantiate -o orderer1.example.com:7050 --tls true --cafile ./tlsca.example.com-cert.pem -C $channel_name -n $chaincode_name -v 0.0.1 -c '{"Args":["init"]}' -P $endorsement_policy

#./peer.sh chaincode instantiate -o orderer.example.com:7050 --tls true --cafile ./tlsca.example.com-cert.pem -C $channel_name -n $chaincode_name -v 0.0.1 -c '{"Args":["init"]}' -P "OR('Org1MSP.member','Org2MSP.member')"

