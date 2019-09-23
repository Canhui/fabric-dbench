One Zookeeper, Multi Kafka Brokers

So far, we have been running against a single broker, but that is no fun. For kafka, a single broker is just a cluster of size one, so nothing much changes other than starting a few more broker instances. But just to get feel for it, let expand our cluster to three nodes.


## 0. 删除之前的kafka遗存

删除数据库
```shell
rm -rf /tmp/*
```

删除源文件
```shell
rm -rf /home/t716/joe/kafka_2.12-2.3.0
```




## 1. 部署Kafka

#### 1.1. 下载Kafka数据包

192.168.0.101机器上，下载v2.1版本的kafka，其中kafka的官方下载地址如下，

```shell
$ wget https://archive.apache.org/dist/kafka/2.1.0/kafka_2.12-2.1.0.tgz
$ tar -xvf kafka_2.12-2.1.0.tgz
$ cd kafka_2.12-2.1.0
```


#### 1.2. 配置kafka server (or kafka broker)

我们在"server.properties"文件末尾添加如下配置信息，

```shell
########### kafka configuration for Hyperledger ###############
unclean.leader.election.enable = false
min.insync.replicas = 1
default.replication.factor = 1
message.max.bytes = 10000120
replica.fetch.max.bytes = 10485760
log.retention.ms = -1
```

然后，修改broker.id，如下，
```shell
broker.id=1
```

修改broker的listeners，如下，
```shell
listeners=PLAINTEXT://broker1:9092
```

修改zookeeper.connect，如下，
```shell
zookeeper.connect=zookeeper1:2181
```

修改kafka-logs，如下，
```shell
log.dirs=/tmp/kafka-logs-1
```


复制kafka broker的配置文件到其他所有机器，如下，
```shell
scp -r kafka_2.12-2.3.0 t716@broker2:/home/t716/joe
scp -r kafka_2.12-2.3.0 t716@broker3:/home/t716/joe
```


#### 1.3. 启动一个kafka自带的zookeeper节点

192.168.0.101机器上，启动一个kafka自带的zookeeper节点，命令如下，

```shell
$ bin/zookeeper-server-start.sh config/zookeeper.properties
```


#### 1.4. 通过各自的配置文件，启动kafka server (or kafka broker)

peer0.org1.example.com的机器，

```shell
$ bin/kafka-server-start.sh config/server-1.properties
```

broker2的机器，
```shell
$ bin/kafka-server-start.sh config/server-2.properties
```

broker3的机器，
```shell
$ bin/kafka-server-start.sh config/server-3.properties
```


## 1.4. 测试

kafka server (or kafka broker)创建一个名为topic1的topic
```shell
bin/kafka-topics.sh --create --bootstrap-server broker1:9092 --replication-factor 1 --partitions 1 --topic topic
```

查看topic描述
```shell
bin/kafka-topics.sh --list --bootstrap-server broker1:9092
```

启动生产者
```shell
$ bin/kafka-console-producer.sh --broker-list broker1:9092 --topic topic
```

启动消费者
```shell
$ bin/kafka-console-consumer.sh --bootstrap-server broker1:9092 --topic topic --from-beginning
```

多个节点共享同一个Topic。


## Reference
[1. Multi Kafka Brokers] https://kafka.apache.org/quickstart
