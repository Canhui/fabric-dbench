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
$ git clone https://github.com/Canhui/fabric-dbench.git --branch release-v1.4.3-raft
```


#### 2.2. Add an execution authority to .sh files


```shell
$ cd $HOME/fabric-dbench/fabric-samples
$ sudo chmod +x *.sh
$ cd $HOME/fabric-dbench/fabric-samples/run
$ sudo chmod +x *.sh
$ cd $HOME/fabric-dbench/fabric-samples/bin
$ sudo chmod +x *
```







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

# options see orderer debug logs
$ sudo ./orderer.sh &>>log &

# options (not recommended, but useful for debugging): run in frontend
$ sudo ./orderer
```





Go to `peer0.org2.example.com` node. Go to `$HOME/fabric-dbench/fabric-run/orderer` directory. Setup the orderer. 

```shell
$ cd $HOME/fabric-dbench/fabric-run/orderer

# default (recommended): run in backend
$ sudo ./orderer &>>log &

# options (not recommended, but useful for debugging): run in frontend
$ sudo ./orderer
```




Go to `peer0.org3.example.com` node. Go to `$HOME/fabric-dbench/fabric-run/orderer` directory. Setup the orderer. 

```shell
$ cd $HOME/fabric-dbench/fabric-run/orderer

# default (recommended): run in backend
$ sudo ./orderer &>>log &

# options (not recommended, but useful for debugging): run in frontend
$ sudo ./orderer
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

3 orderers

20 peers


| TAR | Sendto Endorsing (tps) | Sendto Ordering (tps) | Verification (tps) | Commit (tps) | Endorsing [Low,Up,Mean,Std] | Ordering [Low,Up,Mean,Std] | Verification [Low,Up,Mean,Std] | Commit [Low,Up,Mean,Std] |
|-----|------------------------|-----------------------|--------------------|--------------|-----------------------------|----------------------------|--------------------------------|--------------------------|
| 50  | 50                     | 50                    | 47.40              | 47.40        | [224,234,228,4.02]          | [578,1052,814,127.02]      | [21,25,22,1.15]                | [274,302,291,10.52]      |
|     | 50                     | 50                    | 46.06              | 46.06        | [217,251,236,13.80]         | [266,1407,804,253.43]      | [11,25,20,4.73]                | [283,323,301,12.33]      |
|     | 50                     | 50                    | 47.25              | 47.25        | [214,243,233,10.28]         | [559,973,787,116.63]       | [11,29,20,5.23]                | [279,319,296,12.01]      |
|     | 50                     | 50                    | 47.61              | 47.61        | [224,250,242,9.44]          | [555,1022,826,123.01]      | [18,29,22,3.36]                | [279,304,290,7.70]       |
|     | 50                     | 50                    | 47.49              | 47.46        | [218,241,228,9.125]         | [555,1044,779,126.62]      | [19,27,23,2.49]                | [265,311,288,11.39]      |
| 100 | 100                    | 100                   | 96.14              | 96.14        | [250,382,307,36.90]         | [4,936,690,177.38]         | [17,26,21,2.51]                | [280,348,301,18.52]      |
|     | 100                    | 100                   | 96.65              | 96.65        | [115,381,288,49.40]         | [3,916,700,117.66]         | [17,23,20,2.17]                | [273,309,289,11.30]      |
|     | 100                    | 100                   | 96.34              | 96.34        | [233,374,274,35.27]         | [3,944,637,231.90]         | [20,27,23,1.87]                | [286,312,293,7.73]       |
|     | 100                    | 100                   | 98.39              | 98.39        | [212,365,265,37.83]         | [493,919,664,96.58]        | [19,26,21,2.01]                | [275,322,290,13.70]      |
|     | 100                    | 100                   | 96.60              | 96.60        | [45,381,272,72.48]          | [3,892,665,166.06]         | [16,25,21,2.82]                | [289,363,304,21.71]      |
| 150 | 150                    | 150                   | 146.39             | 146.39       | [223,394,285,47.14]         | [4,1075,638,235.28]        | [16,22,19,1.59]                | [277,447,333,61.60]      |
|     | 150                    | 150                   | 145.86             | 145.86       | [125,424,295,48.26]         | [3,983,664,242.38]         | [16,27,19,3.32]                | [278,421,325,58.86]      |
|     | 150                    | 150                   | 139.76             | 139.76       | [55,358,274,41.68]          | [3,947,533,234.41]         | [5,26,18,5.71]                 | [266,423,321,53.18]      |
|     | 150                    | 150                   | 144.31             | 144.31       | [235,547,298,56.81]         | [3,950,595,223.37]         | [12,25,20,3.15]                | [279,407,326,48.01]      |
|     | 150                    | 150                   | 147.07             | 147.07       | [72,358,276,46.29]          | [3,1192,601,253.15]        | [17,26,21,2.75]                | [275,434,330,60.91]      |
| 200 | 200                    | 200                   | 195.37             | 195.37       | [66,405,302,63.16]          | [3,922,527,300.30]         | [12,26,18,4.27]                | [276,454,357,69.74]      |
|     | 200                    | 200                   | 196.03             | 196.03       | [92,407,296,54.96]          | [3,1112,518,302.49]        | [16,22,19,2.54]                | [283,473,351,70.08]      |
|     | 200                    | 200                   | 198.93             | 198.93       | [222,375,289,39.50]         | [3,955,478,279.40]         | [16,24,20,2.13]                | [278,436,351,64.96]      |
|     | 200                    | 200                   | 197.40             | 197.40       | [147,444,299,56.03]         | [3,931,532,298.15]         | [14,24,18,3.22]                | [274,436,352,63.36]      |
|     | 200                    | 200                   | 197.58             | 197.58       | [143,368,294,36.77]         | [3,920,534,286.57]         | [18,26,21,2.49]                | [283,424,350,64.16]      |
| 250 | 250                    | 250                   | 239.25             | 239.25       | [226,462,307,48.05]         | [3,1118,456,289.11]        | [16,28,20,3.41]                | [274,515,353,95.98]      |
|     | 250                    | 250                   | 235.75             | 235.75       | [55,444,323,52.32]          | [3,1129,452,324.15]        | [11,32,18,6.46]                | [266,528,369,97.79]      |
|     | 250                    | 250                   | 231.83             | 231.83       | [47,455,315,60.47]          | [3,1040,430,312.84]        | [16,27,20,3.33]                | [282,634,364,118.54]     |
|     | 250                    | 250                   | 234.12             | 234.12       | [56,483,308,63.95]          | [3,1275,416,317.58]        | [12,26,20,4.37]                | [269,600,371.107.02]     |
|     | 250                    | 250                   | 230.39             | 230.39       | [92,407,320,51.58]          | [2,1088,433,310.06]        | [16,26,21,3.26]                | [284,482,364,78.33]      |
| 300 | 300                    | 300                   | 242.35             | 242.35       | [128,499,317,79.89]         | [3,1546,450,335.91]        | [19,23,20,1.39]                | [283,459,317,62.11]      |
|     | 300                    | 300                   | 239.62             | 239.62       | [45,447,304,72.87]          | [3,1026,354,314.90]        | [18,26,21,2.20]                | [274,548,321,82.62]      |
|     | 300                    | 300                   | 234.62             | 234.62       | [52,481,317,65.27]          | [3,1045,380,290.40]        | [18,25,21,2.12]                | [261,389,294,35.38]      |
|     | 300                    | 300                   | 230.76             | 230.76       | [36,526,313,79.24]          | [3,2034,435,376.57]        | [17,22,20,1.95]                | [276,578,385,117.66]     |
|     | 300                    | 300                   | 242.07             | 242.07       | [104,430,323,70.92]         | [3,1875,385,378.82]        | [18,24,21,2.05]                | [274,569,320,89.48]      |
| 350 | 350                    | 342                   | 232.08             | 232.08       | [72,749,372,148.13]         | [3,3000,590.568.59]        | [19,27,22,2.37]                | [292,310,301,5.98]       |
|     | 350                    | 350                   | 237.44             | 237.44       | [84,522,340,99.57]          | [3,3000,549,593.44]        | [17,23,21,1.84]                | [283,308,298,8.65]       |
|     | 350                    | 344                   | 247.30             | 247.30       | [33,715,353,130.78]         | [3,3000,609,553.02]        | [20,23,21,0.91]                | [283,368,305,23.67]      |
|     | 350                    | 344                   | 243.03             | 243.03       | [74,719,338,114.76]         | [3,3000,546,578.18]        | [20,25,22,1.56]                | [276,311,297,10.73]      |
|     | 350                    | 343                   | 240.31             | 240.31       | [55,579,339,99.50]          | [3,3000,527,513.44]        | [18,26,22,2.20]                | [291,319,305,8.50]       |


Orderer Results
| TAR | Sendto Endorsing (tps) | Sendto  Ordering  (tps) | Ordering (blocktime) | Ordering (throughput) | Validate (latency) | Validate (throughput) |
|:---:|------------------------|-------------------------|----------------------|-----------------------|--------------------|-----------------------|
| 50  | 50                     | 50                      | 1.175                | 47.87                 | [434,1600,672,309] | 47.92                 |
|     | 50                     | 50                      | 1.175                | 47.87                 | [492,1606,777,286] | 47.56                 |
|     | 50                     | 50                      | 1.04                 | 47.87                 | [437,1565,658,296] | 48.04                 |
| 100 | 100                    | 100                     | 1.06                 | 93.75                 | [568,928,802,57]   | 94.11                 |
|     | 100                    | 100                     | 1.06                 | 93.75                 | [566,934,784,84]   | 93.97                 |
|     | 100                    | 100                     | 1.06                 | 93.75                 | [523,935,782,87]   | 94.22                 |
| 150 | 150                    | 150                     | 0.678                | 147.36                | [42,1013,637,266]  | 144.92                |
|     | 150                    | 150                     | 0.692                | 144.32                | [42,1038,653,239]  | 143.00                |
|     | 150                    | 150                     | 0.685                | 145.83                | [3,973,633,293]    | 143.97                |
| 200 | 200                    | 200                     | 0.510                | 195.87                | [3,960,521,282]    | 196.72                |
|     | 200                    | 200                     | 0.510                | 195.87                | [3,983,590,280]    | 195.39                |
|     | 200                    | 200                     | 0.505                | 197.91                | [3,959,491,305]    | 198.14                |
| 250 | 250                    | 250                     | 0.396                | 242.42                | [3,1191,460,348]   | 238.18                |
|     | 250                    | 250                     | 0.408                | 244.89                | [3,1065,527,318]   | 241.76                |
|     | 250                    | 250                     | 0.4125               | 242.42                | [3,1087,492,319]   | 234.94                |
| 300 | 300                    | 300                     | 0.334                | 298.96                | [3,1142,368,332]   | 281.00                |
|     | 300                    | 300                     | 0.341                | 292.92                | [3,1290,362,317]   | 268.59                |
|     | 300                    | 300                     | 0.344                | 290                   | [3,1448,431,359]   | 274.52                |
| 350 | 350                    | 350                     | 0.294                | 340                   | [3,3000,507,489]   | 284.42                |
|     | 350                    | 350                     | 0.297                | 336                   | [3,3000,506,452]   | 270.09                |
|     | 350                    | 350                     | 0.2847               | 340                   | [6,2898,403,464]   | 264.45                |


#### 9.2. Throughput and Latency of 1-Byte Transactions with Endorsing Policy "OR-10" 

All traffics go to all orderer nodes in balance, see "step5_6.sh"

3 orderers

20 peers


| TAR | Sendto Endorsing (tps) | Sendto Ordering (tps) | Verification (tps) | Commit (tps) | Endorsing [Low,Up,Mean,Std] | Ordering [Low,Up,Mean,Std] | Verification [Low,Up,Mean,Std] | Commit [Low,Up,Mean,Std] |
|-----|------------------------|-----------------------|--------------------|--------------|-----------------------------|----------------------------|--------------------------------|--------------------------|
| 50  | 50                     | 50                    | 46.89              | 46.89        | [224,265,244,13.31]         | [3,1625,617,407.86]        | [6,22,15,5.89]                 | [283,321,299,11.96]      |
|     | 50                     | 50                    | 48.15              | 48.15        | [219,277,233,18.42]         | [553,979,800,104.60]       | [6,27,17,7.05]                 | [291,416,313,36.70]      |
|     | 50                     | 50                    | 45.87              | 45.87        | [221,270,243,16.43]         | [250,1372,790,250.76]      | [11,28,21,5.91]                | [294,495,337,65.71]      |
|     | 50                     | 50                    | 46.92              | 46.92        | [229,287,243,18.51]         | [549,1067,811,130.09]      | [11,28,21,5.79]                | [291,495,333,60.22]      |
|     | 50                     | 50                    | 47.95              | 47.95        | [223,230,228,1.96]          | [549,1003,827,119.24]      | [20,27,22,2.41]                | [291,364,313,20.46]      |
| 100 | 100                    | 100                   | 97.15              | 97.15        | [236,381,305,36.49]         | [52,944,671,171.98]        | [18,31,22,3.64]                | [291,314,304,7.98]       |
|     | 100                    | 100                   | 96.35              | 96.35        | [76,381,273,64.72]          | [3,936,640,271.31]         | [20,25,22,1.49]                | [286,365,311,22.33]      |
|     | 100                    | 100                   | 97.51              | 97.51        | [55,378,272,55.34]          | [3,850,624,169.91]         | [18,27,21,2.64]                | [289,328,304,10.27]      |
|     | 100                    | 100                   | 97.94              | 97.94        | [236,370,282,38.48]         | [4,920,622,214.37]         | [17,26,22,2.50]                | [291,354,310,18.35]      |
|     | 100                    | 100                   | 96.67              | 96.67        | [240,384,299,38.16]         | [52,953,684,171.59]        | [17,23,20,2.16]                | [279,327,305,15.34]      |
| 150 | 150                    | 150                   | 147.15             | 147.15       | [218,559,280,41.91]         | [3,1051,555,229.18]        | [17,22,19,1.76]                | [284,409,325,37.71]      |
|     | 150                    | 150                   | 148.41             | 148.41       | [91,336,279,36.08]          | [3,1127,577,245.73]        | [11,24,20,4.27]                | [293,416,337,50.09]      |
|     | 150                    | 150                   | 147.10             | 147.10       | [213,368,288,34.04]         | [4,994,543,269.59]         | [20,28,22,2.46]                | [285,398,328,37.67]      |
|     | 150                    | 150                   | 147.02             | 147.02       | [44,501,314,96.96]          | [3,931,552,300.63]         | [18,25,21,2.25]                | [292,680,404,124.95]     |
|     | 150                    | 150                   | 147.39             | 147.39       | [59,384,285,44.81]          | [3,1000,571,274.44]        | [18,23,20,1.66]                | [287,411,327,40.53]      |
| 200 | 200                    | 2000                  | 195.57             | 195.57       | [252,387,314,41.01]         | [3,1017,439,325.88]        | [16,26,21,2.61]                | [292,614,380,101.69]     |
|     | 200                    | 200                   | 199.39             | 199.39       | [121,405,294,45.36]         | [3,931,461,263.82]         | [17,29,21,3.40]                | [291,419,344,50.10]      |
|     | 200                    | 200                   | 200                | 200          | [44,404,305,58.28]          | [3,1000,478,291.09]        | [18,25,20,1.91]                | [290,430,346,59.69]      |
|     | 200                    | 200                   | 200                | 200          | [45,378,293,44.25]          | [3,981,488,298.36]         | [16,25,21,2.67]                | [289,416,345,49.92]      |
|     | 200                    | 200                   | 199.60             | 199.60       | [252,389,291,32.16]         | [3,983,548,276.14]         | [16,29,21,3.89]                | [291,407,339,34.65]      |
| 250 | 250                    | 250                   | 235.89             | 235.89       | [155,427,312,48.43]         | [3,1184,534,309.46]        | [14,25,21,3.28]                | [298,531,371,89.60]      |
|     | 250                    | 250                   | 229.11             | 229.11       | [118,455,328,48.03]         | [3,1292,478,330.38]        | [18,26,20,2.54]                | [288,561,378,100.81]     |
|     | 250                    | 250                   | 237.34             | 237.34       | [253,473,337,52.53]         | [3,1013,506,302.46]        | [16,30,21,3.51]                | [293,513,369,80.73]      |
|     | 250                    | 250                   | 236.89             | 236.89       | [39,437,333,61.99]          | [3,1569,459,329.55]        | [18,27,22,3.20]                | [289,504,369,77.77]      |
|     | 250                    | 250                   | 231.45             | 231.45       | [118,531,312,62.21]         | [3,1209,402,302.55]        | [12,26,19,3.74]                | [278,527,374,82.83]      |
| 300 | 300                    | 294                   | 225.26             | 225.26       | [106,726,412,140.01]        | [3,2990,528,529.94]        | [21,27,23,1.77]                | [275,313,298,11.82]      |
|     | 300                    | 300                   | 238.58             | 238.58       | [70,427,304,66.03]          | [2,2049,439,348.90]        | [19,25,21,2.11]                | [282,546,327,78.05]      |
|     | 300                    | 300                   | 239.47             | 239.47       | [65,450,314,71.99]          | [3,1954,462,378.40]        | [19,26,21,1.87]                | [283,433,326,54.41]      |
|     | 300                    | 300                   | 239.70             | 239.70       | [99,455,293,68.34]          | [3,2273,460,407.81]        | [19,23,21,1.57]                | [285,397,311,31.10]      |
|     | 300                    | 300                   | 233.64             | 233.64       | [105,438,300,58.95]         | [3,2891,477,535.95]        | [18,27,21,3.11]                | [282,559,438,106.22]     |
| 350 | 350                    | 340                   | 240.11             | 240.11       | [16,957,362,171.31]         | [3,3000,550,557.25]        | [20,25,22,1.56]                | [291,317,303,7.19]       |
|     | 350                    | 337                   | 240.69             | 240.69       | [100,835,383,157.99]        | [3,2928,565,553.50]        | [17,25,22,2.20]                | [289,309,300,6.37]       |
|     | 346                    | 342                   | 230.49             | 230.49       | [93,585,324,94.39]          | [3,3000,547,583.51]        | [19,25,21,1.98]                | [289,760,349,144.69]     |
|     | 346                    | 340                   | 240.28             | 240.28       | [133,723,346,106.73]        | [23,3000,528,559.13]       | [16,24,19,2.44]                | [276,313,303,11.68]      |
|     | 350                    | 340                   | 239.43             | 239.43       | [59,620,363,131.12]         | [3,3000,602,556.33]        | [21,25,22,1.07]                | [293,314,302,5.93]       |





Performance Bottleneck Analysis

| Performance Metrics                             | Details                                                                            |
|-------------------------------------------------|------------------------------------------------------------------------------------|
| Average Number of Transactions per Block        | 100                                                                                |
| Average Transaction Size                        | 297.334KB/100                                                                      |
| Average Block Size                              | 297.334KB                                                                          |
| Bottleneck Details of Policy Evaluation in OSNs | https://drive.google.com/file/d/1wSruExwb8vTNOwGR_LSjCN9QJ0f3QCHf/view?usp=sharing |






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
| 50  | 50                     | 50                    | 49.07              | 49.07        | [267,334,305,17.72]         | [175,1383,478,330.57]      | [11,35,24,6.16]                | [246,270,253,7.21]       |
|     | 50                     | 50                    | 47.65              | 47.65        | [285,357,307,30.09]         | [471,1013,764,170.40]      | [9,37,22,10.62]                | [230,372,277,39.75]      |
|     | 50                     | 50                    | 48.97              | 48.97        | [274,415,327,43.94]         | [46,1451,666,366.95]       | [10,38,24,10.46]               | [255,334,278,27.93]      |
|     | 50                     | 50                    | 47.85              | 47.85        | [289,461,308,16.65]         | [3,989,598,264.44]         | [7,38,22,10.95]                | [249,353,277,31.98]      |
|     | 50                     | 50                    | 48.11              | 48.11        | [275,340,306,18.25]         | [190,1428,538,315.37]      | [10,35,24,6.36]                | [255,403,304,62.09]      |
| 100 | 100                    | 100                   | 94.05              | 94.05        | [267,453,342,45.46]         | [4,852,545,198.55]         | [3,35,23,12.51]                | [242,341,265,29.34]      |
|     | 100                    | 100                   | 94.13              | 94.13        | [78,440,328,82.19]          | [3,978,473,248.11]         | [2,38,25,11.54]                | [229,399,294,59.61]      |
|     | 100                    | 100                   | 92.28              | 92.28        | [286,470,360,47.42]         | [3,1642,548,327.58]        | [6,35,20,10.12]                | [235,355,283,42.71]      |
|     | 100                    | 100                   | 96.45              | 96.45        | [226,523,348,70.09]         | [3,960,502,324.00]         | [6,38,22,12.58]                | [234,452,286,60.90]      |
|     | 100                    | 100                   | 94.08              | 94.08        | [302,447,355,41.69]         | [3,1045,467,289.46]        | [8,34,24,9.16]                 | [253,362,291,39.80]      |
| 150 | 145                    | 144                   | 143.88             | 143.64       | [216,565,376,71.89]         | [3,1328,337,300.21]        | [11,35,28,7.45]                | [243,355,294,41.09]      |
|     | 150                    | 150                   | 138.57             | 138.57       | [183,687,401,94.03]         | [3,1756,416,390.95]        | [24,42,32,5.69]                | [252,389,299,55.30]      |
|     | 150                    | 150                   | 140.74             | 140.74       | [128,544,416,78.34]         | [3,1111,423,307.55]        | [2,39,22,12.58]                | [252,481,340.94.11]      |
|     | 150                    | 150                   | 135.94             | 135.94       | [91,604,404,114.14]         | [3,1697,523,366.62]        | [13,36,26,7.82]                | [252,392,306,54.11]      |
|     | 150                    | 150                   | 141.75             | 141.75       | [213,557,382,59.66]         | [3,1493,431,365.14]        | [6,34,27,8.21]                 | [251,553,358,104.56]     |
| 200 | 200                    | 200                   | 168.76             | 168.76       | [167,661,419,91.24]         | [3,1128,371,300.27]        | [3,38,26,11.05]                | [238,404,313,67.83]      |
|     | 200                    | 198                   | 167.35             | 167.35       | [118,592,412,107.98]        | [3,1253,364,312.46]        | [2,38,27,12.47]                | [257,445,302,63.49]      |
|     | 200                    | 200                   | 163.69             | 163.69       | [80,601,409,108.88]         | [3,1091,316,282.22]        | [1,43,29,12.07]                | [256,454,310,72.32]      |
|     | 200                    | 200                   | 170.98             | 170.98       | [105,559,400,85.16]         | [3,804,304,244.23]         | [15,45,31,9.36]                | [249,374,289,51.92]      |
|     | 200                    | 200                   | 175.07             | 175.07       | [144,598,386,90.30]         | [3,1692,366,370.42]        | [2,44,27,12.42]                | [247,482,319,86.33]      |
| 250 | 249                    | 241                   | 177.28             | 177.28       | [146,664,494,101.17]        | [3,3000,493,604.85]        | [6,38,28,10.30]                | [241,451,271,63.57]      |
|     | 251                    | 237                   | 180.10             | 180.10       | [95,1055,512,187.34]        | [3,3000,571,584.30]        | [2,37,27,10.00]                | [247,285,264,12.07]      |
|     | 248                    | 238                   | 178.77             | 178.77       | [236,729,488,113.01]        | [3,3000,552,624.92]        | [13,37,30,8.46]                | [252,478,291,67.23]      |
|     | 247                    | 229                   | 179.75             | 179.75       | [121,1094,520,185.97]       | [3,3000,482,582.99]        | [14,36,30,7.43]                | [252,279,268,9.40]       |
|     | 247                    | 239                   | 180.39             | 189.39       | [121,759,527,139.08]        | [3,3000,576,665.18]        | [19,37,28,6.26]                | [254,280,269,8.74]       |
| 300 | 290                    | 270                   | 177.53             | 177.53       | [153,1156,669,273.35]       | [3,3000,781,715.29]        | [17,33,26,6.00]                | [240,281,262,12.17]      |
|     | 285                    | 260                   | 176.42             | 176.42       | [128,1787.701,442.67]       | [3,3000,754,784.70]        | [13,40,29,11.00]               | [253,496,289,73.29]      |
|     | 288                    | 267.54                | 179.01             | 179.01       | [105,1540,688,376.87]       | [3,3000,763,795.68]        | [15,39,30,8.52]                | [249,294,267,13.54]      |
|     | 288                    | 274.34                | 180.12             | 180.12       | [35,1315,652,321.80]        | [3,3000,749,798.51]        | [6,38,28,11.75]                | [262,285,270,6.79]       |
|     | 287                    | 256.32                | 175.15             | 175.15       | [161,1606,736,420.66]       | [3,3000,723,784.64]        | [5,36,25,10.63]                | [244,386,273,40.39]      |
| 350 | 334                    | 294.21                | 173.22             | 173.22       | [10,2016,768,542.07]        | [8,3000,780,844.11]        | [5,36,21,11.85]                | [252,293,271,12.99]      |
|     | 321                    | 289.35                | 173.88             | 173.88       | [26,2000,764,544.12]        | [12,3000,716,822.36]       | [7,38,29,11.16]                | [250,275,266,7.27]       |
|     | 336                    | 292.39                | 178.90             | 178.90       | [17,1919,828,566.66]        | [5,3000,761,811.78]        | [10,40,28,9.25]                | [257,278,264,6.02]       |
|     | 331                    | 288.73                | 179.80             | 179.80       | [13,1888,661,470.88]        | [3,3000,805,852.46]        | [4,39,26,11.76]                | [259,288,272,8.85]       |
|     | 343                    | 301.85                | 181.83             | 181.83       | [37,1996,784,566.03]        | [3,3000,805,856.09]        | [17,38,29,6.94]                | [252,277,266,9.62]       |




Performance Bottleneck Analysis




| Performance Metrics                             | Details                                                                            |
|-------------------------------------------------|------------------------------------------------------------------------------------|
| Average Number of Transactions per Block        | 79                                                                                 |
| Average Transaction Size                        | 520.326KB/79                                                                       |
| Average Block Size                              | 520.326KB                                                                          |
| Bottleneck Details of Policy Evaluation in OSNs | https://drive.google.com/file/d/1KHDVnLjtI1tgvURuPbkyY45MlZDj_qO4/view?usp=sharing |




