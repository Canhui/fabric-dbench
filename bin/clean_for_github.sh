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
