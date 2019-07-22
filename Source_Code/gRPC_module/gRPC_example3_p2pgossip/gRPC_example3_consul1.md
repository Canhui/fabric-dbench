

## 1. 安装Consul

#### 1.1. 下载

根据Consul的[下载](https://www.consul.io/downloads.html) 文档，下载[consul_1.5.2_linux_amd64](https://releases.hashicorp.com/consul/1.5.2/consul_1.5.2_linux_amd64.zip)，命令如下，

解压，安装，

```shell
$ wget https://releases.hashicorp.com/consul/1.5.2/consul_1.5.2_linux_amd64.zip
$ unzip consul_1.5.2_linux_amd64.zip
$ rm -rf consul_1.5.2_linux_amd64.zip
$ sudo mv consul /usr/local/bin
```



## 2. 启动Bootstrap Server (& Server 1)

我们需要一台服务器来运行Bootstrap Server，该服务器负责充当整个cluster的管理员的身份。在第一台机器上运行，

```shell
# Method 1
$ consul agent -dev -bind 192.168.0.106 -advertise=192.168.0.106

# Method 2
$ consul agent -server -bootstrap -data-dir /tmp/consul -bind 192.168.0.106 -advertise=192.168.0.106
```

查看Peer Discovery，

```shell
$ consul members
```




## 3. 启动其他Servers without bootstrap(Server 2 & Server 3)

我们启动另外一台机器运行Server，

```shell
$ consul agent -server -data-dir /tmp/consul
```


Server 1添加Server 2为邻居节点，

```shell
$ consul join 192.168.0.103
```


然后，Server 1和Server 2均可以查询邻居节点如下，

```shell
$ consul members
Node      Address             Status  Type    Build  Protocol  DC   Segment
ubuntu00  192.168.0.103:8301  alive   server  1.5.2  2         dc1  <all>
ubuntu01  192.168.0.106:8301  alive   server  1.5.2  2         dc1  <all>
```
















## Reference

[1. Consul核心参考] https://www.digitalocean.com/community/tutorials/an-introduction-to-using-consul-a-service-discovery-system-on-ubuntu-14-04



[1. consul官方参考资料] https://www.consul.io/intro/index.html


[2. Consul membership control] https://howtodoinjava.com/spring-cloud/consul-service-registration-discovery/