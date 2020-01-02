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

#### 9.1. Throughput and Latency of 1-Byte Transactions with Endorsing Policy "OR"

**Round 1:**

| TAR | Endorsing (tps) | Ordering (tps) | Verification (tps) | Commit (tps) | Endorsing (ms) | Ordering (ms) | Verification (ms) | Commit (ms) |
|-----|-----------------|----------------|--------------------|--------------|----------------|---------------|-------------------|-------------|
| 50  |                 |                |                    |              |                |               |                   |             |
| 100 |                 |                |                    |              |                |               |                   |             |
| 150 |                 |                |                    |              |                |               |                   |             |
| 200 |                 |                |                    |              |                |               |                   |             |
| 250 |                 |                |                    |              |                |               |                   |             |
| 300 |                 |                |                    |              |                |               |                   |             |
| 350 |                 |                |                    |              |                |               |                   |             |
| 400 |                 |                |                    |              |                |               |                   |             |
| 450 |                 |                |                    |              |                |               |                   |             |
| 500 |                 |                |                    |              |                |               |                   |             |

**Round 2:**

| TAR | Endorsing (tps) | Ordering (tps) | Verification (tps) | Commit (tps) | Endorsing (ms) | Ordering (ms) | Verification (ms) | Commit (ms) |
|-----|-----------------|----------------|--------------------|--------------|----------------|---------------|-------------------|-------------|
| 50  |                 |                |                    |              |                |               |                   |             |
| 100 |                 |                |                    |              |                |               |                   |             |
| 150 |                 |                |                    |              |                |               |                   |             |
| 200 |                 |                |                    |              |                |               |                   |             |
| 250 |                 |                |                    |              |                |               |                   |             |
| 300 |                 |                |                    |              |                |               |                   |             |
| 350 |                 |                |                    |              |                |               |                   |             |
| 400 |                 |                |                    |              |                |               |                   |             |
| 450 |                 |                |                    |              |                |               |                   |             |
| 500 |                 |                |                    |              |                |               |                   |             |


**Round 3:**

| TAR | Endorsing (tps) | Ordering (tps) | Verification (tps) | Commit (tps) | Endorsing (ms) | Ordering (ms) | Verification (ms) | Commit (ms) |
|-----|-----------------|----------------|--------------------|--------------|----------------|---------------|-------------------|-------------|
| 50  |                 |                |                    |              |                |               |                   |             |
| 100 |                 |                |                    |              |                |               |                   |             |
| 150 |                 |                |                    |              |                |               |                   |             |
| 200 |                 |                |                    |              |                |               |                   |             |
| 250 |                 |                |                    |              |                |               |                   |             |
| 300 |                 |                |                    |              |                |               |                   |             |
| 350 |                 |                |                    |              |                |               |                   |             |
| 400 |                 |                |                    |              |                |               |                   |             |
| 450 |                 |                |                    |              |                |               |                   |             |
| 500 |                 |                |                    |              |                |               |                   |             |


**Round 4:**

| TAR | Endorsing (tps) | Ordering (tps) | Verification (tps) | Commit (tps) | Endorsing (ms) | Ordering (ms) | Verification (ms) | Commit (ms) |
|-----|-----------------|----------------|--------------------|--------------|----------------|---------------|-------------------|-------------|
| 50  |                 |                |                    |              |                |               |                   |             |
| 100 |                 |                |                    |              |                |               |                   |             |
| 150 |                 |                |                    |              |                |               |                   |             |
| 200 |                 |                |                    |              |                |               |                   |             |
| 250 |                 |                |                    |              |                |               |                   |             |
| 300 |                 |                |                    |              |                |               |                   |             |
| 350 |                 |                |                    |              |                |               |                   |             |
| 400 |                 |                |                    |              |                |               |                   |             |
| 450 |                 |                |                    |              |                |               |                   |             |
| 500 |                 |                |                    |              |                |               |                   |             |


**Round 5:**

