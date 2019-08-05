## 1. Peer安装合约

下载编译合约，

```shell
$ go get github.com/introclass/hyperledger-fabric-chaincodes/demo
$ cd $HOME/go/src/github.com/introclass/hyperledger-fabric-chaincodes/demo
$ go build
$ rm -rf demo
```

**步骤1.1.** peer0@org1.example.com打包，签署。

```shell
~/fabric-samples/Admin@org1.example.com$ ./peer.sh chaincode package demo-pack.out -n demo -v 0.0.1 -s -S -p github.com/introclass/hyperledger-fabric-chaincodes/demo
~/fabric-samples/Admin@org1.example.com$ ./peer.sh chaincode signpackage demo-pack.out signed-demo-pack.out
```

**步骤1.2.** peer0@org1.example.com安装，查询合约。
```shell
~/fabric-samples/Admin@org1.example.com$ ./peer.sh chaincode install ./signed-demo-pack.out
~/fabric-samples/Admin@org1.example.com$ ./peer.sh chaincode list   --installed
```

<br />
<br />

## 2. Orderer管理员安装合约

Peer通过TLS连接Orderer，通过管理员的在Orderer安装合约。

```shell
~/fabric-samples/Admin@org1.example.com$ ./peer.sh chaincode instantiate -o orderer.example.com:7050 --tls true --cafile ./tlsca.example.com-cert.pem -C mychannel -n demo -v 0.0.1 -c '{"Args":["init"]}' -P "OR('Org1MSP.member','Org2MSP.member')"
```

通过Orderer的初始化，每一个Peer节点都成功相应的合约了，下一步可以在任意一个节点进行合约的调用。

<br />
<br />


## 3. 写入/查询合约

```shell
./peer.sh chaincode invoke -o orderer.example.com:7050  --tls true --cafile ./tlsca.example.com-cert.pem -C mychannel -n demo -c '{"Args":["write","key1","key1valueisabc"]}'
```
