#Total_Orgs=3
#Your_Hostname="t716"


echo "------------------------------------------------------------"
echo "Copy peer files to peer"
echo "------------------------------------------------------------"
cp -r $HOME/fabric-dbench/peer0.org1.example.com/* $HOME/fabric-dbench/run/peer/

for ((i=2;i<=$2;i++))
do
    scp -r $HOME/fabric-dbench/peer0.org$i.example.com/* $1@peer0.org$i.example.com:$HOME/fabric-dbench/run/peer/
done
