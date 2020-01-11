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


**Note:** Modify `ORDERERS` of files `run/step1_4.sh`, `run/step1_6.sh`, `run/step1_8.sh` to add more orderers.

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





## 9. Experiment Results

#### 9.1. Throughput and Latency of 1-Byte Transactions with Endorsing Policy "OR-10" 

All traffics go to only one orderer node, see "step5_4.sh"





#### 9.2. Throughput and Latency of 1-Byte Transactions with Endorsing Policy "OR-10" 

All traffics go to all orderer nodes in balance, see "step5_6.sh"

3 zookeeper nodes

3 kafka nodes

3 orderers

20 peers


| TAR | Sendto Endorsing (tps) | Sendto Ordering (tps) | Verification (tps) | Commit (tps) | Endorsing [Low,Up,Mean,Std] | Ordering [Low,Up,Mean,Std] | Verification [Low,Up,Mean,Std] | Commit [Low,Up,Mean,Std] |
|-----|------------------------|-----------------------|--------------------|--------------|-----------------------------|----------------------------|--------------------------------|--------------------------|
| 50  | 50                     | 50                    | 47.46              | 47.46        | [229,265,245,14.28]         | [194,857,526,139.37]       | [4,28,13,7.18]                 | [282,329,292,15.51]      |
|     | 50                     | 50                    | 47.03              | 47.03        | [227,274,247,12.58]         | [203,1576,575,343.34]      | [7,18,11,3.14]                 | [276,338,291,17.62]      |
|     | 50                     | 50                    | 48.75              | 48.75        | [228,259,243,9.62]          | [93,1259,396,328.23]       | [10,16,11,2.00]                | [276,338,293,17.90]      |
|     | 50                     | 50                    | 50                 | 50           | [228,280,239,15.96]         | [320,857,540,149.49]       | [9,21,12,3.50]                 | [279,320,290,13.30]      |
|     | 50                     | 50                    | 46.75              | 46.75        | [229,269,246,14.54]         | [151,1518,592,361.50]      | [9,20,13,3.50]                 | [257,295,283,10.36]      |
| 100 | 100                    | 100                   | 99.26              | 99.26        | [181,345,274,27.38]         | [3,879,560,209.72]         | [13,28,21,4.18]                | [272,305,289,11.79]      |
|     | 100                    | 100                   | 98.41              | 98.41        | [227,379,286,39.34]         | [459,970,644,123.65]       | [15,23,18,2.37]                | [283,497,311,65.88]      |
|     | 100                    | 100                   | 98.87              | 98.87        | [37,373,264,63.07]          | [3,826,565,150.41]         | [18,27,20,3.30]                | [272,300,289,8.68]       |
|     | 100                    | 100                   | 99.81              | 99.81        | [219,369,266,34.51]         | [419,894,602,106.95]       | [17,25,20,2.96]                | [280,415,306,39.70]      |
|     | 100                    | 100                   | 99.11              | 99.11        | [217,384,282,47.46]         | [399,953,602,132.29]       | [17,25,20,2.18]                | [277,337,296,21.33]      |
| 150 | 150                    | 150                   | 149.55             | 149.55       | [217,347,273,37.05]         | [50,1000,558,196.81]       | [14,37,21,6.23]                | [285,379,313,32.93]      |
|     | 150                    | 150                   | 148.65             | 148.65       | [225,318,278,28.26]         | [49,929,555,165.98]        | [14,21,17,2.79]                | [282,379,325,40.24]      |
|     | 150                    | 150                   | 148.52             | 148.52       | [226,335,271,34.91]         | [48,940,569,175.32]        | [16,31,22,4.11]                | [284,441,332,51.36]      |
|     | 150                    | 150                   | 149.25             | 149.25       | [216,341,272,31.89]         | [47,921,571,162.67]        | [17,41,24,6.65]                | [283,386,315,40.88]      |
|     | 150                    | 150                   | 138.82             | 138.82       | [230,321,270,26.67]         | [5,917,530,185.35]         | [1,25,16,6.62]                 | [284,388,321,40.05]      |
| 200 | 200                    | 200                   | 197.83             | 197.83       | [23,417,273,69.38]          | [3,904,587,207.53]         | [15,24,19,2.82]                | [283,402,328,44.11]      |
|     | 200                    | 200                   | 199.05             | 199.05       | [130,381,283,35.67]         | [3,917,585,183.51]         | [18,25,20,2.42]                | [283,539,347,80.36]      |
|     | 200                    | 200                   | 200                | 200          | [214,383,278,35.90]         | [3,937,565,211.10]         | [15,31,20,5.75]                | [272,624,355,111.11]     |
|     | 200                    | 200                   | 197.95             | 197.95       | [83,426,271,53.85]          | [3,937,596,166.76]         | [13,26,18,3.68]                | [270,404,321,43.55]      |
|     | 200                    | 200                   | 200                | 200          | [182,388,274,39.35]         | [3,943,639,160.30]         | [14,27,19,4.37]                | [282,397,329,43.30]      |
| 250 | 250                    | 250                   | 244.24             | 244.24       | [217,392,289,48.82]         | [3,1143,524,279.95]        | [13,28,19,4.13]                | [284,429,330,59.75]      |
|     | 250                    | 250                   | 239.32             | 239.32       | [85,401,314,49.48]          | [2,971,508,289.42]         | [17,31,20,3.86]                | [277,637,347,112.96]     |
|     | 250                    | 250                   | 246.65             | 246.65       | [81,389,295,53.87]          | [3,959,462,259.44]         | [15,28,19,4.03]                | [281,452,335,69.73]      |
|     | 250                    | 250                   | 237.74             | 237.74       | [217,378,293,45.27]         | [3,1145,445,273.49]        | [14,24,21,2.83]                | [283,622,392,111.18]     |
|     | 250                    | 250                   | 237.74             | 237.74       | [102,365,272,49.05]         | [3,1081,589,268.55]        | [17,29,21,3.47]                | [284,496,348,73.46]      |
| 300 | 300                    | 300                   | 258.42             | 258.42       | [13,452,287,70.92]          | [3,1480,482,310.04]        | [17,27,21,3.22]                | [286,454,324,57.90]      |
|     | 300                    | 300                   | 255.61             | 255.61       | [50,448,280,72.59]          | [3,1429,440,321.53]        | [11,26,19,4.02]                | [274,446,322,63.02]      |
|     | 300                    | 300                   | 247.33             | 247.33       | [51,588,322,106.37]         | [3,2008,435,362.95]        | [15,23,19,2.33]                | [284,430,320,46.32]      |
|     | 300                    | 300                   | 255.01             | 255.01       | [85,486,281,65.55]          | [3,1325,446,320.59]        | [18,23,20,1.68]                | [276,468,320,59.31]      |
|     | 300                    | 300                   | 253.05             | 253.05       | [133,382,288,53.08]         | [4,1018,480,286.13]        | [15,29,20,3.59]                | [286,501,331,81.84]      |
| 350 | 350                    | 350                   | 250                | 250          | [134,513,320,83.97]         | [36,3000,508,453.59]       | [20,23,21,1.05]                | [276,301,287,7.70]       |
|     | 350                    | 348                   | 251.60             | 251.60       | [129,769,348,127.66]        | [3,3000,512,511.08]        | [18,27,21,2.99]                | [274,502,346,96.26]      |
|     | 350                    | 343.17                | 251.92             | 251.92       | [94,842,340,145.88]         | [3,2444,447,430.50]        | [16,24,20,2.46]                | [284,331,296,13.18]      |
|     | 348                    | 343.84                | 247.32             | 247.32       | [70,661,327,111.277]        | [3,2779,558,475.37]        | [18,24,21,1.77]                | [294,334,309,11.48]      |
|     | 347                    | 345                   | 248.95             | 248.95       | [60,549,319,83.45]          | [3,2800,520,509.39]        | [18,21,19,0.91]                | [301,329,309,8.60]       |





