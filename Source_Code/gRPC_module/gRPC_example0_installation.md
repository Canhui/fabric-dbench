## 1. 依赖项

#### 1.1. Go
gRPC要求Go版本大于等于1.6.

```
$ go version
go version go1.12.7 linux/amd64
```

如果Go没有安装或者版本错误，参考[官方文档](https://golang.org/doc/install)。

<br />

#### 1.2. gRPC
使用下列命令安装gRPC(-go)。
```
$ go get -u google.golang.org/grpc
```

成功安装gRPC之后，也附带有gRPC examples于下列路径，

```
$ cd $GOPATH/src/google.golang.org/grpc/examples
$ ls
features  gotutorial.md  helloworld  README.md  route_guide
```



<br />

#### 1.3. Protocol Buffers v3
下载Protocol Buffers v3的编译后的二进制可执行文件，参考[官方文档](https://github.com/protocolbuffers/protobuf/releases)。

```shell
# Make sure you grab the latest version
curl -OL https://github.com/google/protobuf/releases/download/v3.2.0/protoc-3.2.0-linux-x86_64.zip

# Unzip
unzip protoc-3.2.0-linux-x86_64.zip -d protoc3

# Move protoc to /usr/local/bin/
sudo mv protoc3/bin/* /usr/local/bin/

# Move protoc3/include to /usr/local/include/
sudo mv protoc3/include/* /usr/local/include/
```

下载安装protoc plugin for Go，如下，

```shell
$ go get -u github.com/golang/protobuf/protoc-gen-go
$ export PATH=$PATH:$GOPATH/bin
```

<br />
<br />

## 2. 测试(1/3):运行helloworld

上述gRPC安装好之后，其examples文件夹存放于`$GOPATH/src/google.golang.org/grpc/examples`。进入该路径测试helloworld例子如下，

```shell
$ cd $GOPATH/src/google.golang.org/grpc/examples/helloworld
```

运行server端，
```shell
$ go run greeter_server/main.go
# server端等待请求中...
```

运行client端，
```shell
$ go run greeter_client/main.go
2019/07/12 11:40:13 Greeting: Hello world
```

与此同时，server端显示如下，
```shell
$ go run greeter_server/main.go
2019/07/12 11:40:13 Received: world
```

另外，如果出现端口无法绑定的问题，可以通过下列命令释放端口。比如，释放50051端口命令如下，
```shell
$ sudo fuser -k 50051/tcp
```

<br />
<br />

## 3. 测试(2/3):了解项目依赖/编译关系

#### 3.1. 删除非核心文件
删除非核心文件命令如下，
```shell
$ cd /home/joe/go/src/google.golang.org/grpc/examples/helloworld
$ rm -rf mock_helloworld
$ cd /home/joe/go/src/google.golang.org/grpc/examples/helloworld/helloworld
$ rm -rf helloworld.pb.go 
```

<br />

#### 3.2. 核心文件
核心文件描述如下：第一个是Protocol Buffers v3编写的helloworld.proto文件。其中，helloworld.proto文件定义一些协议的方法。接着，protoc plugin for Go编译helloworld.proto文件生成helloworld.pb.go文件，如下，
```shell
$ cd $HOME/go/src/google.golang.org/grpc/examples/helloworld
$ $ protoc -I helloworld/ helloworld/helloworld.proto --go_out=plugins=grpc:helloworld
```

其中，helloworld.pb.go文件提供函数给server端代码和client端代码使用。换句话说，server端代码和client端代码均使用helloworld.pb.go文件所提供函数，而helloworld.pb.go文件的函数由Protocol Buffers v3编写的helloworld.proto文件生成。注意，如果找不到protoc，可能是没有配置```export PATH=$PATH:$GOPATH/bin```。


第二个是/greeter_server/main.go服务端代码。
```shell
$ cd $HOME/go/src/google.golang.org/grpc/examples/helloworld/greeter_server
$ ls
main.go
```


第三个是/greeter_client/main.go客户端代码。

```shell
$ cd $HOME/go/src/google.golang.org/grpc/examples/helloworld/greeter_client
$ ls
main.go
```



<br />
<br />

## 4. 测试(3/3):修改源代码，重新编译运行












<br />
<br />

## 参考资料
[1. gRPC offigical installation] https://grpc.io/docs/quickstart/go/
[2. gRPC中文文档] https://chai2010.gitbooks.io/advanced-go-programming-book/content/ch4-rpc/readme.html
[3. 释放TCP端口] https://stackoverflow.com/questions/11583562/how-to-kill-a-process-running-on-particular-port-in-linux

<br />

#### 备注
[备注一] 初稿，2019年07月12号。