| TAR | Endorsing (tps) | Ordering (tps) | Verification (tps) | Commit (tps) | Endorsing (ms) | Ordering (ms) | Verification (ms) | Commit (ms) |
|-----|-----------------|----------------|--------------------|--------------|----------------|---------------|-------------------|-------------|
| 50  |                 |                |                    |              |                |               |                   |             |
| 100 |                 |                |                    |              |                |               |                   |             |
| 150 |                 |                |                    |              |                |               |                   |             |
| 200 |                 |                |                    |              |                |               |                   |             |
| 250 |                 |                |                    |              |                |               |                   |             |
| 300 |                 |                |                    |              |                |               |                   |             |
| 350 |                 |                |                    |              |                |               |                   |             |
| 400 |                 |                |                    |              |                |               |                   |             |
| 450 |                 |                |                    |              |                |               |                   |             |
| 500 |                 |                |                    |              |                |               |                   |             |

#### 9.2. Throughput and Latency of 1500-Bytes Transactions with Endorsing Policy "OR"

**Round 1:**

| TAR | Endorsing (tps) | Ordering (tps) | Verification (tps) | Commit (tps) | Endorsing (ms) | Ordering (ms) | Verification (ms) | Commit (ms) |
|-----|-----------------|----------------|--------------------|--------------|----------------|---------------|-------------------|-------------|
| 50  |                 |                |                    |              |                |               |                   |             |
| 100 |                 |                |                    |              |                |               |                   |             |
| 150 |                 |                |                    |              |                |               |                   |             |
| 200 |                 |                |                    |              |                |               |                   |             |
| 250 |                 |                |                    |              |                |               |                   |             |
| 300 |                 |                |                    |              |                |               |                   |             |
| 350 |                 |                |                    |              |                |               |                   |             |
| 400 |                 |                |                    |              |                |               |                   |             |
| 450 |                 |                |                    |              |                |               |                   |             |
| 500 |                 |                |                    |              |                |               |                   |             |

**Round 2:**

| TAR | Endorsing (tps) | Ordering (tps) | Verification (tps) | Commit (tps) | Endorsing (ms) | Ordering (ms) | Verification (ms) | Commit (ms) |
|-----|-----------------|----------------|--------------------|--------------|----------------|---------------|-------------------|-------------|
| 50  |                 |                |                    |              |                |               |                   |             |
| 100 |                 |                |                    |              |                |               |                   |             |
| 150 |                 |                |                    |              |                |               |                   |             |
| 200 |                 |                |                    |              |                |               |                   |             |
| 250 |                 |                |                    |              |                |               |                   |             |
| 300 |                 |                |                    |              |                |               |                   |             |
| 350 |                 |                |                    |              |                |               |                   |             |
| 400 |                 |                |                    |              |                |               |                   |             |
| 450 |                 |                |                    |              |                |               |                   |             |
| 500 |                 |                |                    |              |                |               |                   |             |


**Round 3:**

| TAR | Endorsing (tps) | Ordering (tps) | Verification (tps) | Commit (tps) | Endorsing (ms) | Ordering (ms) | Verification (ms) | Commit (ms) |
|-----|-----------------|----------------|--------------------|--------------|----------------|---------------|-------------------|-------------|
| 50  |                 |                |                    |              |                |               |                   |             |
| 100 |                 |                |                    |              |                |               |                   |             |
| 150 |                 |                |                    |              |                |               |                   |             |
| 200 |                 |                |                    |              |                |               |                   |             |
| 250 |                 |                |                    |              |                |               |                   |             |
| 300 |                 |                |                    |              |                |               |                   |             |
| 350 |                 |                |                    |              |                |               |                   |             |
| 400 |                 |                |                    |              |                |               |                   |             |
| 450 |                 |                |                    |              |                |               |                   |             |
| 500 |                 |                |                    |              |                |               |                   |             |


**Round 4:**

| TAR | Endorsing (tps) | Ordering (tps) | Verification (tps) | Commit (tps) | Endorsing (ms) | Ordering (ms) | Verification (ms) | Commit (ms) |
|-----|-----------------|----------------|--------------------|--------------|----------------|---------------|-------------------|-------------|
| 50  |                 |                |                    |              |                |               |                   |             |
| 100 |                 |                |                    |              |                |               |                   |             |
| 150 |                 |                |                    |              |                |               |                   |             |
| 200 |                 |                |                    |              |                |               |                   |             |
| 250 |                 |                |                    |              |                |               |                   |             |
| 300 |                 |                |                    |              |                |               |                   |             |
| 350 |                 |                |                    |              |                |               |                   |             |
| 400 |                 |                |                    |              |                |               |                   |             |
| 450 |                 |                |                    |              |                |               |                   |             |
| 500 |                 |                |                    |              |                |               |                   |             |


