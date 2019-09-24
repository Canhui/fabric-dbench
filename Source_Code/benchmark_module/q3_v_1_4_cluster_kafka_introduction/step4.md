Multiple Zookeepers, Multiple Kafka Brokers

## 0. 删除之前的kafkas/Zookeepers遗存

删除数据库
```shell
rm -rf /tmp/*
```

非主节点删除源文件
```shell
rm -rf /home/t716/joe/kafka_2.12-2.3.0
```


## 1. Zookeepers部署

#### 1.1. 配置myid文件

#### 1.2. 配置zookeeper-1,2,3.properties文件

添加下面三行

```shell
tickTime=2000
initLimit=5
syncLimit=2
```

tickTime表示leader node和worker node之间维持心跳的时间间隔，也就是每隔tickTime时间就会发送一个心跳，以毫秒为单位。

initLimit表示leader node和worker node之间初始链接时候，最多能容忍的心跳数，以tickTime为单位。

syncLimit表示leader node和worker node的请求和回答之间，最多能容忍的心跳数，以tickTime为单位。





下一步：弄明白zookeeper中的上述三个参数。



#### 1.3. 复制zookeeper.properties文件到所有节点

```shell
scp -r kafka_2.12-2.3.0 t716@zookeeper2:/home/t716/joe
scp -r kafka_2.12-2.3.0 t716@zookeeper3:/home/t716/joe
```

#### 1.4. 运行zookeeper.properties文件

192.168.0.101机器上，启动一个kafka自带的zookeeper节点，命令如下，

```shell
$ bin/zookeeper-server-start.sh config/zookeeper-1.properties
```

192.168.0.103机器上，启动一个kafka自带的zookeeper节点，命令如下，

```shell
$ bin/zookeeper-server-start.sh config/zookeeper-2.properties
```

192.168.0.104机器上，启动一个kafka自带的zookeeper节点，命令如下，

```shell
$ bin/zookeeper-server-start.sh config/zookeeper-3.properties
```


#### 1.5. 修改server.properties中的zookeepers的节点






## Reference 
[1. Multi-zookeeper] https://medium.com/@kiranps11/kafka-and-zookeeper-multinode-cluster-setup-3511aef4a505
[2. Zookeepers cluster] https://www.agiratech.com/kafka-zookeeper-multi-node-cluster-setup/

