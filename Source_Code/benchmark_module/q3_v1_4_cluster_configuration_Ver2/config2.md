## 1. Admin@org1.example.com用户

**步骤1.1.** 创建Admin@org1.example.com文件夹，该文件夹包括超级用户运行时所需的全部文件。

```shell
~/fabric-samples$ mkdir Admin@org1.example.com
```


**步骤1.2.** 复制证书。
```shell
~/fabric-samples$ cp -rf certs/peerOrganizations/org1.example.com/users/Admin\@org1.example.com/* Admin\@org1.example.com/
```


**步骤1.3.** 复制core.yaml文件。
```shell
~/fabric-samples$ cp peer0.org1.example.com/core.yaml  Admin\@org1.example.com/
```



**步骤1.4.** 为了方便，创建peer.sh文件，该文件包含Admin@org1.example.com用户的启动参数。
```shell
~/fabric-samples$ cd Admin@org1.example.com
~/fabric-samples/Admin@org1.example.com$ touch peer.sh
```

并往peer.sh文件中写入如下内容。

```shell
#!/bin/bash
PATH=`pwd`/../bin:$PATH

export FABRIC_CFG_PATH=`pwd`

export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_TLS_CERT_FILE=./tls/client.crt
export CORE_PEER_TLS_KEY_FILE=./tls/client.key

export CORE_PEER_MSPCONFIGPATH=./msp
export CORE_PEER_ADDRESS=peer0.org1.example.com:7051
export CORE_PEER_LOCALMSPID=Org1MSP
export CORE_PEER_TLS_ROOTCERT_FILE=./tls/ca.crt
export CORE_PEER_ID=cli
export CORE_LOGGING_LEVEL=INFO

peer $*
```


**步骤1.4.** 测试该peer.sh脚本。
```shell
~/fabric-samples/Admin@org1.example.com$ sudo chmod +x peer.sh
~/fabric-samples/Admin@org1.example.com$ ./peer.sh node status
status:STARTED 
2019-06-09 21:11:57.040 HKT [main] main -> INFO 001 Exiting.....
```

<br />
<br />

## 3. Admin@org2.example.com用户

**步骤3.1.** 复制和替换Admin@org1.example.com用户的msp和tls。
```shell
~/fabric-samples$ cp -rf  Admin\@org1.example.com/ Admin\@org2.example.com/
~/fabric-samples$ rm -rf  Admin\@org2.example.com/msp/
~/fabric-samples$ rm -rf  Admin\@org2.example.com/tls/
~/fabric-samples$ cp -rf certs/peerOrganizations/org2.example.com/users/Admin\@org2.example.com/* Admin\@org2.example.com/
```

**步骤3.2.** 复制core.yaml。
```shell
~/fabric-samples$ cp peer0.org2.example.com/core.yaml Admin\@org2.example.com/
```

**步骤3.3.** 替换peer.sh脚本。
将peer.sh中两处Org1MSP修改为Org2MSP。

**步骤3.4.** 测试该peer.sh脚本。
```shell
~/fabric-samples/Admin@org2.example.com$ ./peer.sh node status
status:STARTED 
2019-06-09 21:28:21.424 HKT [main] main -> INFO 001 Exiting.....
```

