**Fabric-DBench** is a distributed benchmark platform for Hyperledger Fabric.



## 1. Prerequirements

#### 1.1. Hyperledger Fabric v1.4.0

Install the Hyperledger Fabric v1.4.0 according to the [Hyperledger Fabric official website](https://github.com/hyperledger/fabric) and ensure running `fabric-samples/first-network` successfully.



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


## 2. Setup

#### 2.1. Download fabric-dbench from Github

Download the source code to your `$HOME` directory

```shell
$ cd $HOME
$ git clone https://github.com/Canhui/fabric-dbench.git --branch release-v1.4.0-solo
```


#### 2.2. Add an execution authority to .sh files

```shell
$ cd $HOME/fabric-dbench/fabric-samples
$ sudo chmod +x *.sh
$ cd $HOME/fabric-dbench/fabric-samples/run
$ sudo chmod +x *.sh
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
$ sudo ./orderer
```


Go to `peer0.org1.example.com` node. Go to `$HOME/fabric-dbench/fabric-run/peer` directory. Setup the peer. 

```shell
$ cd $HOME/fabric-dbench/fabric-run/peer
$ sudo ./peer node start
```


Go to `peer0.org2.example.com` node. Go to `$HOME/fabric-dbench/fabric-run/peer` directory. Setup the peer. 

```shell
$ cd $HOME/fabric-dbench/fabric-run/peer
$ sudo ./peer node start
```


Go to `peer0.org3.example.com` node. Go to `$HOME/fabric-dbench/fabric-run/peer` directory. Setup the peer. 

```shell
$ cd $HOME/fabric-dbench/fabric-run/peer
$ sudo ./peer node start
```

**Note:** Modify `ORGS` of files `run/step1_5.sh`, `run/step1_7.sh` to add more peers.







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



./peer.sh chaincode invoke -o orderer.example.com:7050  --tls true --cafile ./tlsca.example.com-cert.pem -C mychannel1 -n demo1 -c '{"Args":["write","key1","key1valueisabc"]}'

./peer.sh chaincode query -C mychannel1 -n demo1 -c '{"Args":["query","key1"]}'

