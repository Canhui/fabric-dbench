上一篇博客我们成功配置了Hyperledger Fabric网络系统。但是到目前为止，peer节点还没有整条区块链的数据，也没有初始化区块的数据。

下面我们创建channel，channel中的所有Orderer和peers共享同一条区块链的数据，包括区块链的初始化数据。

<br />


## 1. 配置channel

**步骤1.1.** 创建生成channel.tx备用。

```shell
~/fabric-samples$ ./bin/configtxgen -profile TwoOrgsChannel -outputCreateChannelTx mychannel.tx -channelID mychannel
```

其中，channel的配置需要参考创世块的配置文件configtx.yaml文件，-profile就是在创世块configtx.yaml中定义的。



**步骤1.2.** 生成锚点配置文件Org1MSPanchors.tx备用。

```shell
~/fabric-samples$ ./bin/configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate Org1MSPanchors.tx -channelID mychannel -asOrg Org1MSP
```

**步骤1.3.** 复制Orderer证书到Administor。

```shell
~/fabric-samples$ cp certs/ordererOrganizations/example.com/tlsca/tlsca.example.com-cert.pem  Admin\@org1.example.com/
```



<br />
<br />

## 2. Orderer的Admin用户创建Channel

问题: 谁，用什么工具，创建了Channel?

拥有certs/ordererOrganizations/example.com/tlsca/tlsca.example.com-cert.pem的Orderer的Admin用户拥有创建Channel的权限————The `peer channel` command allows administrators to perform channel related operations on a peer, such as joining a channel or listing the channels to which a peer is joined. --cafile <string> where string is a fully qualified path to a file containing PEM-encoded certificate chain of the certificate Authority of the orderer with who the peer is communicating. 

注意: 其中.pem可以转化为private key，参考: https://stackoverflow.com/questions/13732826/convert-pem-to-crt-and-key


**步骤2.1.** Admin@org1.example.com创建mychannel.block备用。

```shell
~/fabric-samples$ cd Admin@org1.example.com
~/fabric-samples/Admin@org1.example.com$ ./peer.sh channel create -o orderer.example.com:7050 -c mychannel -f ../mychannel.tx --tls true --cafile tlsca.example.com-cert.pem
```

生成mychannel.block，其中，包含
orderer的msp/signcerts
orderer的msp/cacerts
orderer的msp/admincerts
orderer的msp/tlscacerts

peer的msp/cacerts
peer的msp/admincerts
peer的msp/tlscacerts
peer的msp/admincerts



**步骤2.2.** Admin@org1.example.com添加peer0.org1.example.com:7051到mychannel.block

```shell
~/fabric-samples/Admin@org1.example.com$ ./peer.sh channel join -b mychannel.block
```

此时，加入channel完毕后，mychannel.block作为初始创世块，写入区块链的第一个区块。




**步骤2.3.** Admin@org1.example.com查看peer0.org1.example.com:7051所在channel
```shell
~/fabric-samples/Admin@org2.example.com$ ./peer.sh channel list
```

问题: 一个peer是如何加入channel中的？peer怎么验证自己加入channel中？






<br />
<br />

## 3. Peer的genesis block对比orderer的genesis block

之前的orderer的genesis block只有orderer的信息

现在的peer的genesis block不仅有orderer的信息，也包括peer的信息。








<br />
<br />

## 4. 添加anchor peer信息到blockchain

**步骤4.1.** 更新区块数据，加入org1.example.com加入锚点。

问题: anchor peer加入信息到blockchain ledger，整个ledger如何变化？










<br />
<br />


## 参考资料
[1. 关于多个channels的配置] https://medium.com/@kctheservant/demo-of-multi-channel-network-in-hyperledger-fabric-640f7158e2d3

