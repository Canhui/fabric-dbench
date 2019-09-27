echo "------------------------------------------------------------"
echo "Run the crypto-config.yaml configuration file"
echo "------------------------------------------------------------"
$HOME/fabric-dbench/fabric-samples/bin/cryptogen generate --config=$HOME/fabric-dbench/configs/crypto-config.yaml --output $HOME/fabric-dbench/certs