**Round 5:**

| TAR | Endorsing (tps) | Ordering (tps) | Verification (tps) | Commit (tps) | Endorsing (ms) | Ordering (ms) | Verification (ms) | Commit (ms) |
|-----|-----------------|----------------|--------------------|--------------|----------------|---------------|-------------------|-------------|
| 50  |                 |                |                    |              |                |               |                   |             |
| 100 |                 |                |                    |              |                |               |                   |             |
| 150 |                 |                |                    |              |                |               |                   |             |
| 200 |                 |                |                    |              |                |               |                   |             |
| 250 |                 |                |                    |              |                |               |                   |             |
| 300 |                 |                |                    |              |                |               |                   |             |
| 350 |                 |                |                    |              |                |               |                   |             |
| 400 |                 |                |                    |              |                |               |                   |             |
| 450 |                 |                |                    |              |                |               |                   |             |
| 500 |                 |                |                    |              |                |               |                   |             |

#### 9.3. Throughput and Latency of 3000-Bytes Transactions with Endorsing Policy "OR"

**Round 1:**

| TAR | Endorsing (tps) | Ordering (tps) | Verification (tps) | Commit (tps) | Endorsing (ms) | Ordering (ms) | Verification (ms) | Commit (ms) |
|-----|-----------------|----------------|--------------------|--------------|----------------|---------------|-------------------|-------------|
| 50  |                 |                |                    |              |                |               |                   |             |
| 100 |                 |                |                    |              |                |               |                   |             |
| 150 |                 |                |                    |              |                |               |                   |             |
| 200 |                 |                |                    |              |                |               |                   |             |
| 250 |                 |                |                    |              |                |               |                   |             |
| 300 |                 |                |                    |              |                |               |                   |             |
| 350 |                 |                |                    |              |                |               |                   |             |
| 400 |                 |                |                    |              |                |               |                   |             |
| 450 |                 |                |                    |              |                |               |                   |             |
| 500 |                 |                |                    |              |                |               |                   |             |

**Round 2:**

| TAR | Endorsing (tps) | Ordering (tps) | Verification (tps) | Commit (tps) | Endorsing (ms) | Ordering (ms) | Verification (ms) | Commit (ms) |
|-----|-----------------|----------------|--------------------|--------------|----------------|---------------|-------------------|-------------|
| 50  |                 |                |                    |              |                |               |                   |             |
| 100 |                 |                |                    |              |                |               |                   |             |
| 150 |                 |                |                    |              |                |               |                   |             |
| 200 |                 |                |                    |              |                |               |                   |             |
| 250 |                 |                |                    |              |                |               |                   |             |
| 300 |                 |                |                    |              |                |               |                   |             |
| 350 |                 |                |                    |              |                |               |                   |             |
| 400 |                 |                |                    |              |                |               |                   |             |
| 450 |                 |                |                    |              |                |               |                   |             |
| 500 |                 |                |                    |              |                |               |                   |             |


**Round 3:**

| TAR | Endorsing (tps) | Ordering (tps) | Verification (tps) | Commit (tps) | Endorsing (ms) | Ordering (ms) | Verification (ms) | Commit (ms) |
|-----|-----------------|----------------|--------------------|--------------|----------------|---------------|-------------------|-------------|
| 50  |                 |                |                    |              |                |               |                   |             |
| 100 |                 |                |                    |              |                |               |                   |             |
| 150 |                 |                |                    |              |                |               |                   |             |
| 200 |                 |                |                    |              |                |               |                   |             |
| 250 |                 |                |                    |              |                |               |                   |             |
| 300 |                 |                |                    |              |                |               |                   |             |
| 350 |                 |                |                    |              |                |               |                   |             |
| 400 |                 |                |                    |              |                |               |                   |             |
| 450 |                 |                |                    |              |                |               |                   |             |
| 500 |                 |                |                    |              |                |               |                   |             |


