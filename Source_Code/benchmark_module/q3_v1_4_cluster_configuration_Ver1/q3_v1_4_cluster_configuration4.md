## 1. 安装合约

下载编译合约。
```shell
$ go get github.com/introclass/hyperledger-fabric-chaincodes/demo
$ cd $HOME/go/src/github.com/introclass/hyperledger-fabric-chaincodes/demo
$ go build
$ rm -rf demo
```

**步骤1.1.** peer0@org1.example.com打包，签署。
```shell
~/fabric-samples$ cd Admin@org1.example.com
~/fabric-samples/Admin@org1.example.com$ ./peer.sh chaincode package demo-pack.out -n demo -v 0.0.1 -s -S -p github.com/introclass/hyperledger-fabric-chaincodes/demo
2019-06-10 20:40:13.867 HKT [chaincodeCmd] checkChaincodeCmdParams -> INFO 001 Using default escc
2019-06-10 20:40:13.868 HKT [chaincodeCmd] checkChaincodeCmdParams -> INFO 002 Using default vscc
2019-06-10 20:40:14.549 HKT [main] main -> INFO 003 Exiting.....
~/fabric-samples/Admin@org1.example.com$ ./peer.sh chaincode signpackage demo-pack.out signed-demo-pack.out
Wrote signed package to signed-demo-pack.out successfully
2019-06-10 20:40:52.556 HKT [main] main -> INFO 001 Exiting.....
```

**步骤1.2.** peer0@org1.example.com安装，查询合约。
```shell
~/fabric-samples/Admin@org1.example.com$ ./peer.sh chaincode install ./signed-demo-pack.out
2019-06-10 20:41:41.886 HKT [main] main -> INFO 001 Exiting.....
~/fabric-samples/Admin@org1.example.com$ ./peer.sh chaincode list   --installed
Get installed chaincodes on peer:
Name: demo, Version: 0.0.1, Path: github.com/introclass/hyperledger-fabric-chaincodes/demo, Id: c8a9b1a9dbb99d5cc030ce931edb01a1bf110e9778fad852bdd4abbeba92eec2
2019-06-10 20:41:59.285 HKT [main] main -> INFO 001 Exiting.....
```

**步骤1.4.** peer0@org2.example.com安装，查询合约。
```shell
~/fabric-samples$ cp Admin\@org1.example.com/signed-demo-pack.out  Admin\@org2.example.com/
~/fabric-samples$ cd Admin\@org2.example.com/
~/fabric-samples/Admin@org2.example.com$ ./peer.sh chaincode install ./signed-demo-pack.out
2019-06-10 20:46:11.385 HKT [main] main -> INFO 001 Exiting.....
```


<br />
<br />

## 2. 初始化合约
由合约的打包签署者对合约进行初始化。
```shell
~/fabric-samples/Admin@org1.example.com$ ./peer.sh chaincode instantiate -o orderer.example.com:7050 --tls true --cafile ./tlsca.example.com-cert.pem -C mychannel -n demo -v 0.0.1 -c '{"Args":["init"]}' -P "OR('Org1MSP.member','Org2MSP.member')"
2019-06-10 20:50:07.713 HKT [chaincodeCmd] checkChaincodeCmdParams -> INFO 001 Using default escc
2019-06-10 20:50:07.713 HKT [chaincodeCmd] checkChaincodeCmdParams -> INFO 002 Using default vscc
2019-06-10 20:50:32.222 HKT [main] main -> INFO 003 Exiting.....
```

<br />
<br />

## 3. 写入/查询合约
任意一个节点均可写入/查询合约。

**步骤3.1.** 写入合约。
```shell
~/fabric-samples/Admin@org2.example.com$ ./peer.sh chaincode invoke -o orderer.example.com:7050  --tls true --cafile ./tlsca.example.com-cert.pem -C mychannel -n demo -c '{"Args":["write","key1","key1valueisabc"]}'
2019-06-10 20:52:28.297 HKT [chaincodeCmd] checkChaincodeCmdParams -> INFO 001 Using default escc
2019-06-10 20:52:28.297 HKT [chaincodeCmd] checkChaincodeCmdParams -> INFO 002 Using default vscc
2019-06-10 20:52:50.288 HKT [chaincodeCmd] chaincodeInvokeOrQuery -> INFO 003 Chaincode invoke successful. result: status:200 
2019-06-10 20:52:50.288 HKT [main] main -> INFO 004 Exiting.....
```

```
./peer.sh chaincode query -C mychannel -n demo -c '{"Args":["query","key1"]}'
```


