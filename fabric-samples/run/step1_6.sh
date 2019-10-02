ORDERERS=3

echo "------------------------------------------------------------"
echo "Copy orderer configuration files to orderer"
echo "------------------------------------------------------------"
cp -r /home/t716/fabric-dbench/fabric-samples/orderer1.example.com/* /home/t716/fabric-dbench/fabric-run/orderer/

for ((i=2;i<=$ORDERERS;i++))
do
    scp -r /home/t716/fabric-dbench/fabric-samples/orderer$i.example.com/* t716@orderer$i.example.com:/home/t716/fabric-dbench/fabric-run/orderer/
done