**Round 4:**

| TAR | Endorsing (tps) | Ordering (tps) | Verification (tps) | Commit (tps) | Endorsing (ms) | Ordering (ms) | Verification (ms) | Commit (ms) |
|-----|-----------------|----------------|--------------------|--------------|----------------|---------------|-------------------|-------------|
| 50  |                 |                |                    |              |                |               |                   |             |
| 100 |                 |                |                    |              |                |               |                   |             |
| 150 |                 |                |                    |              |                |               |                   |             |
| 200 |                 |                |                    |              |                |               |                   |             |
| 250 |                 |                |                    |              |                |               |                   |             |
| 300 |                 |                |                    |              |                |               |                   |             |
| 350 |                 |                |                    |              |                |               |                   |             |
| 400 |                 |                |                    |              |                |               |                   |             |
| 450 |                 |                |                    |              |                |               |                   |             |
| 500 |                 |                |                    |              |                |               |                   |             |


**Round 5:**

| TAR | Endorsing (tps) | Ordering (tps) | Verification (tps) | Commit (tps) | Endorsing (ms) | Ordering (ms) | Verification (ms) | Commit (ms) |
|-----|-----------------|----------------|--------------------|--------------|----------------|---------------|-------------------|-------------|
| 50  |                 |                |                    |              |                |               |                   |             |
| 100 |                 |                |                    |              |                |               |                   |             |
| 150 |                 |                |                    |              |                |               |                   |             |
| 200 |                 |                |                    |              |                |               |                   |             |
| 250 |                 |                |                    |              |                |               |                   |             |
| 300 |                 |                |                    |              |                |               |                   |             |
| 350 |                 |                |                    |              |                |               |                   |             |
| 400 |                 |                |                    |              |                |               |                   |             |
| 450 |                 |                |                    |              |                |               |                   |             |
| 500 |                 |                |                    |              |                |               |                   |             |

#### 9.4. Throughput and Latency of 1-Byte Transactions with Endorsing Policy "AND"

**Round 1:**

| TAR | Endorsing (tps) | Ordering (tps) | Verification (tps) | Commit (tps) | Endorsing (ms) | Ordering (ms) | Verification (ms) | Commit (ms) |
|-----|-----------------|----------------|--------------------|--------------|----------------|---------------|-------------------|-------------|
| 50  |                 |                |                    |              |                |               |                   |             |
| 100 |                 |                |                    |              |                |               |                   |             |
| 150 |                 |                |                    |              |                |               |                   |             |
| 200 |                 |                |                    |              |                |               |                   |             |
| 250 |                 |                |                    |              |                |               |                   |             |
| 300 |                 |                |                    |              |                |               |                   |             |
| 350 |                 |                |                    |              |                |               |                   |             |
| 400 |                 |                |                    |              |                |               |                   |             |
| 450 |                 |                |                    |              |                |               |                   |             |
| 500 |                 |                |                    |              |                |               |                   |             |

**Round 2:**

| TAR | Endorsing (tps) | Ordering (tps) | Verification (tps) | Commit (tps) | Endorsing (ms) | Ordering (ms) | Verification (ms) | Commit (ms) |
|-----|-----------------|----------------|--------------------|--------------|----------------|---------------|-------------------|-------------|
| 50  |                 |                |                    |              |                |               |                   |             |
| 100 |                 |                |                    |              |                |               |                   |             |
| 150 |                 |                |                    |              |                |               |                   |             |
| 200 |                 |                |                    |              |                |               |                   |             |
| 250 |                 |                |                    |              |                |               |                   |             |
| 300 |                 |                |                    |              |                |               |                   |             |
| 350 |                 |                |                    |              |                |               |                   |             |
| 400 |                 |                |                    |              |                |               |                   |             |
| 450 |                 |                |                    |              |                |               |                   |             |
| 500 |                 |                |                    |              |                |               |                   |             |


**Round 3:**

