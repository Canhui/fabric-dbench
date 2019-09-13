静态配置的模式来运行下列语句。



## 1. 单机执行命令

#### 1.1. 所有的机器执行一条本地命令

```shell
$ ansible all -m command -a 'date'
```

#### 1.2. 所有的机器显示curl的版本信息

```shell
$ ansible all -m command -a 'curl --version'
```


## 1.3. 所有的机器显示go的版本信息

```shell
$ ansible all -m command -a 'go version'
```


---------------------------------------------------------


## 2. 分组执行命令

orderer组执行命令

```shell
$ ansible orderer -a 'date'
```

peer组执行命令

```shell
$ ansible peer -a 'date'
```

某个IP节点执行命令

```shell
$ ansible 192.168.0.103 -a 'date'
```

某几个IPs节点执行命令

```shell
$ ansible 192.168.0.101, 192.168.0.104 -a 'date'
```














