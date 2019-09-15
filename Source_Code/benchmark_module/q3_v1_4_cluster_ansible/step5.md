## 1. Solo Cluster Throughput

#### 1.1. 测试单机版本

启动first-network
```shell
$ echo [Y] | /home/t716/joe/fabric-samples/first-network/byfn.sh up
```

关闭first-network
```shell
$ echo [Y] | /home/t716/joe/fabric-samples/first-network/byfn.sh down
```

#### 1.2. Ansible配置hosts信息

```shell
$ sudo vi /etc/hosts
```

```shell
# ---------------------------------------------------------------------------
# Hyperledger Cluster Configuration - Pls contact chwang@comp.hkbu.edu.hk Thx.
# ---------------------------------------------------------------------------
192.168.0.101 orderer.example.com
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

