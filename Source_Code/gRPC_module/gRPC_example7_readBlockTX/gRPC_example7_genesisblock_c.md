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

问题: Orderer的Admin用户是拥有Orderer私钥的用户？ Orderer的Admin用户也是Peer的Admin用户? Orderer的Admin用户的私钥和Peer的Admin用户的私钥一样?

Every node and user must have a local MSP defined, as it defines who has administrative or participatory rights at that level ()





问题: TLS的证书就是所谓的local MSP？

Peer需要通过TLS通信，以便连接到Orderer，然后获取Blockchain Ledger更新。https://zhuanlan.zhihu.com/p/35683522


问题: 关于TLS连接？连接到一个Orderer或者是连接到一个Peer？连接过程验证什么？

https://blog.csdn.net/u014120464/article/details/80069520








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

Channel configurations contain all of the information relevant to the administration of a channel. Most importantly, the channel configuration specifies which organizations are members of channel, but it also includes other channel-wide configuration information such as channel access policies and block batch sizes--This configuration is stored on the ledger in a block, and is therefore known as a configuration block. Configuration blocks contains a single configuration. The first of these blocks is known as the "genesis block" and contains the initial configuration required to bootstrap a channel. Each time the configuration of a channel changes it is done through a new configuration block, with the latest configuration block representing the current channel configuration. Orderers and peers keep the current configuration in memory to facilitate all channel operations such as cutting a new block and validating block transactions.

Because configurations are stored in blocks, updating a config happens through a process called a "configuration transaction". Update a config is a process of pulling the config, transalting into a format that humans can read, modifying it and then submitting it for approval. 更多参考: https://hyperledger-fabric.readthedocs.io/en/latest/config_update.html









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



```shell
~/fabric-samples/Admin@org1.example.com$ ./peer.sh channel update -o orderer.example.com:7050 -c mychannel -f ../Org1MSPanchors.tx --tls true --cafile ./tlsca.example.com-cert.pem
```

添加anchor peer后，anchor peer的信息被写入到blockchain中。




<br />
<br />


## 参考资料
[1. 关于多个channels的配置] https://medium.com/@kctheservant/demo-of-multi-channel-network-in-hyperledger-fabric-640f7158e2d3
