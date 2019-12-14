**Fabric-DBench** is a distributed benchmark platform for Hyperledger Fabric.


## 0. Releases
+ [release-v1.4.0-solo (single orderer)](https://github.com/Canhui/fabric-dbench/tree/release-v1.4.0-solo)
+ [release-v1.4.0-kafka (multiple orderers)](https://github.com/Canhui/fabric-dbench/tree/release-v1.4.0-kafka)
+ [release-v1.4.1-solo (single orderer)](https://github.com/Canhui/fabric-dbench/tree/release-v1.4.1-solo)
+ [release-v1.4.1-kafka (multiple orderers)](https://github.com/Canhui/fabric-dbench/tree/release-v1.4.1-kafka)
+ [release-v1.4.3-solo (single orderer)](https://github.com/Canhui/fabric-dbench/tree/release-v1.4.3-solo)
+ [release-v1.4.3-kafka (multiple orderers)](https://github.com/Canhui/fabric-dbench/tree/release-v1.4.3-kafka)
+ [release-v1.4.3-raft (multiple orderers)](https://github.com/Canhui/fabric-dbench/tree/release-v1.4.3-raft)



## 1. Prerequirements

#### 1.1. Hyperledger Fabric v1.4.3

Install the Hyperledger Fabric v1.4.3 according to the [Hyperledger Fabric official website](https://github.com/hyperledger/fabric) and ensure running `fabric-samples/first-network` successfully.






#### 1.2. The Hosts File

Each node of the cluster has a host file under the `/etc/hosts` directory.

```shell
# ---------------------------------------------------------------------------
# Hyperledger Cluster Configuration - Pls contact chwang@comp.hkbu.edu.hk Thx.
# ---------------------------------------------------------------------------
192.168.0.101 orderer1.example.com
192.168.0.103 orderer3.example.com
192.168.0.104 orderer4.example.com
192.168.0.101 peer0.org1.example.com
192.168.0.103 peer0.org2.example.com
192.168.0.104 peer0.org3.example.com
192.168.0.106 peer0.org4.example.com
192.168.0.107 peer0.org5.example.com
192.168.0.109 peer0.org6.example.com
192.168.0.111 peer0.org7.example.com
192.168.0.112 peer0.org8.example.com
192.168.0.113 peer0.org9.example.com
192.168.0.114 peer0.org10.example.com
192.168.0.116 peer0.org11.example.com
192.168.0.119 peer0.org12.example.com

# ---------------------------------------------------------------------------
# Zookeeper PBFT Cluster Configuration - Pls contact chwang@comp.hkbu.edu.hk Thx.
# ---------------------------------------------------------------------------
192.168.0.101 zookeeper1
192.168.0.103 zookeeper2
192.168.0.104 zookeeper3
192.168.0.106 zookeeper4
192.168.0.107 zookeeper5
192.168.0.109 zookeeper6
192.168.0.111 zookeeper7
192.168.0.112 zookeeper8
192.168.0.113 zookeeper9
192.168.0.114 zookeeper10
192.168.0.116 zookeeper11
192.168.0.119 zookeeper12

# ---------------------------------------------------------------------------
# Kafka Message Cluster Configuration - Pls contact chwang@comp.hkbu.edu.hk Thx.
# ---------------------------------------------------------------------------
192.168.0.101 broker1
192.168.0.103 broker2
192.168.0.104 broker3
192.168.0.106 broker4
192.168.0.107 broker5
192.168.0.109 broker6
192.168.0.111 broker7
192.168.0.112 broker8
192.168.0.113 broker9
192.168.0.114 broker10
192.168.0.116 broker11
192.168.0.119 broker12
```

In particular, `192.168.0.101`is the Ansible cluster manager. We configure the `/etc/ansible/hosts` file at the `192.168.0.101` node.

```shell
[orderer]
192.168.0.101

[peer]
192.168.0.102
192.168.0.103
192.168.0.106
192.168.0.107
192.168.0.109
192.168.0.111
192.168.0.112
```








## 2. Setup

#### 2.1. Download fabric-dbench from Github

Download the source code to your `$HOME` directory

```shell
$ cd $HOME
$ git clone https://github.com/Canhui/fabric-dbench.git --branch release-v1.4.3-kafka
```




#### 2.2. Add an execution authority to .sh files


```shell
$ cd $HOME/fabric-dbench/fabric-samples
$ sudo chmod +x *.sh
$ cd $HOME/fabric-dbench/fabric-samples/run
$ sudo chmod +x *.sh
$ cd $HOME/fabric-dbench/fabric-samples/bin
$ sudo chmod +x *
$ cd $HOME/fabric-dbench/kafka_2.12-2.3.0/bin
$ sudo chmod +x *.sh
```



#### 2.3. Prepare the Zookeeper Cluster

Go to `$HOME/fabric-dbench/fabric-samples` and run the `run0_config_zkkafka.sh` to configure the kafka/zookeeper cluster.

```shell
$ cd $HOME/fabric-dbench/fabric-samples
$ ./run0_config_zkkafka.sh
```




Go to `zookeeper1` node. Go to `$HOME/fabric-dbench/kafka_2.12-2.3.0` directory. Setup the zookeeper.

```shell
$ cd $HOME/fabric-dbench/kafka_2.12-2.3.0

# default (recommended): run in backend
$ ./bin/zookeeper-server-start.sh config/zookeeper-1.properties &>>log_zk1 &

# options (not recommended, but useful for debugging): run in frontend
$ ./bin/zookeeper-server-start.sh config/zookeeper-1.properties
```






Go to `zookeeper2` node. Go to `$HOME/fabric-dbench/kafka_2.12-2.3.0` directory. Setup the zookeeper.

```shell
$ cd $HOME/fabric-dbench/kafka_2.12-2.3.0

# default (recommended): run in backend
$ ./bin/zookeeper-server-start.sh config/zookeeper-2.properties &>>log_zk2 &

# options (not recommended, but useful for debugging): run in frontend
$ ./bin/zookeeper-server-start.sh config/zookeeper-2.properties
```








Go to `zookeeper3` node. Go to `$HOME/fabric-dbench/kafka_2.12-2.3.0` directory. Setup the zookeeper.

```shell
$ cd $HOME/fabric-dbench/kafka_2.12-2.3.0

# default (recommended): run in backend
$ ./bin/zookeeper-server-start.sh config/zookeeper-3.properties &>>log_zk3 &

# options (not recommended, but useful for debugging): run in frontend
$ ./bin/zookeeper-server-start.sh config/zookeeper-3.properties
```



**Note:** Modify `ZKS` of files `run/step0_2.sh` to add more nodes, where `ZKS` should be smaller than `KAFKAS`.





#### 2.4. Prepare the Kafka Cluster


Go to `zookeeper1` node. Go to `$HOME/fabric-dbench/kafka_2.12-2.3.0` directory. Setup the kafka server (i.e., broker).

```shell
$ cd $HOME/fabric-dbench/kafka_2.12-2.3.0

# default (recommended): run in backend
$ ./bin/kafka-server-start.sh config/server-1.properties &>>log_kafka1 &

# options (not recommended, but useful for debugging): run in frontend
$ ./bin/kafka-server-start.sh config/server-1.properties
```




Go to `zookeeper2` node. Go to `$HOME/fabric-dbench/kafka_2.12-2.3.0` directory. Setup the kafka server (i.e., broker).

```shell
$ cd $HOME/fabric-dbench/kafka_2.12-2.3.0

# default (recommended): run in backend
$ ./bin/kafka-server-start.sh config/server-2.properties &>>log_kafka2 &

# options (not recommended, but useful for debugging): run in frontend
$ ./bin/kafka-server-start.sh config/server-2.properties
```





Go to `zookeeper3` node. Go to `$HOME/fabric-dbench/kafka_2.12-2.3.0` directory. Setup the kafka server (i.e., broker).

```shell
$ cd $HOME/fabric-dbench/kafka_2.12-2.3.0

# default (recommended): run in backend
$ ./bin/kafka-server-start.sh config/server-3.properties &>>log_kafka3 &

# options (not recommended, but useful for debugging): run in frontend
$ ./bin/kafka-server-start.sh config/server-3.properties
```




#### 2.5. Kafka creates topics



One zookeeper node creates a topic. Go to `zookeeper1` node. Go to `$HOME/fabric-dbench/kafka_2.12-2.3.0` directory. Create a new topic which should has the same name with fabric channel that you are going to make use of.

```shell
$ cd $HOME/fabric-dbench/kafka_2.12-2.3.0
$ ./bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic mychannel
```


The rest of zookeepers make use of the topic. List tpics

```shell
$ cd $HOME/fabric-dbench/kafka_2.12-2.3.0
$ ./bin/kafka-topics.sh --list --zookeeper localhost:2181
```



**Note:** Modify `KAFKAS` of files `run/step0_1.sh` and `run/step0_2.sh` to add more nodes, where `ZKS` should be smaller than `KAFKAS`.




## 3. Usage of `run1_config_network.sh`


#### 3.1. Config the Network (e.g., of 3 organizations)

Go to `$HOME/fabric-dbench/fabric-samples` and run the `run1_config_network.sh` to configure the network.

```shell
$ cd $HOME/fabric-dbench/fabric-samples 
$ ./run1_config_network.sh
```



Go to `peer0.org1.example.com` node. Go to `$HOME/fabric-dbench/fabric-run/orderer` directory. Setup the orderer. 

```shell
$ cd $HOME/fabric-dbench/fabric-run/orderer

# default (recommended): run in backend
$ sudo ./orderer &>>log &

# options (not recommended, but useful for debugging): run in frontend
$ ./run1_config_network.sh
```




Go to `peer0.org2.example.com` node. Go to `$HOME/fabric-dbench/fabric-run/orderer` directory. Setup the orderer. 

```shell
$ cd $HOME/fabric-dbench/fabric-run/orderer

# default (recommended): run in backend
$ sudo ./orderer &>>log &

# options (not recommended, but useful for debugging): run in frontend
$ ./run1_config_network.sh
```



Go to `peer0.org3.example.com` node. Go to `$HOME/fabric-dbench/fabric-run/orderer` directory. Setup the orderer. 

```shell
$ cd $HOME/fabric-dbench/fabric-run/orderer

# default (recommended): run in backend
$ sudo ./orderer &>>log &

# options (not recommended, but useful for debugging): run in frontend
$ ./run1_config_network.sh
```





Go to `peer0.org1.example.com` node. Go to `$HOME/fabric-dbench/fabric-run/peer` directory. Setup the peer. 

```shell
$ cd $HOME/fabric-dbench/fabric-run/peer

# default (recommended): run in backend
$ sudo ./peer node start &>>log &

# options (not recommended, but useful for debugging): run in frontend
$ sudo ./peer node start
```



Go to `peer0.org2.example.com` node. Go to `$HOME/fabric-dbench/fabric-run/peer` directory. Setup the peer. 

```shell
$ cd $HOME/fabric-dbench/fabric-run/peer

# default (recommended): run in backend
$ sudo ./peer node start &>>log &

# options (not recommended, but useful for debugging): run in frontend
$ sudo ./peer node start
```


Go to `peer0.org3.example.com` node. Go to `$HOME/fabric-dbench/fabric-run/peer` directory. Setup the peer. 

```shell
$ cd $HOME/fabric-dbench/fabric-run/peer

# default (recommended): run in backend
$ sudo ./peer node start &>>log &

# options (not recommended, but useful for debugging): run in frontend
$ sudo ./peer node start
```


**Note:** Modify `ORDERERS` of files `run/step1_4.sh`, `run/step1_6.sh`, `run/step1_8.sh` to add more peers.

**Note:** Modify `ORGS` of files `run/step1_5.sh`, `run/step1_7.sh` to add more peers.








## 4. Usage of `step2_config_admins.sh`

#### 4.1. Config the Adminstrators (e.g., of 3 organizations)

Go to `$HOME/fabric-dbench/fabric-samples` and run the `run2_config_admins.sh` to configure the administrators.

```shell
$ cd $HOME/fabric-dbench/fabric-samples
$ ./run2_config_admins.sh
```




Go to `$HOME/fabric-dbench/fabric-samples/Admin@org1.example.com` directory and check the adminstrator of the first organization.

```shell
$ cd $HOME/fabric-dbench/fabric-samples/Admin@org1.example.com
$ ./peer.sh node status
```



Go to `$HOME/fabric-dbench/fabric-samples/Admin@org2.example.com` directory and check the adminstrator of the second organization
```shell
$ cd $HOME/fabric-dbench/fabric-samples/Admin@org2.example.com
$ ./peer.sh node status
```




Go to `$HOME/fabric-dbench/fabric-samples/Admin@org3.example.com` directory and check the adminstrator of the second organization
```shell
$ cd $HOME/fabric-dbench/fabric-samples/Admin@org3.example.com
$ ./peer.sh node status
```

**Note:** Modify `ORGS` of file `run/step2_1.sh` to add more peers.








## 5. Usage of `run3_config_channel.sh`

#### 5.1. Config the Channels (e.g., of 3 organizations)


Go to `$HOME/fabric-dbench/fabric-samples` and run the `run3_config_channel.sh` to setup a new channel named "mychannel2".

```shell
$ cd $HOME/fabric-dbench/fabric-samples
$ ./run3_config_channel.sh
```


**Note1:** Modify `ORGS` of file `run/step3_1.sh` to add more peers.<br/>
**Note2:** Modify `channel_name` of file `run/step3_1.sh` to create another new channel.





## 6. Usage of `run4_config_chaincode.sh`

#### 6.1. Config the Chaincodes (e.g., of 3 organizations)

Go to `$HOME/fabric-dbench/fabric-samples` and run the `run4_config_chaincode.sh` to create a new chaincode under the channel we created previously.


```shell
$ cd $HOME/fabric-dbench/fabric-samples
$ ./run4_config_chaincode.sh
```


**Note1:** Modify `ORGS` of the file `run/step4_1.sh` to add more peers.<br/>
**Note2:** Modify `chaincode_name` of the file `run/step4_1.sh` to create another new chaincode.<br/>
**Note3:** Modify `endorsement_policy` of the file `run/step4_1.sh` to create another new endorsement policy.<br/>
**Note4:** Modify `channel_name` of the file `run/step4_1.sh` to use the channel we created previously.






## 7. Usage of `run5_config_and_sdk.sh`

#### 7.1. Config the SDK for "AND" Endorsement Policy (e.g., of 3 organizations)

Go to `$HOME/fabric-dbench/fabric-samples` and run the `run5_config_and_sdk.sh` to configure a sdk for each peer using the "OR" endorsement policy.



```shell
$ cd $HOME/fabric-dbench/fabric-samples
$ ./run5_config_and_sdk.sh
```

Go to `peer0.org1.example.com` node. Go to `$HOME/fabric-dbench/fabric-samples/sdk.org1.example.com` directory. Invoke a new transaction. 



```shell
$ cd $HOME/fabric-dbench/fabric-samples/sdk.org1.example.com
$ node invoke_and_all_orgs.js
```

Query a transaction. 
```shell
$ cd $HOME/fabric-dbench/fabric-samples/sdk.org1.example.com
$ node query.js
```




Go to `peer0.org2.example.com` node. Go to `$HOME/fabric-dbench/fabric-samples/sdk.org2.example.com` directory. Invoke a new transaction. 

```shell
$ cd $HOME/fabric-dbench/fabric-samples/sdk.org2.example.com
$ node invoke_and_all_orgs.js
```

Query a transaction. 
```shell
$ cd $HOME/fabric-dbench/fabric-samples/sdk.org2.example.com
$ node query.js
```


Go to `peer0.org3.example.com` node. Go to `$HOME/fabric-dbench/fabric-samples/sdk.org3.example.com` directory. Invoke a new transaction. 

```shell
$ cd $HOME/fabric-dbench/fabric-samples/sdk.org3.example.com
$ node invoke_and_all_orgs.js
```

Query a transaction. 
```shell
$ cd $HOME/fabric-dbench/fabric-samples/sdk.org3.example.com
$ node query.js
```









**Note1:** Modify `ORGS` of the file `run/step5_1.sh` to add more peers. <br/>
**Note2:** Modify `chaincode_name` of the file `run/step5_1.sh` to make use of the chaincode we created previously.<br/>
**Note3:** Modify `channel_name` of the file `run/step4_1.sh` to make use of the channel we created previously.<br/>
**Note4:** Modify `endorsement_policy` of the file `run/step4_1.sh` to make use of the endorsement policy we created previously.





## 8. Usage of `run6_config_bench.sh`

Go to `$HOME/fabric-dbench/fabric-samples` and run the `run6_config_bench.sh` to configure a Java multi-thread benchmark tool for each peer.

```shell
$ cd $HOME/fabric-dbench/fabric-samples
$ ./run6_config_bench.sh
```

Go to all workload generators, compile the java code.

```shell
$ cd $HOME/fabric-dbench/workload-generator/src
$ javac run_bench.java
```

Run up all workload generators at the same time.

```shell
$ java run_bench
```



