Hostname="t716"
Password="T716rrs722"
Number_of_Organizations=2

# -----------------------------------------------------
# Clean step1 files
# -----------------------------------------------------
rm -rf $HOME/fabric-dbench/fabric-samples/configtx.yaml
rm -rf $HOME/fabric-dbench/orderer.example.com
rm -rf $HOME/fabric-dbench/peer0.org*.example.com
rm -rf $HOME/fabric-dbench/certs
echo [$Password] | sudo rm -rf $HOME/fabric-dbench/solo/*

# -----------------------------------------------------
# Clean step2 files
# -----------------------------------------------------
rm -rf $HOME/fabric-dbench/Admin@org*.example.com



# -----------------------------------------------------
# Finally, prepare for Github
# -----------------------------------------------------
sshpass -p "linux" scp -r -P 9003 $HOME/fabric-dbench/bin joe@158.182.9.174:/home/joe/Public/fabric-dbench
sshpass -p "linux" scp -r -P 9003 $HOME/fabric-dbench/configs joe@158.182.9.174:/home/joe/Public/fabric-dbench
sshpass -p "linux" scp -r -P 9003 $HOME/fabric-dbench/src joe@158.182.9.174:/home/joe/Public/fabric-dbench
