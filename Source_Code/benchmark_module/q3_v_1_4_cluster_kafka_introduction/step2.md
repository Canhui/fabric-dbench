One Zookeeper, One Kafka Broker


## 1. 部署Kafka

#### 1.1. 下载Kafka数据包

192.168.0.101机器上，下载v2.1版本的kafka，其中kafka的官方下载地址如下，

```shell
$ wget https://archive.apache.org/dist/kafka/2.1.0/kafka_2.12-2.1.0.tgz
$ tar -xvf kafka_2.12-2.1.0.tgz
$ cd kafka_2.12-2.1.0
```


#### 1.2. 启动一个kafka自带的zookeeper节点

192.168.0.101机器上，启动一个kafka自带的zookeeper节点，命令如下，

```shell
$ ./bin/zookeeper-server-start.sh config/zookeeper.properties
```


#### 1.3. 启动kafka server (or kafka broker)

接着，启动kafka server (or kafka broker)。注意：启动kafka之前，需要对kafka的参数做一些修改，方便更好地适配到Hyperledger集群上，因此，我们在"server.properties"文件末尾添加如下配置信息，

```shell
########### kafka configuration for Hyperledger ###############
unclean.leader.election.enable = false
min.insync.replicas = 1
default.replication.factor = 1
message.max.bytes = 10000120
replica.fetch.max.bytes = 10485760
log.retention.ms = -1
```

另外，还需要把Advertisement.Addr修改成可以被解析的DNS Address或者IP Address。同时，修改zookeeper.connect的地址。

然后，启动kafka server (or kafka broker)的命令如下，

```shell
$ ./bin/kafka-server-start.sh config/server.properties
```


#### 1.4. 测试

**测试一:**

测试kafka，下面是创建kafka之topic命令，如下，

```shell
$ bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic topic1
```

topic创建成功之后，显示如下，

```shell
Created topic "topic1".
```


**测试二:**

测试kafka，下面是查询kafka之topic命令，如下，

```shell
$ bin/kafka-topics.sh --list --zookeeper localhost:2181
```

topic查询成功之后，显示如下，

```shell
__consumer_offsets
test
topic1
```


**测试三:**

测试kafka，下面是创建kafka生产者，消费者的命令，如下，

```shell

```









## Reference
[1. One Zookeeper, One Kafka Broker] https://blog.csdn.net/Canhui_WANG/article/details/100676500