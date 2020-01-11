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


Each node of the cluster has a host file under the `/etc/hosts` directory. Append the following to the host file.

```shell
# ---------------------------------------------------------------------------
# Hyperledger Cluster Configuration - Pls contact chwang@comp.hkbu.edu.hk Thx.
# ---------------------------------------------------------------------------
192.168.0.101 orderer1.example.com
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
$ git clone https://github.com/Canhui/fabric-dbench.git --branch release-v1.4.3-solo
```


#### 2.2. Add an execution authority to all .sh files

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

# options (not recommended, but useful for debugging): run in frontend
$ sudo ./orderer

# if the port 8443 is in use, pls use the following command to free the port
$ sudo fuser -k 8443/tcp
```







Go to `peer0.org1.example.com` node. Go to `$HOME/fabric-dbench/fabric-run/peer` directory. Setup the peer. 

```shell
$ cd $HOME/fabric-dbench/fabric-run/peer

# default (recommended): run in backend
$ sudo ./peer node start &>>log &

# options (not recommended, but useful for debugging): run in frontend
$ sudo ./peer node start

# if the port 9443 is in use, pls use the following command to free the port
$ sudo fuser -k 9443/tcp
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

1 orderer

20 peers


| TAR | Sendto Endorsing (tps) | Sendto Ordering (tps) | Verification (tps) | Commit (tps) | Endorsing [Low,Up,Mean,Std] | Ordering [Low,Up,Mean,Std] | Verification [Low,Up,Mean,Std] | Commit [Low,Up,Mean,Std] |
|-----|------------------------|-----------------------|--------------------|--------------|-----------------------------|----------------------------|--------------------------------|--------------------------|
| 50  | 50                     | 50                    | 49.45              | 49.45        | [233,258,241,8.38]          | [490,938,715,119.90]       | [18,27,22,2.54]                | [277,299,287,7.92]       |
|     | 50                     | 50                    | 48.38              | 48.38        | [229,277,247,17.08]         | [181,1566,656,337.18]      | [8,26,17,5.12]                 | [273,302,285,9.25]       |
|     | 50                     | 50                    | 47.87              | 46.87        | [233,296,246,20.19]         | [159,1404,510,342.27]      | [12,25,14,3.86]                | [271,301,290,9.17]       |
|     | 50                     | 50                    | 47.87              | 47.87        | [223,276,242,19.77]         | [378,681,545,67.21]        | [3,17,12,3.88]                 | [265,308,288,14.51]      |
|     | 50                     | 50                    | 48.38              | 47.87        | [215,271,238,21.22]         | [239,1577,736,315.41]      | [3,25,13,7.80]                 | [271,312,289,12.89]      |
| 100 | 100                    | 100                   | 100                | 100          | [213,368,268,46.61]         | [53,1302,625,212.81]       | [14,28,21,4.24]                | [275,354,300,27.11]      |
|     | 100                    | 100                   | 96.77              | 96.77        | [221,391,273,46.23]         | [460,863,627,99.32]        | [15,24,19,3.16]                | [269,314,292,14.65]      |
|     | 100                    | 100                   | 97.82              | 97.82        | [217,381,271,40.60]         | [110,898,615,140.67]       | [16,24,20,2.59]                | [276,322,295,14.08]      |
|     | 100                    | 100                   | 100                | 100          | [245,378,277,33.06]         | [16,936,556,228.33]        | [18,30,23,3.80]                | [265,402,300,39.46]      |
|     | 100                    | 100                   | 98.90              | 98.90        | [229,325,275,29.34]         | [3,1019,356,350.70]        | [19,29,22,3.17]                | [295,604,474,83.22]      |
| 150 | 150                    | 150                   | 135.92             | 135.92       | [217,318,268,23.60]         | [4,976,550,207.84]         | [17,27,20,2.71]                | [277,361,309,31.96]      |
|     | 150                    | 150                   | 147.36             | 147.36       | [84,351,281,43.43]          | [3,1128,530,247.68]        | [14,24,20,2.99]                | [280,423,326,47.14]      |
|     | 150                    | 150                   | 148.93             | 148.93       | [35,438,299,58.32]          | [3,946,585,230.04]         | [17,25,20,2.45]                | [280,343,308,21.68]      |
|     | 150                    | 150                   | 138.61             | 138.61       | [214,355,263,29.48]         | [49,930,588,191.51]        | [16,27,20,3.03]                | [285,361,306,27.51]      |
|     | 150                    | 150                   | 148.93             | 148.93       | [121,371,269,35.91]         | [3,960,606,172.15]         | [15,22,19,2.59]                | [278,360,306,27.19]      |
| 200 | 200                    | 200                   | 200                | 200          | [219,380,286,40.18]         | [42,947,603,231.07]        | [13,31,20,5.20]                | [284,369,318,31.45]      |
|     | 200                    | 200                   | 200                | 200          | [65,407,263,43.25]          | [3,943,515,204.31]         | [12,24,19,3.38]                | [284,380,320,37.88]      |
|     | 200                    | 200                   | 197.91             | 197.91       | [111,381,291,44.21]         | [3,1384,613,263.91]        | [16,27,20,3.39]                | [295,508,417,71.45]      |
|     | 200                    | 200                   | 200                | 200          | [77,397,288,52.23]          | [3,980,675,153.37]         | [13,30,19,5.16]                | [282,373,322,35.13]      |
|     | 200                    | 200                   | 200                | 200          | [219,377,284,31.63]         | [42,976,661,154.61]        | [16,23,20,2.34]                | [290,403,323,35.26]      |
| 250 | 250                    | 250                   | 244.89             | 244.89       | [56,444,297,67.10]          | [3,1257,493,288.63]        | [14,26,20,3.19]                | [269,450,315,53.10]      |
|     | 250                    | 250                   | 242.42             | 242.42       | [242,460,321,47.95]         | [3,1290,514,327.47]        | [12,27,18,5.46]                | [283,492,351,76.12]      |
|     | 250                    | 250                   | 240                | 240          | [23,433,297,52.49]          | [3,1342,476,300.22]        | [13,34,21,6.24]                | [284,486,366,74.25]      |
|     | 250                    | 250                   | 242.42             | 242.42       | [221,484,317,59.89]         | [3,1766,549,404.95]        | [12,24,19,3.91]                | [277,702,498,117.58]     |
|     | 250                    | 250                   | 240                | 240          | [79,532,311,68.73]          | [3,1302,489,302.17]        | [13,26,18,4.16]                | [284,414,324,43.65]      |
| 300 | 300                    | 300                   | 266.05             | 266.05       | [27,445,295,64.24]          | [3,1358,407,325.97]        | [15,22,18,2.11]                | [288,462,333,57.10]      |
|     | 300                    | 300                   | 266.05             | 266.05       | [135,506,313,82.33]         | [3,1734,511,346.55]        | [12,25,19,4.32]                | [278,509,334,82.62]      |
|     | 300                    | 300                   | 263.63             | 263.63       | [135,506,313,64.58]         | [3,2932,575,609.83]        | [13,25,19,3.43]                | [327,723,507,118.78]     |
|     | 300                    | 300                   | 266.05             | 266.05       | [141,472,314,62.94]         | [3,1258,441,312.51]        | [13,30,21,5.20]                | [278,507,324,70.33]      |
|     | 300                    | 300                   | 258.92             | 258.92       | [134,500,297,62.06]         | [3,1637,463,332.47]        | [12,26,20,4.43]                | [282,445,332,58.09]      |
| 350 | 350                    | 343.37                | 259.54             | 259.54       | [109,529,334,95.51]         | [6,2903,595,536.18]        | [20,24,21,1.43]                | [275,307,290,11.48]      |
|     | 350                    | 350                   | 261.53             | 261.53       | [29,516,323,93.65]          | [3,3000,592,576.66]        | [18,26,21,2.39]                | [283,465,319,66.43]      |
|     | 350                    | 350                   | 263.56             | 263.56       | [91,599,325,106.19]         | [3,3000,517,545.26]        | [20,28,22,2.07]                | [273,315,290,11.56]      |
|     | 350                    | 345.61                | 263.56             | 263.56       | [109,669,332,116.78]        | [3,3000,607,548.49]        | [18,24,21,1.90]                | [275,315,290,12.66]      |
|     | 350                    | 343.17                | 253.73             | 253.73       | [68,699,349,122.46]         | [3,3000,628,608.67]        | [16,26,21,2.71]                | [282,461,311,53.21]      |
| 400 | 400                    | 391.35                | 260                | 260          | [70,792,383,157.88]         | [3,3000,632.675.18]        | [20,22,21,0.82]                | [268,310,290,12.57]      |
|     | 400                    | 382.73                | 263.51             | 263.51       | [75,1088,410,212.44]        | [3,3000,672,662.35]        | [19,27,22,2.00]                | [283,304,294,8.43]       |
|     | 400                    | 387.33                | 261                | 261          | [91,809,407,180.82]         | [5,3000,633.654.08]        | [16.23,21,1.94]                | [268,336,291,19.10]      |
|     | 400                    | 371.98                | 265.30             | 265.30       | [65,1141,401,222.23]        | [3,3000,692,716.28]        | [16,25,21,2.60]                | [272,300,291,8.70]       |
|     | 400                    | 386.39                | 265.30             | 265.30       | [49,855,388,178.51]         | [3,3000,702,670.20]        | [17,28,21,2.97]                | [268,309,287,13.16]      |


