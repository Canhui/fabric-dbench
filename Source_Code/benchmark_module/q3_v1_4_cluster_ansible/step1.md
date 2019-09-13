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