Performance Bottleneck Analysis

| Performance Metrics                             | Details                                                                            |
|-------------------------------------------------|------------------------------------------------------------------------------------|
| Average Number of Transactions per Block        | 100                                                                                |
| Average Transaction Size                        | 296.907KB/100                                                                      |
| Average Block Size                              | 293.907KB                                                                          |
| Bottleneck Details of Policy Evaluation in OSNs | https://drive.google.com/file/d/1eopfWjcqzSkRUO2Opx9oczYj2JQzt49c/view?usp=sharing |





#### 9.3. Throughput and Latency of 1-Byte Transactions with Endorsing Policy "AND-5" 

All traffics go to one orderer node, see "step5_7.sh"

3 orderers

20 peers

#### 9.4. Throughput and Latency of 1-Byte Transactions with Endorsing Policy "AND-5" 

All traffics go to all orderer nodes in balance, see "step5_9.sh"

3 orderers

20 peers

| TAR | Sendto Endorsing (tps) | Sendto Ordering (tps) | Verification (tps) | Commit (tps) | Endorsing [Low,Up,Mean,Std] | Ordering [Low,Up,Mean,Std] | Verification [Low,Up,Mean,Std] | Commit [Low,Up,Mean,Std] |
|-----|------------------------|-----------------------|--------------------|--------------|-----------------------------|----------------------------|--------------------------------|--------------------------|
| 50  | 50                     | 50                    | 48.77              | 48.77        | [286,343,313,16.99]         | [105,1324,412,356.12]      | [16,35,25,4.62]                | [248,283,263,11.47]      |
|     | 50                     | 50                    | 47.79              | 47.79        | [276,312,291,14.39]         | [283,841,490,120.00]       | [9,31,23,7.74]                 | [251,289,262,12.51]      |
|     | 50                     | 50                    | 48.10              | 48.10        | [276,338,291,19.47]         | [186,1563,615,331.98]      | [10,42,23,9.73]                | [247,262,255,5.47]       |
|     | 50                     | 50                    | 49.45              | 49.45        | [279,328,295,13.71]         | [171,1309,552,341.00]      | [11,38,24,7.70]                | [247,280,259,9.31]       |
|     | 50                     | 50                    | 47.58              | 47.58        | [285,332,313,17.23]         | [195,1494,526,343.27]      | [9,33,23,7.25]                 | [247,453,275,62.73]      |
| 100 | 100                    | 100                   | 95.13              | 95.13        | [96,457,320,96.97]          | [2,871,522,250.29]         | [10,40,26,12.68]               | [267,501,328,79.34]      |
|     | 100                    | 100                   | 93.49              | 93.49        | [86,411,320,74.25]          | [18,1519,635,267.38]       | [10,42,28,10.47]               | [267,352,298,34.30]      |
|     | 100                    | 100                   | 96.08              | 96.08        | [110,409,314,76.55]         | [3,1205,598,255.71]        | [2,44,25,15.45]                | [265,375,300,40.56]      |
|     | 100                    | 100                   | 93.08              | 93.08        | [281,460,353,51.31]         | [287,915,580,166.41]       | [7,41,22,13.31]                | [254,325,283,23.52]      |
|     | 100                    | 100                   | 96.22              | 96.22        | [277,414,342,46.18]         | [82,1156,596,208.52]       | [12,40,25,10.13]               | [249,426,279,52.20]      |
| 150 | 150                    | 150                   | 140.43             | 140.43       | [87,480,352,73.84]          | [3,12.67,490,307.22]       | [17,40,28,8.14]                | [257,403,307,47.42]      |
|     | 150                    | 150                   | 139.51             | 139.51       | [172,503,380,74.36]         | [4,1355,450,269.17]        | [5,39,28,11.00]                | [250,402,294,56.96]      |
|     | 150                    | 150                   | 145.32             | 145.32       | [149,516,369,75.52]         | [3,884,389,256.09]         | [4,48,31,14.33]                | [258,504,323,83.23]      |
|     | 150                    | 150                   | 140.47             | 140.47       | [164,515,368,66.93]         | [3,1618,474,329.12]        | [6,46,34,11.42]                | [249,414,287,50.50]      |
|     | 150                    | 150                   | 139.92             | 139.92       | [171,464,357,55.75]         | [3,1498,511,287.97]        | [25,39,33,4.74]                | [252,332,288,30.12]      |
| 200 | 200                    | 200                   | 171.95             | 171.95       | [108,549,383,99.27]         | [3,1259,378,298.03]        | [7,42,31,10.26]                | [266,467,330,63.58]      |
|     | 200                    | 200                   | 172.38             | 172.38       | [157,585,391,71.80]         | [2,1186,354,278.60]        | [2,41,27,14.15]                | [257,511,326,83.78]      |
|     | 200                    | 200                   | 178.03             | 178.03       | [192,579,375,78.08]         | [3,953,377,273.19]         | [5,41,28,11.80]                | [269,442,323,55.34]      |
|     | 200                    | 200                   | 180.37             | 180.37       | [135,646,397,86.89]         | [3,942,331,267.80]         | [13,39,32,8.36]                | [267,463,315,75.17]      |
|     | 200                    | 200                   | 174.80             | 174.80       | [123,642,397,84.00]         | [3,1641,491,367.74]        | [2,46,30,15.14]                | [247,537,330,111.61]     |
| 250 | 245                    | 235.76                | 198.90             | 198.90       | [123,1217,582,222.01]       | [3,3000,512,631.56]        | [17,41,32,9.04]                | [253,347,274,35.25]      |
|     | 246                    | 237.77                | 204.71             | 204.71       | [78,828,496,157.69]         | [3,3000,465,590.16]        | [7,48,27,12.63]                | [120,314,269,22.55]      |
|     | 245                    | 233.62                | 191.95             | 191.95       | [128,860,553,165.14]        | [3,3000,572,709.57]        | [6,42,28,13.24]                | [234,286,258,14.53]      |
|     | 247                    | 237.21                | 196.32             | 196.32       | [167,781,492,133.87]        | [3,3000,532,663.92]        | [6,42,27,13.38]                | [247,348,277,37.54]      |
|     | 243                    | 235.38                | 180.87             | 180.87       | [69,692,488,135.63]         | [2,3000,578,739.45]        | [9,46,30,14.11]                | [248,432,281,54.68]      |
| 300 | 300                    | 263.25                | 206.13             | 206.13       | [171,1948,897,406.69]       | [3,3000,729,757.74]        | [8,41,30,9.83]                 | [248,267,256,6.80]       |
|     | 300                    | 257.00                | 193.66             | 193.66       | [69,2003,910,480.49]        | [6,3000,749,778.69]        | [7,40,25,9.49]                 | [245,267,257,7.36]       |
|     | 289                    | 247.03                | 198.14             | 198.14       | [100,2097,874,523.02]       | [3,3000,777,771.49]        | [5,45,32,11.88]                | [252,305,261,15.84]      |
|     | 282                    | 243.48                | 190.08             | 190.08       | [52,2003,873,494.99]        | [3,3000,702,725.47]        | [9,42,29,11.88]                | [247,305,260,17.52]      |
|     | 289                    | 238.92                | 203.03             | 203.03       | [271,2529,972,592.53]       | [6,3000,756,738.42]        | [10,44,31,10.31]               | [242,275,256,9.96]       |
| 350 | 347                    | 270.14                | 209.96             | 209.96       | [55,3217,1232,789.53]       | [9,3000,781,841.04]        | [14,42,31,7.66]                | [250,272,257,7.04]       |
|     | 324                    | 276.59                | 207.21             | 207.21       | [91,2167,1031,541.56]       | [3,3000,852,889.11]        | [3,41,27,11.28]                | [246,310,266,20.18]      |
|     | 334                    | 270.50                | 197.66             | 197.66       | [29,2815,1041,676.36]       | [3,3000,789,867.64]        | [17,41,30,9.70]                | [247,472,277,68.66]      |
|     | 341                    | 289.75                | 186.04             | 186.04       | [138,2169,1182,685.06]      | [5,3000,757,821.44]        | [2,41,24,14.14]                | [247,490,327,94.38]      |
|     | 343                    | 289.80                | 199.10             | 199.10       | [4,2218,1083,617.64]        | [3,3000,811,887.02]        | [4,40,27,11.39]                | [252,299,262,14.26]      |





