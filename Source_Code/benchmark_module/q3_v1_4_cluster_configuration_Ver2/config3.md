## 1. 配置channel

**步骤1.1.** 创建生成channel.tx备用。
```shell
~/fabric-samples$ ./bin/configtxgen -profile TwoOrgsChannel -outputCreateChannelTx mychannel.tx -channelID mychannel
2019-06-09 22:03:42.790 HKT [common/tools/configtxgen] main -> INFO 001 Loading configuration
2019-06-09 22:03:42.828 HKT [common/tools/configtxgen] doOutputChannelCreateTx -> INFO 002 Generating new channel configtx
2019-06-09 22:03:42.864 HKT [common/tools/configtxgen] doOutputChannelCreateTx -> INFO 003 Writing new channel tx
```

**步骤1.2.** 生成锚点配置文件备用。
```shell
~/fabric-samples$ ./bin/configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate Org1MSPanchors.tx -channelID mychannel -asOrg Org1MSP
~/fabric-samples$ ./bin/configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate Org2MSPanchors.tx -channelID mychannel -asOrg Org2MSP
```

**步骤1.3.** 复制证书。
```shell
~/fabric-samples$ cp certs/ordererOrganizations/example.com/tlsca/tlsca.example.com-cert.pem  Admin\@org1.example.com/
~/fabric-samples$ cp certs/ordererOrganizations/example.com/tlsca/tlsca.example.com-cert.pem  Admin\@org2.example.com/
```


<br />
<br />

## 2. 创建channel

**步骤2.1.** Admin@org1.example.com创建channel.block备用。

```shell
~/fabric-samples$ cd Admin@org1.example.com
~/fabric-samples/Admin@org1.example.com$ ./peer.sh channel create -o orderer.example.com:7050 -c mychannel -f ../mychannel.tx --tls true --cafile tlsca.example.com-cert.pem
2019-06-09 22:13:27.075 HKT [channelCmd] InitCmdFactory -> INFO 001 Endorser and orderer connections initialized
2019-06-09 22:13:27.117 HKT [channelCmd] InitCmdFactory -> INFO 002 Endorser and orderer connections initialized
2019-06-09 22:13:27.323 HKT [main] main -> INFO 003 Exiting.....
```

**步骤2.2.** Admin@org2.example.com复制channel.block备用。
```shell
~/fabric-samples/Admin@org1.example.com$ cp mychannel.block ../Admin\@org2.example.com/
```


<br />
<br />




## 3. peer加入channel.block
**步骤3.1.** peer0.org1.example.com:7051加入channel.block。
```shell
~/fabric-samples/Admin@org1.example.com$ ./peer.sh channel join -b mychannel.block
2019-06-09 22:15:51.713 HKT [channelCmd] InitCmdFactory -> INFO 001 Endorser and orderer connections initialized
2019-06-09 22:15:52.153 HKT [channelCmd] executeJoin -> INFO 002 Successfully submitted proposal to join channel
2019-06-09 22:15:52.153 HKT [main] main -> INFO 003 Exiting.....
```


**步骤3.3.** peer0.org2.example.com:7051加入channel.block。

```shell
~/fabric-samples/Admin@org2.example.com$ ./peer.sh channel join -b mychannel.block
2019-06-09 22:17:54.876 HKT [channelCmd] InitCmdFactory -> INFO 001 Endorser and orderer connections initialized
2019-06-09 22:17:55.213 HKT [channelCmd] executeJoin -> INFO 002 Successfully submitted proposal to join channel
2019-06-09 22:17:55.213 HKT [main] main -> INFO 003 Exiting.....
```

查看peer所在的channel.

```shell
~/fabric-samples/Admin@org2.example.com$ ./peer.sh channel list
2019-06-09 22:19:12.472 HKT [channelCmd] InitCmdFactory -> INFO 001 Endorser and orderer connections initialized
Channels peers has joined: 
mychannel
2019-06-09 22:19:12.476 HKT [main] main -> INFO 002 Exiting.....
```

**步骤3.4.** org1.example.com加入锚点。

```shell
~/fabric-samples/Admin@org1.example.com$ ./peer.sh channel update -o orderer.example.com:7050 -c mychannel -f ../Org1MSPanchors.tx --tls true --cafile ./tlsca.example.com-cert.pem
2019-06-09 22:21:25.410 HKT [channelCmd] InitCmdFactory -> INFO 001 Endorser and orderer connections initialized
2019-06-09 22:21:25.429 HKT [channelCmd] update -> INFO 002 Successfully submitted channel update
2019-06-09 22:21:25.429 HKT [main] main -> INFO 003 Exiting.....
```

**步骤3.5.** org2.example.com加入锚点。
```shell
~/fabric-samples/Admin@org2.example.com$ ./peer.sh channel update -o orderer.example.com:7050 -c mychannel -f ../Org2MSPanchors.tx --tls true --cafile ./tlsca.example.com-cert.pem
2019-06-09 22:22:09.384 HKT [channelCmd] InitCmdFactory -> INFO 001 Endorser and orderer connections initialized
2019-06-09 22:22:09.408 HKT [channelCmd] update -> INFO 002 Successfully submitted channel update
2019-06-09 22:22:09.408 HKT [main] main -> INFO 003 Exiting.....
```



