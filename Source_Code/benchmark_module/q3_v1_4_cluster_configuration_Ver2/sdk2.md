非Orderer机器上运行nodejs测试项目。



## 1. 环境描述
ubuntu00: orderer & peer0.org1
ubuntu01: peer0.org2

本文要在peer0.org2进行系统的性能测试工作。


<br />
<br />


## 2. ubuntu01的管理员配置


#### 2.1. 配置文件

拷贝fabric-samples到ubuntu01机器

ubuntu00上，
```shell
~/fabric-samples$ scp -r fabric-samples joe@192.168.0.106:/tmp/
```

ubuntu01上，

```shell
$ cp -r /tmp/fabric-samples /home/joe
```


#### 2.2. 验证

ubuntu01上，测试管理员身份能否顺利运行，


查询节点状态
```shell
~/fabric-samples/Admin@org2.example.com$ ./peer.sh node status
```


写入chaincode
```shell
~/fabric-samples/Admin@org2.example.com$ ./peer.sh chaincode invoke -o orderer.example.com:7050  --tls true --cafile ./tlsca.example.com-cert.pem -C mychannel -n demo -c '{"Args":["write","key1","c"]}'
```


查询chaincode
```shell
~/fabric-samples/Admin@org2.example.com$ ./peer.sh chaincode query -C mychannel -n demo -c '{"Args":["query","key1"]}'
```




<br />
<br />

## 3. 配置NodeJs SDK

ubuntu01机器上


#### 3.1. 查询文件query.js

测试查询结果，命令如下，
```shell
~/fabric-samples/nodeTest$ node query.js
```



#### 3.2. 查询文件invoke.js

测试查询结果，命令如下，
```shell
~/fabric-samples/nodeTest$ node invoke.js
```




