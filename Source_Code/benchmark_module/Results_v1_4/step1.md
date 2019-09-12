## 1. Step 1: kafka performance

./peer.sh chaincode invoke -o orderer.example.com:7050  --tls true --cafile ./tlsca.example.com-cert.pem -C mychannel3 -n demo -c '{"Args":["write","key1","key1valueisabc"]}'


