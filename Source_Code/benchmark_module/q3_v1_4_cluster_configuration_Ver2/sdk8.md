## 1. 部署kafka

ubuntu00机器上，下载v1.1 版本的kafka。其中，kafka的官网下载地址是: 

```shell
wget https://archive.apache.org/dist/kafka/1.1.1/kafka_2.12-1.1.1.tgz
tar -xvf kafka_2.12-1.1.1.tgz
cd kafka_2.12-1.1.1/
```


## 2. 启动kafka自带的zookeeper

启动kafka自带的zookeeper命令如下，

```shell
./bin/zookeeper-server-start.sh config/zookeeper.properties 
```


## 3. 启动kafka

接着，启动kafka。启动kafka之前，需要对kafka的参数做一些修改，方便更好地适配到Hyperledger上，