Performance Bottleneck Analysis

| Performance Metrics                             | Details                                                                            |
|-------------------------------------------------|------------------------------------------------------------------------------------|
| Average Number of Transactions per Block        | 100                                                                                |
| Average Transaction Size                        | 297.914KB/100                                                                      |
| Average Block Size                              | 297.914KB                                                                          |
| Bottleneck Details of Policy Evaluation in OSNs | https://drive.google.com/file/d/1Yq8txIvF1F5a-N8Yrg4ogBekSNQuHp3j/view?usp=sharing |









#### 9.2. Throughput and Latency of 3000-Bytes Transactions with Endorsing Policy "OR-10"

All traffics go to only one orderer node, 1500-Bytes Transactions, see "step5_4.sh"

1 orderer

20 peers


| TAR | Sendto Endorsing (tps) | Sendto Ordering (tps) | Verification (tps) | Commit (tps) | Endorsing [Low,Up,Mean,Std] | Ordering [Low,Up,Mean,Std] | Verification [Low,Up,Mean,Std] | Commit [Low,Up,Mean,Std] |
|-----|------------------------|-----------------------|--------------------|--------------|-----------------------------|----------------------------|--------------------------------|--------------------------|
| 50  | 50                     | 50                    | 47.87              | 47.87        | [236,288,257,18.75]         | [263,875,610,141.13]       | [6,20,14,4.45]                 | [279,322,298,13.08]      |
|     | 50                     | 50                    | 47.87              | 47.87        | [223,299,277,23.20]         | [177,1594,606,344.35]      | [8,19,13,3.51]                 | [273,326,296,15.77]      |
|     | 50                     | 50                    | 47.36              | 47.36        | [265,303,285,14.82]         | [201,1588,633,336.49]      | [2,17,11,4.47]                 | [271,302,291,10.61]      |
|     | 50                     | 50                    | 47.87              | 47.87        | [227,286,257,21.05]         | [257,924,563,138.33]       | [8,20,13,3.31]                 | [273,312,290,11.86]      |
|     | 50                     | 50                    | 47.87              | 47.87        | [243,305,273,22.04]         | [203,895,552,145.86]       | [1,25,12,5.94]                 | [273,310,288,13.30]      |
| 100 | 100                    | 100                   | 96.03              | 96.03        | [58,405,325,46.11]          | [2,1398,400,357.43]        | [9,25,16,5.39]                 | [287,365,313,28.86]      |
|     | 100                    | 100                   | 93.13              | 93.13        | [49,405,304,59.01]          | [3,844,379,260.97]         | [3,20,12,4.97]                 | [285,353,320,18.79]      |
|     | 100                    | 100                   | 92.23              | 92.23        | [202,490,309,57.21]         | [3,993,429,291.71]         | [1,22,12,6.55]                 | [273,372,313,32.83]      |
|     | 100                    | 100                   | 93.13              | 93.13        | [253,466,341,54.38]         | [9,1465,543,296.91]        | [6,18,12,5.27]                 | [280,392,319,39.07]      |
|     | 100                    | 100                   | 95                 | 95           | [189,392,312,41.87]         | [3,843,579,213.27]         | [8,22,13,5.03]                 | [283,336,309,21.30]      |
| 150 | 150                    | 150                   | 138.09             | 138.09       | [83,495,341,77.91]          | [2,1622,427,393.44]        | [0,29,14.5,8.72]               | [275,461,339,59.74]      |
|     | 150                    | 150                   | 143.56             | 143.56       | [108.512,358,77.41]         | [2,960,331,292.83]         | [3,23,13,6.90]                 | [263,424,327,48.55]      |
|     | 150                    | 150                   | 140.77             | 140.77       | [98,544,330,70.17]          | [2,1539,398,321.88]        | [2,22,12,6.85]                 | [286,446,344,58.44]      |
|     | 150                    | 150                   | 139.42             | 139.42       | [115,467,358,61.82]         | [3,1430,393,377.69]        | [2,26,13,7.70]                 | [280,366,320,33.35]      |
|     | 150                    | 150                   | 143.56             | 143.56       | [101,499,332,53.20]         | [3,1095,477,292.66]        | [3,22,13.7,5.79]               | [256,446,331,64.80]      |
| 200 | 197                    | 192                   | 159.93             | 159.93       | [130,536,404,64.02]         | [3,2502,445,464.41]        | [11,21,16,3.33]                | [287,420,317,41.92]      |
|     | 200                    | 200                   | 154.70             | 154.70       | [128,570,408,65.41]         | [3,2820,504,508.44]        | [2,24,14,5.95]                 | [272,490,321,64.63]      |
|     | 200                    | 200                   | 167.17             | 167.17       | [77,616,395,73.14]          | [3,2625,501,443.80]        | [11,24,18,3.77]                | [281,415,333,50.80]      |
|     | 200                    | 200                   | 158.84             | 158.84       | [299,526,405,48.03]         | [3,3000,514,572.56]        | [6,24,17,5.56]                 | [286,526,323,72.24]      |
|     | 200                    | 200                   | 165.09             | 165.09       | [266,504,395,70.26]         | [3,2367,418,424.66]        | [2,21,14,6.43]                 | [272,474,314,60.89]      |
| 250 | 246                    | 235                   | 159.73             | 159.73       | [47,747,498,104.62]         | [3,3000,639,705.47]        | [1,22,16,7.06]                 | [276,311,296,13.65]      |
|     | 249                    | 244                   | 165.54             | 165.54       | [46,607,440,90.21]          | [3,3000,651,713.33]        | [6,21,15,4.62]                 | [276,321,299,13.54]      |
|     | 250                    | 242                   | 164.07             | 164.07       | [77,718,461,101.05]         | [2,3000,608,702.79]        | [6,21,16,5.00]                 | [282,311,290,12.29]      |
|     | 250                    | 236                   | 165.80             | 165.80       | [118,850,481,127.71]        | [2,3000,589,697.74]        | [7,21,16,5.00]                 | [266,312,293,13.21]      |
|     | 250                    | 237                   | 170.32             | 170.32       | [59,958,450,162.05]         | [3,3000,578,639.61]        | [12,22,16,3.14]                | [275,350,297,20.88]      |
| 300 | 291                    | 269                   | 158.68             | 158.68       | [20,1183,577,316.41]        | [3,3000,755,801.04]        | [2,22,15,6.88]                 | [274,328,298,16.33]      |
|     | 297                    | 280                   | 131.35             | 131.35       | [19,893,504,243.49]         | [3,3000,823,812.60]        | [5,21,15,5.13]                 | [437,535,489,27.48]      |
|     | 288                    | 268                   | 164.13             | 164.13       | [20,1223,603,308.70]        | [3,3000,752,782.26]        | [8,22,17,4.12]                 | [282,311,295,10.02]      |
|     | 292                    | 272                   | 159.13             | 159.13       | [34,1123,587,300.42]        | [3,3000,775,790.08]        | [1,20,14,7.01]                 | [278,311,293,10.17]      |
|     | 296                    | 267                   | 164.68             | 164.68       | [114,1333,539,319.68]       | [3,3002,759,814.89]        | [2,22,14,6.15]                 | [271,354,301,23.33]      |





