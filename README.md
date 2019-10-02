**Fabric-DBench** is a distributed benchmark platform for Hyperledger Fabric.



## 1. Prerequirements

#### 1.1. Hyperledger Fabric v1.4.0

Install the Hyperledger Fabric v1.4.0 according to the [Hyperledger Fabric official website](https://github.com/hyperledger/fabric). 


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

#### 1.3. Prepare the Kafka/Zookeeper Cluster

Here we need to write something to setup the kafka/zookeeper cluster.





## 2. Setup

#### 2.1. Download fabric-dbench from Github

Download the source code to your `$HOME` directory

```shell
$ cd $HOME
$ git clone https://github.com/Canhui/fabric-dbench.git
```


#### 2.2. Copy fabric-samples to fabric-dbench

Copy the `fabric-samples` to the directory of `$HOME/fabric-dbench`

```shell
$ cd $HOME
$ cp -r fabric-samples $HOME/fabric-dbench
```




## 3. Usage of `bin/step1_config_cluster.sh`

#### 3.1. Config the Network (e.g., of 3 organizations)

Go to `$HOME/fabric-dbench/bin` and config the `step1_config_cluster.sh` file
```shell
Hostname="t716"
Password="T716rrs722"
Number_of_Organizations=3
```

then config the network
```shell
$ ./step1_config_cluster.sh
```

Go to `$home/fabric-dbench/solo/orderer` directory and setup the orderer
```shell
$ cd $home/fabric-dbench/solo/orderer
$ sudo ./orderer
```

Go to `$home/fabric-dbench/solo/peer` directory and setup the peer
```shell
$ cd $home/fabric-dbench/solo/peer
$ sudo ./peer node start
```

## 4. Usage of `bin/step2_config_admins.sh`

#### 4.1. Config the Adminstrators (e.g., of 3 organizations)

Go to `$HOME/fabric-dbench/bin` and config the `step2_config_admins.sh` file
```shell
Number_of_Organizations=3
```

then config the administrators 
```shell
$ ./step2_config_admins.sh
```

Go to `$HOME/fabric-dbench/Admin@org1.example.com` directory and check the adminstrator of the first organization
```shell
$ cd $HOME/fabric-dbench/Admin@org1.example.com
$ ./peer.sh node status
```

Go to `$HOME/fabric-dbench/Admin@org2.example.com` directory and check the adminstrator of the second organization
```shell
$ cd $HOME/fabric-dbench/Admin@org2.example.com
$ ./peer.sh node status
```

Go to `$HOME/fabric-dbench/Admin@org3.example.com` directory and check the adminstrator of the second organization
```shell
$ cd $HOME/fabric-dbench/Admin@org3.example.com
$ ./peer.sh node status
```







<!-- ## 3. Usage of `step2_config_admins.sh`

#### 3.1. Config Admins (e.g., of 3 organizations)

Config the `step2_config_admins.sh` file
```shell
Number_of_Organizations=3
```

Config the admins
```shell
./step2_config_admins.sh
```

Check the admins
```shell
cd fabric-dbench/Admin@org1.example.com
./peer.sh node status
```

Clean the configuration files
```shell
./step2_cleanup.sh
``` -->