| TAR | Endorsing (tps) | Ordering (tps) | Verification (tps) | Commit (tps) | Endorsing (ms) | Ordering (ms) | Verification (ms) | Commit (ms) |
|-----|-----------------|----------------|--------------------|--------------|----------------|---------------|-------------------|-------------|
| 50  |                 |                |                    |              |                |               |                   |             |
| 100 |                 |                |                    |              |                |               |                   |             |
| 150 |                 |                |                    |              |                |               |                   |             |
| 200 |                 |                |                    |              |                |               |                   |             |
| 250 |                 |                |                    |              |                |               |                   |             |
| 300 |                 |                |                    |              |                |               |                   |             |
| 350 |                 |                |                    |              |                |               |                   |             |
| 400 |                 |                |                    |              |                |               |                   |             |
| 450 |                 |                |                    |              |                |               |                   |             |
| 500 |                 |                |                    |              |                |               |                   |             |


**Round 4:**

| TAR | Endorsing (tps) | Ordering (tps) | Verification (tps) | Commit (tps) | Endorsing (ms) | Ordering (ms) | Verification (ms) | Commit (ms) |
|-----|-----------------|----------------|--------------------|--------------|----------------|---------------|-------------------|-------------|
| 50  |                 |                |                    |              |                |               |                   |             |
| 100 |                 |                |                    |              |                |               |                   |             |
| 150 |                 |                |                    |              |                |               |                   |             |
| 200 |                 |                |                    |              |                |               |                   |             |
| 250 |                 |                |                    |              |                |               |                   |             |
| 300 |                 |                |                    |              |                |               |                   |             |
| 350 |                 |                |                    |              |                |               |                   |             |
| 400 |                 |                |                    |              |                |               |                   |             |
| 450 |                 |                |                    |              |                |               |                   |             |
| 500 |                 |                |                    |              |                |               |                   |             |


**Round 5:**

| TAR | Endorsing (tps) | Ordering (tps) | Verification (tps) | Commit (tps) | Endorsing (ms) | Ordering (ms) | Verification (ms) | Commit (ms) |
|-----|-----------------|----------------|--------------------|--------------|----------------|---------------|-------------------|-------------|
| 50  |                 |                |                    |              |                |               |                   |             |
| 100 |                 |                |                    |              |                |               |                   |             |
| 150 |                 |                |                    |              |                |               |                   |             |
| 200 |                 |                |                    |              |                |               |                   |             |
| 250 |                 |                |                    |              |                |               |                   |             |
| 300 |                 |                |                    |              |                |               |                   |             |
| 350 |                 |                |                    |              |                |               |                   |             |
| 400 |                 |                |                    |              |                |               |                   |             |
| 450 |                 |                |                    |              |                |               |                   |             |
| 500 |                 |                |                    |              |                |               |                   |             |

#### 9.5. Throughput and Latency of 1500-Bytes Transactions with Endorsing Policy "AND"

**Round 1:**

| TAR | Endorsing (tps) | Ordering (tps) | Verification (tps) | Commit (tps) | Endorsing (ms) | Ordering (ms) | Verification (ms) | Commit (ms) |
|-----|-----------------|----------------|--------------------|--------------|----------------|---------------|-------------------|-------------|
| 50  |                 |                |                    |              |                |               |                   |             |
| 100 |                 |                |                    |              |                |               |                   |             |
| 150 |                 |                |                    |              |                |               |                   |             |
| 200 |                 |                |                    |              |                |               |                   |             |
| 250 |                 |                |                    |              |                |               |                   |             |
| 300 |                 |                |                    |              |                |               |                   |             |
| 350 |                 |                |                    |              |                |               |                   |             |
| 400 |                 |                |                    |              |                |               |                   |             |
| 450 |                 |                |                    |              |                |               |                   |             |
| 500 |                 |                |                    |              |                |               |                   |             |

**Round 2:**

