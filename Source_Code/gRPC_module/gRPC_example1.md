## 1. Hyperledger Consul Installation

*Step1:* 根据文档提示 https://learn.hashicorp.com/consul/getting-started/install.html 到官方 https://www.consul.io/downloads.html 地址下载zip安装包 https://releases.hashicorp.com/consul/1.5.2/consul_1.5.2_linux_amd64.zip ，如下，

```shell script
$ wget https://releases.hashicorp.com/consul/1.5.2/consul_1.5.2_linux_amd64.zip
```


*Step2:* 解压该文件夹，得到一个二进制可执行文件。

```shell script
$ unzip consul_1.5.2_linux_amd64.zip
$ rm -rf consul_1.5.2_linux_amd64.zip
```


*Step3:* 验证'consul'是否安装成功。
```shell script
$ mv consul /usr/bin
$ consul
Usage: consul [--version] [--help] <command> [<args>]

Available commands are:
    acl            Interact with Consul's ACLs
    agent          Runs a Consul agent
    watch          Watch for changes in Consul
```


<br />
<br />

## 2. gRPC P2P 代码






<br />
<br />

## 参考资料
[1. consul的安装方法] https://learn.hashicorp.com/consul/getting-started/install.html
[2. gRPC p2p Github] https://github.com/ChanderG/grpc-p2p

<br />

#### 备注
[备注一] 初稿，2019年07月11号。