#### 9.3. Throughput and Latency of 1-Bytes Transactions with Endorsing Policy "AND-5"

All traffics go to only one orderer node, 1-Byte Transactions, see "step5_5.sh"

1 orderer

20 peers


| TAR | Sendto Endorsing (tps) | Sendto Ordering (tps) | Verification (tps) | Commit (tps) | Endorsing [Low,Up,Mean,Std] | Ordering [Low,Up,Mean,Std] | Verification [Low,Up,Mean,Std] | Commit [Low,Up,Mean,Std] |
|-----|------------------------|-----------------------|--------------------|--------------|-----------------------------|----------------------------|--------------------------------|--------------------------|
| 50  | 50                     | 50                    | 50                 | 50           | [289,346,312,17.76]         | [119,1333,407,327.60]      | [11,114,32,29.01]              | [250,376,281,35.89]      |
|     | 50                     | 50                    | 48.69              | 48.69        | [273,340,305,21.22]         | [149,1253,459,324.01]      | [10,35,25,6.32]                | [254,393,287,40.47]      |
|     | 50                     | 50                    | 48.96              | 48.96        | [277,325,306,17.54]         | [136,1296,626,277.26]      | [7,41,25,10.50]                | [266,312,280,15.43]      |
|     | 50                     | 50                    | 48.88              | 48.88        | [280,325,298,20.20]         | [143,1329,543,357.25]      | [10,34,23,8.58]                | [267,323,284,15.86]      |
|     | 50                     | 50                    | 50                 | 50           | [287,342,309,18.07]         | [314,943,544,160.72]       | [11,37,27,8.07]                | [276,296,283,6.78]       |
| 100 | 100                    | 100                   | 98.90              | 98.90        | [141,446,359,61.44]         | [3,883,528,226.80]         | [12,39,25,11.52]               | [259,306,281,14.21]      |
|     | 100                    | 100                   | 93.08              | 93.08        | [229,460,370,58.18]         | [3,1180,588,236.14]        | [2,38,23,14.77]                | [252,348,286,31.72]      |
|     | 100                    | 100                   | 95.78              | 95.78        | [79,434,368,83.89]          | [3,923,586,219.10]         | [6,39,23,13.87]                | [251,329,280,24.41]      |
|     | 100                    | 100                   | 92.52              | 92.52        | [75,443,313,92.52]          | [3,889,536,267.00]         | [9,39,23,12.50]                | [255,367,293,38.05]      |
|     | 100                    | 100                   | 94.36              | 94.36        | [138,451,346,71.23]         | [3,851,484,214.65]         | [2,39,22,14.41]                | [262,666,315,123.84]     |
| 150 | 150                    | 149.68                | 140.91             | 140.91       | [115,515,385,82.21]         | [4,1109,454,306.38]        | [1,199,43.2,56.85]             | [256,534,308,88.19]      |
|     | 150                    | 150                   | 138.80             | 138.80       | [236,574,388,71.93]         | [3,1541,511,337.25]        | [9,46,30,12.13]                | [256,380,306,44.62]      |
|     | 150                    | 150                   | 142.20             | 142.20       | [269,610,408,71.46]         | [3,1164,503,320.21]        | [1,45,26,14.60]                | [260,567,363,107.19]     |
|     | 150                    | 150                   | 141.44             | 141.44       | [167,520,382,77.20]         | [4,1534,505,358.36]        | [1,39,26,11.72]                | [262,427,324,53.16]      |
|     | 150                    | 150                   | 140.26             | 140.26       | [125,532,379,92.65]         | [3,908,421,229.81]         | [4,39,25,12.42]                | [251,377,290,40.95]      |
| 200 | 200                    | 200                   | 176.42             | 176.42       | [120,627,401,101.73]        | [3,1435,431,352.61]        | [4,36,22,11.34]                | [278,409,318,44.12]      |
|     | 200                    | 199                   | 196.92             | 176.92       | [142,670,364,93.45]         | [3,1031,358,312.75]        | [6,40,28,11.76]                | [269,472,318,72.52]      |
|     | 200                    | 200                   | 184.70             | 184.70       | [125,694,413,112.99]        | [3,885,392,280.53]         | [2,34,22,8.74]                 | [246,380,311,42.76]      |
|     | 200                    | 200                   | 179.69             | 179.69       | [118,786,433,111.52]        | [3,1082,279,271.19]        | [14,34,23,7.12]                | [247,376,296,45.35]      |
|     | 200                    | 200                   | 180.25             | 180.25       | [187,592,384,81.73]         | [3,1164,352,328.22]        | [7,39,22,11.62]                | [264,461,319,66.34]      |
| 250 | 247                    | 247                   | 182.53             | 182.53       | [189,921,537,149.03]        | [3,3000,576,579.74]        | [8,39,29,10.40]                | [250,334,271,26.00]      |
|     | 248                    | 248                   | 187.71             | 187.71       | [107,773,473,123.38]        | [3,3000,485,578.77]        | [11,39,28,9.64]                | [250,346,267,28.08]      |
|     | 247                    | 242                   | 187.22             | 187.22       | [276,902,503,121.88]        | [3,3000,571,638.56]        | [20,37,29,6.88]                | [251,333,271,24.32]      |
|     | 242                    | 239                   | 175.47             | 175.47       | [250,898,508,156.12]        | [3,3000,591,619.71]        | [2,41,26,14.34]                | [251,556,342,90.58]      |
|     | 249                    | 237                   | 196.09             | 196.09       | [255,790,473,121.54]        | [3,3000,518,558.54]        | [18,42,31,7.06]                | [252,355,278,36.25]      |
| 300 | 285                    | 252                   | 185.00             | 185.00       | [44,1664,882,439.31]        | [3,3000,722,728.75]        | [2,37,28,10.80]                | [249,303,268,16.44]      |
|     | 300                    | 262                   | 181.14             | 181.14       | [6,1761,757,416.26]         | [3,3000,832,855.05]        | [2,36,25,13.72]                | [246,277,260,9.82]       |
|     | 292                    | 247.89                | 195.87             | 195.87       | [19,2197,905,555.37]        | [3,3000,718,771.68]        | [2,37,28,10.80]                | [247,347,274,28.31]      |
|     | 300                    | 250.20                | 192.12             | 192.12       | [10,2468,887,645.60]        | [3,3000,782,840.49]        | [8,37,27,8.29]                 | [249,282,263,8.72]       |
|     | 284.68                 | 259.35                | 188.49             | 188.49       | [44,1437,829,442.95]        | [3,3000,757,791.36]        | [6,36,26,11.15]                | [251,289,266,11.50]      |
| 350 | 331.69                 | 292.83                | 188.26             | 188.26       | [34,2422,956,599.74]        | [4,3000,743,816.72]        | [4,40,28,11.75]                | [250,458,361,74.85]      |
|     | 345.74                 | 289.01                | 199.55             | 199.55       | [159,2324,1023,582.29]      | [6,3000,793,836.62]        | [6,37,28,10.44]                | [250,273,261,8.25]       |
|     | 329                    | 295.85                | 190.72             | 190.72       | [70,1973,885,484.41]        | [7,3000,748,812.67]        | [3,38,28,11.40]                | [254,277,263,8.34]       |
|     | 333                    | 275.98                | 199                | 199          | [99,2503,1046,694.97]       | [3,3000,711,779.68]        | [16,39,32,7.95]                | [250,278,265,8.68]       |
|     | 340                    | 281.35                | 183.72             | 183.72       | [157,2532,1033,628.54]      | [3,3000,726,772.86]        | [2,48,25,15.78]                | [258,453,359,79.47]      |



Performance Bottleneck Analysis

| Performance Metrics                             | Details                                                                            |
|-------------------------------------------------|------------------------------------------------------------------------------------|
| Average Number of Transactions per Block        | 79                                                                                 |
| Average Transaction Size                        | 521.705KB/79                                                                       |
| Average Block Size                              | 521.705KB                                                                          |
| Bottleneck Details of Policy Evaluation in OSNs | https://drive.google.com/file/d/1rVUusX_TYlP-gmFNezqXgNhI3idVJ7hW/view?usp=sharing |