| TAR | Endorsing (tps) | Ordering (tps) | Verification (tps) | Commit (tps) | Endorsing (ms) | Ordering (ms) | Verification (ms) | Commit (ms) |
|-----|-----------------|----------------|--------------------|--------------|----------------|---------------|-------------------|-------------|
| 50  |                 |                |                    |              |                |               |                   |             |
| 100 |                 |                |                    |              |                |               |                   |             |
| 150 |                 |                |                    |              |                |               |                   |             |
| 200 |                 |                |                    |              |                |               |                   |             |
| 250 |                 |                |                    |              |                |               |                   |             |
| 300 |                 |                |                    |              |                |               |                   |             |
| 350 |                 |                |                    |              |                |               |                   |             |
| 400 |                 |                |                    |              |                |               |                   |             |
| 450 |                 |                |                    |              |                |               |                   |             |
| 500 |                 |                |                    |              |                |               |                   |             |


**Round 3:**

| TAR | Endorsing (tps) | Ordering (tps) | Verification (tps) | Commit (tps) | Endorsing (ms) | Ordering (ms) | Verification (ms) | Commit (ms) |
|-----|-----------------|----------------|--------------------|--------------|----------------|---------------|-------------------|-------------|
| 50  |                 |                |                    |              |                |               |                   |             |
| 100 |                 |                |                    |              |                |               |                   |             |
| 150 |                 |                |                    |              |                |               |                   |             |
| 200 |                 |                |                    |              |                |               |                   |             |
| 250 |                 |                |                    |              |                |               |                   |             |
| 300 |                 |                |                    |              |                |               |                   |             |
| 350 |                 |                |                    |              |                |               |                   |             |
| 400 |                 |                |                    |              |                |               |                   |             |
| 450 |                 |                |                    |              |                |               |                   |             |
| 500 |                 |                |                    |              |                |               |                   |             |


**Round 4:**

| TAR | Endorsing (tps) | Ordering (tps) | Verification (tps) | Commit (tps) | Endorsing (ms) | Ordering (ms) | Verification (ms) | Commit (ms) |
|-----|-----------------|----------------|--------------------|--------------|----------------|---------------|-------------------|-------------|
| 50  |                 |                |                    |              |                |               |                   |             |
| 100 |                 |                |                    |              |                |               |                   |             |
| 150 |                 |                |                    |              |                |               |                   |             |
| 200 |                 |                |                    |              |                |               |                   |             |
| 250 |                 |                |                    |              |                |               |                   |             |
| 300 |                 |                |                    |              |                |               |                   |             |
| 350 |                 |                |                    |              |                |               |                   |             |
| 400 |                 |                |                    |              |                |               |                   |             |
| 450 |                 |                |                    |              |                |               |                   |             |
| 500 |                 |                |                    |              |                |               |                   |             |


**Round 5:**

| TAR | Endorsing (tps) | Ordering (tps) | Verification (tps) | Commit (tps) | Endorsing (ms) | Ordering (ms) | Verification (ms) | Commit (ms) |
|-----|-----------------|----------------|--------------------|--------------|----------------|---------------|-------------------|-------------|
| 50  |                 |                |                    |              |                |               |                   |             |
| 100 |                 |                |                    |              |                |               |                   |             |
| 150 |                 |                |                    |              |                |               |                   |             |
| 200 |                 |                |                    |              |                |               |                   |             |
| 250 |                 |                |                    |              |                |               |                   |             |
| 300 |                 |                |                    |              |                |               |                   |             |
| 350 |                 |                |                    |              |                |               |                   |             |
| 400 |                 |                |                    |              |                |               |                   |             |
| 450 |                 |                |                    |              |                |               |                   |             |
| 500 |                 |                |                    |              |                |               |                   |             |

#### 9.6. Throughput and Latency of 3000-Bytes Transactions with Endorsing Policy "AND"

**Round 1:**

| TAR | Endorsing (tps) | Ordering (tps) | Verification (tps) | Commit (tps) | Endorsing (ms) | Ordering (ms) | Verification (ms) | Commit (ms) |
|-----|-----------------|----------------|--------------------|--------------|----------------|---------------|-------------------|-------------|
| 50  |                 |                |                    |              |                |               |                   |             |
| 100 |                 |                |                    |              |                |               |                   |             |
| 150 |                 |                |                    |              |                |               |                   |             |
| 200 |                 |                |                    |              |                |               |                   |             |
| 250 |                 |                |                    |              |                |               |                   |             |
| 300 |                 |                |                    |              |                |               |                   |             |
| 350 |                 |                |                    |              |                |               |                   |             |
| 400 |                 |                |                    |              |                |               |                   |             |
| 450 |                 |                |                    |              |                |               |                   |             |
| 500 |                 |                |                    |              |                |               |                   |             |

