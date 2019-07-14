## 1. 网络一: One Server One Client同一主机

#### 1.1. 网络规划

|        | IP/Port Number      |
|--------|---------------------|
| Server | 192.168.0.103:50051 |
| Client | 192.168.0.103:50051 |

<br />

#### 1.2. 源代码

上一篇文章gRPC_example0_installation成功安装配置gRPC之后，项目的路径如下，

```shell
$ cd $HOME/go/src/google.golang.org/grpc/examples/helloworld
```

其中，项目由于三个文件组成，其余文件均由这三文件产生。第一个文件是Client和Server的依赖文件(/helloworld/helloworld.proto)
```shell
$ cd $HOME/go/src/google.golang.org/grpc/examples/helloworld
$ cat /helloworld/helloworld.proto
```

第二个文件是Server端的源代码(/greeter_server/main.go)，
```shell
$ cd $HOME/go/src/google.golang.org/grpc/examples/helloworld
$ cat /greeter_server/main.go
```

第三个文件时Client端的源代码(/greeter_client/main.go)
```shell
$ cd $HOME/go/src/google.golang.org/grpc/examples/helloworld
$ cat /greeter_client/main.go
```

源代码全部不需要改动，Server端编译运行如下，
```shell
$ cd $HOME/go/src/google.golang.org/grpc/examples/helloworld
$ go run greeter_server/main.go
```

Client端编译运行如下，
```shell
$ cd $HOME/go/src/google.golang.org/grpc/examples/helloworld
$ go run greeter_client/main.go
```














<br />
<br />



## 2. 网络二: One Server One Client跨不同主机

#### 2.1. 网络规划

|        | IP/Port Number      |
|--------|---------------------|
| Server | 192.168.0.103:50051 |
| Client | 192.168.0.106:50051 |


<br />
<br />


## 3. 网络三: One Server Multi Clients跨不同主机

#### 3.1. 网络规划

|         | IP/Port Number      |
|---------|---------------------|
| Server  | 192.168.0.103:50051 |
| Client1 | 192.168.0.103:50051 |
| Client2 | 192.168.0.106:50051 |













## 参考资料

