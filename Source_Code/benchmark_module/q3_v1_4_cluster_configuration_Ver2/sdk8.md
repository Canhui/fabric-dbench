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

接着，启动kafka。启动kafka之前，需要对kafka的参数做一些修改，方便更好地适配到Hyperledger上，（kafka的一些配置文件，方便hyperledger使用），

"server.properties"文件配置好之后，如下，
```shell
####################### kafka configuration for Hyperledger ########################
unclean.leader.election.enable = false
min.insync.replicas = 1
default.replication.factor = 1
message.max.bytes = 10000120
replica.fetch.max.bytes = 10485760
log.retention.ms = -1
```

另外注意: 可能需要把Advertisement.Addr修改成为可以被解析的DNS name或者IP地址。

修改zookeeper.connect的地址。




启动kafka命令如下，

```shell
./bin/kafka-server-start.sh config/server.properties
```


测试kafka命令之创建topic如下，

```shell
bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic test
```

创建成功之后显示如下，

```shell
Created topic "test".
```

测试kafka命令之查看topic如下，

```shell
bin/kafka-topics.sh --list --zookeeper localhost:2181
```

测试kafka命令之启动生产者，并输入任意字符

```shell
bin/kafka-console-producer.sh --broker-list localhost:9092 --topic test
```

测试kafka命令之启动消费者，接收到生产者的输入 (这个需要重新开启一个窗口)

```shell
bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic test --from-beginning
```



K