**Round 2:**

| TAR | Endorsing (tps) | Ordering (tps) | Verification (tps) | Commit (tps) | Endorsing (ms) | Ordering (ms) | Verification (ms) | Commit (ms) |
|-----|-----------------|----------------|--------------------|--------------|----------------|---------------|-------------------|-------------|
| 50  |                 |                |                    |              |                |               |                   |             |
| 100 |                 |                |                    |              |                |               |                   |             |
| 150 |                 |                |                    |              |                |               |                   |             |
| 200 |                 |                |                    |              |                |               |                   |             |
| 250 |                 |                |                    |              |                |               |                   |             |
| 300 |                 |                |                    |              |                |               |                   |             |
| 350 |                 |                |                    |              |                |               |                   |             |
| 400 |                 |                |                    |              |                |               |                   |             |
| 450 |                 |                |                    |              |                |               |                   |             |
| 500 |                 |                |                    |              |                |               |                   |             |


**Round 3:**

| TAR | Endorsing (tps) | Ordering (tps) | Verification (tps) | Commit (tps) | Endorsing (ms) | Ordering (ms) | Verification (ms) | Commit (ms) |
|-----|-----------------|----------------|--------------------|--------------|----------------|---------------|-------------------|-------------|
| 50  |                 |                |                    |              |                |               |                   |             |
| 100 |                 |                |                    |              |                |               |                   |             |
| 150 |                 |                |                    |              |                |               |                   |             |
| 200 |                 |                |                    |              |                |               |                   |             |
| 250 |                 |                |                    |              |                |               |                   |             |
| 300 |                 |                |                    |              |                |               |                   |             |
| 350 |                 |                |                    |              |                |               |                   |             |
| 400 |                 |                |                    |              |                |               |                   |             |
| 450 |                 |                |                    |              |                |               |                   |             |
| 500 |                 |                |                    |              |                |               |                   |             |


**Round 4:**

| TAR | Endorsing (tps) | Ordering (tps) | Verification (tps) | Commit (tps) | Endorsing (ms) | Ordering (ms) | Verification (ms) | Commit (ms) |
|-----|-----------------|----------------|--------------------|--------------|----------------|---------------|-------------------|-------------|
| 50  |                 |                |                    |              |                |               |                   |             |
| 100 |                 |                |                    |              |                |               |                   |             |
| 150 |                 |                |                    |              |                |               |                   |             |
| 200 |                 |                |                    |              |                |               |                   |             |
| 250 |                 |                |                    |              |                |               |                   |             |
| 300 |                 |                |                    |              |                |               |                   |             |
| 350 |                 |                |                    |              |                |               |                   |             |
| 400 |                 |                |                    |              |                |               |                   |             |
| 450 |                 |                |                    |              |                |               |                   |             |
| 500 |                 |                |                    |              |                |               |                   |             |


**Round 5:**

| TAR | Endorsing (tps) | Ordering (tps) | Verification (tps) | Commit (tps) | Endorsing (ms) | Ordering (ms) | Verification (ms) | Commit (ms) |
|-----|-----------------|----------------|--------------------|--------------|----------------|---------------|-------------------|-------------|
| 50  |                 |                |                    |              |                |               |                   |             |
| 100 |                 |                |                    |              |                |               |                   |             |
| 150 |                 |                |                    |              |                |               |                   |             |
| 200 |                 |                |                    |              |                |               |                   |             |
| 250 |                 |                |                    |              |                |               |                   |             |
| 300 |                 |                |                    |              |                |               |                   |             |
| 350 |                 |                |                    |              |                |               |                   |             |
| 400 |                 |                |                    |              |                |               |                   |             |
| 450 |                 |                |                    |              |                |               |                   |             |
| 500 |                 |                |                    |              |                |               |                   |             |

