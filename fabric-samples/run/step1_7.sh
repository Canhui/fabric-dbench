ORGS=3

echo "------------------------------------------------------------"
echo "Copy peer files to peer"
echo "------------------------------------------------------------"
cp -r /home/t716/fabric-dbench/fabric-samples/peer0.org1.example.com/* /home/t716/fabric-dbench/fabric-run/peer/

for ((i=2;i<=$ORGS;i++))
do
    scp -r /home/t716/fabric-dbench/fabric-samples/peer0.org$i.example.com/* t716@peer0.org$i.example.com:/home/t716/fabric-dbench/fabric-run/peer/
done
