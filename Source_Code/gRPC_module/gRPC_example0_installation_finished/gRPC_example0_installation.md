## 1. 依赖项

#### 1.1. Go
gRPC要求Go版本大于等于1.6.

```
$ go version
go version go1.12.7 linux/amd64
```

Go的安装配置参考作者的[博客](https://blog.csdn.net/Canhui_WANG/article/details/86648936)，其中，完整介绍了Go的源代码的/bin路径的配置，Go的默认工作路径的配置，Go的默认工作路径中的bin路径(区别于源代码中的bin路径)的配置————反复测试三大路径配置，全部通过。

注：如果后文Go的操作失败，请回[此处](https://blog.csdn.net/Canhui_WANG/article/details/86648936)参照Go的三大路径配置。配置成功之后，通过"go get + 相关Go模块"的命令安装缺失模块，比如，"go get github.com/pkg/errors"。




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
```




<br />
<br />

## 2. 测试(1/4):运行helloworld

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

## 3. 测试(2/4):了解项目依赖/编译关系

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
核心文件描述如下：第一个是Protocol Buffers v3编写的helloworld.proto文件。其中，/helloworld/helloworld.proto文件定义一些协议的方法。接着，protoc plugin for Go编译/helloworld/helloworld.proto文件生成/helloworld/helloworld.pb.go文件，如下，
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

## 4. 测试(3/4):修改源代码，重新编译运行

#### 4.1. 修改/helloworld/helloworld.proto文件

进入/helloworld文件夹
```shell
$ cd /$HOME/go/src/google.golang.org/grpc/examples/helloworld/helloworld
$ ls
helloworld.proto
```

原始helloworld.proto文件内容如下，

```go
syntax = "proto3";

option java_multiple_files = true;
option java_package = "io.grpc.examples.helloworld";
option java_outer_classname = "HelloWorldProto";

package helloworld;

// The greeting service definition.
service Greeter {
  // Sends a greeting
  rpc SayHello (HelloRequest) returns (HelloReply) {}
}

// The request message containing the user's name.
message HelloRequest {
  string name = 1;
}

// The response message containing the greetings
message HelloReply {
  string message = 1;
}
```

新增一个SayHelloAgain()函数到协议函数定义中，修改后helloworld.proto文件如下，

```go
syntax = "proto3";

option java_multiple_files = true;
option java_package = "io.grpc.examples.helloworld";
option java_outer_classname = "HelloWorldProto";

package helloworld;

// The greeting service definition.
service Greeter {
  // Sends a greeting
  rpc SayHello (HelloRequest) returns (HelloReply) {}
  // Sends another greeting
  rpc SayHelloAgain (HelloRequest) returns (HelloReply) {}
}

// The request message containing the user's name.
message HelloRequest {
  string name = 1;
}

// The response message containing the greetings
message HelloReply {
  string message = 1;
}
```

接着，protoc plugin for Go编译/helloworld/helloworld.proto文件生成/helloworld/helloworld.pb.go文件，如下，

```shell
$ cd $HOME/go/src/google.golang.org/grpc/examples/helloworld
$ protoc -I helloworld/ helloworld/helloworld.proto --go_out=plugins=grpc:helloworld
```


<br />

#### 4.2. 修改/greeter_server/main.go文件

然后，/greeter_server/main.go调用helloworld.pb.go文件的SayHelloAgain()函数。修改后的/greeter_server/main.go如下，

```go
package main

import (
    "context"
    "log"
    "net"

    "google.golang.org/grpc"
    pb "google.golang.org/grpc/examples/helloworld/helloworld"
)

const (
    port = ":50051"
)

// server is used to implement helloworld.GreeterServer.
type server struct{}

// SayHello implements helloworld.GreeterServer
func (s *server) SayHello(ctx context.Context, in *pb.HelloRequest) (*pb.HelloReply, error) {
    log.Printf("Received: %v", in.Name)
    return &pb.HelloReply{Message: "Hello " + in.Name}, nil
}

func (s *server) SayHelloAgain(ctx context.Context, in *pb.HelloRequest) (*pb.HelloReply, error) {
        return &pb.HelloReply{Message: "Hello again " + in.Name}, nil
}

func main() {
    lis, err := net.Listen("tcp", port)
    if err != nil {
        log.Fatalf("failed to listen: %v", err)
    }
    s := grpc.NewServer()
    pb.RegisterGreeterServer(s, &server{})
    if err := s.Serve(lis); err != nil {
        log.Fatalf("failed to serve: %v", err)
    }
}
```

<br />

#### 4.3. 修改/greeter_client/main.go文件

同样地，/greeter_client/main.go调用helloworld.pb.go文件的SayHelloAgain()函数。修改后的/greeter_client/main.go如下，

```go
package main

import (
    "context"
    "log"
    "os"
    "time"

    "google.golang.org/grpc"
    pb "google.golang.org/grpc/examples/helloworld/helloworld"
)

const (
    address     = "localhost:50051"
    defaultName = "world"
)

func main() {
    // Set up a connection to the server.
    conn, err := grpc.Dial(address, grpc.WithInsecure())
    if err != nil {
        log.Fatalf("did not connect: %v", err)
    }
    defer conn.Close()
    c := pb.NewGreeterClient(conn)

    // Contact the server and print out its response.
    name := defaultName
    if len(os.Args) > 1 {
        name = os.Args[1]
    }
    ctx, cancel := context.WithTimeout(context.Background(), time.Second)
    defer cancel()
    r, err := c.SayHello(ctx, &pb.HelloRequest{Name: name})
    if err != nil {
        log.Fatalf("could not greet: %v", err)
    }
    log.Printf("Greeting: %s", r.Message)
        r, err = c.SayHelloAgain(ctx, &pb.HelloRequest{Name: name})
    if err != nil {
            log.Fatalf("could not greet: %v", err)
    }
    log.Printf("Greeting: %s", r.Message)
}
```

<br />

#### 4.4. 运行

进入目标文件夹

```shell
$ cd /$HOME/go/src/google.golang.org/grpc/examples/helloworld
```

运行server，

```shell
$ go run greeter_server/main.go
```

运行client,

```shell
$ go run greeter_client/main.go
2019/07/12 14:48:04 Greeting: Hello world
2019/07/12 14:48:04 Greeting: Hello again world
```


<br />
<br />

## 5. 测试(4/4):自定义路径，修改源代码，重新编译运行

#### 5.1. 自定义项目工作路径
创建example1_ipport挂载到路径`/$HOME/go/src/google.golang.org/grpc/examples`。

```
$ mkdir /$HOME/go/src/google.golang.org/grpc/examples/example1_ipport
$ cd example1_ipport
```

<br />

#### 5.2. 新建helloworld.proto文件
新建/example1_ipport/helloworld/helloworld.proto文件，内容如下，

```go
syntax = "proto3";

package helloworld;

// The greeting service definition.
service Greeter {
  // Sends a greeting
  rpc SayHello (HelloRequest) returns (HelloReply) {}
  // Sends another greeting
  rpc SayHelloAgain (HelloRequest) returns (HelloReply) {}
}

// The request message containing the user's name.
message HelloRequest {
  string name = 1;
}

// The response message containing the greetings
message HelloReply {
  string message = 1;
}
```

protoc plugin for Go编译/helloworld/helloworld.proto文件生成/helloworld/helloworld.pb.go文件，如下，

```shell
$ cd $HOME/go/src/google.golang.org/grpc/examples/example1_ipport
$ protoc -I helloworld helloworld/helloworld.proto --go_out=plugins=grpc:helloworld
```


<br />

#### 5.3. 新建/greeter_server/main.go文件
新建/example1_ipport/greeter_server/main.go文件，内容如下，

```go
package main

import (
        "context"
        "log"
        "net"

        "google.golang.org/grpc"
        pb "google.golang.org/grpc/examples/example1_ipport/helloworld"
)

const (
        port = ":50051"
)

// server is used to implement helloworld.GreeterServer.
type server struct{}

// SayHello implements helloworld.GreeterServer
func (s *server) SayHello(ctx context.Context, in *pb.HelloRequest) (*pb.HelloReply, error) {
        log.Printf("Received: %v", in.Name)
        return &pb.HelloReply{Message: "Hello " + in.Name}, nil
}

func (s *server) SayHelloAgain(ctx context.Context, in *pb.HelloRequest) (*pb.HelloReply, error) {
        return &pb.HelloReply{Message: "Hello again " + in.Name}, nil
}

func main() {
        lis, err := net.Listen("tcp", port)
        if err != nil {
                log.Fatalf("failed to listen: %v", err)
        }
        s := grpc.NewServer()
        pb.RegisterGreeterServer(s, &server{})
        if err := s.Serve(lis); err != nil {
                log.Fatalf("failed to serve: %v", err)
        }
}
```

注意修改Protocol Buffer v3代码所在的绝对路径`pb "google.golang.org/grpc/examples/example1_ipport/helloworld"`。



<br />

#### 5.4. 新建/greeter_client/main.go文件
新建/example1_ipport/greeter_client/main.go文件，内容如下，

```go
package main

import (
    "context"
    "log"
    "os"
    "time"

    "google.golang.org/grpc"
    pb "google.golang.org/grpc/examples/example1_ipport/helloworld"
)

const (
    address     = "localhost:50051"
    defaultName = "world"
)

func main() {
    // Set up a connection to the server.
    conn, err := grpc.Dial(address, grpc.WithInsecure())
    if err != nil {
        log.Fatalf("did not connect: %v", err)
    }
    defer conn.Close()
    c := pb.NewGreeterClient(conn)

    // Contact the server and print out its response.
    name := defaultName
    if len(os.Args) > 1 {
        name = os.Args[1]
    }
    ctx, cancel := context.WithTimeout(context.Background(), time.Second)
    defer cancel()
    r, err := c.SayHello(ctx, &pb.HelloRequest{Name: name})
    if err != nil {
        log.Fatalf("could not greet: %v", err)
    }
    log.Printf("Greeting: %s", r.Message)
        r, err = c.SayHelloAgain(ctx, &pb.HelloRequest{Name: name})
    if err != nil {
            log.Fatalf("could not greet: %v", err)
    }
    log.Printf("Greeting: %s", r.Message)
}
```

同样地，注意修改Protocol Buffer v3代码所在的绝对路径`pb "google.golang.org/grpc/examples/example1_ipport/helloworld"`。



<br />

#### 5.5. 调试运行

进入目标文件夹

```shell
$ cd /$HOME/go/src/google.golang.org/grpc/examples/example1_ipport
```

运行server，

```shell
$ go run greeter_server/main.go
```

运行client,

```shell
$ go run greeter_client/main.go
2019/07/12 14:48:04 Greeting: Hello world
2019/07/12 14:48:04 Greeting: Hello again world
```


<br />
<br />

## 参考资料
[1. gRPC offigical installation] https://grpc.io/docs/quickstart/go/
[2. gRPC中文文档] https://chai2010.gitbooks.io/advanced-go-programming-book/content/ch4-rpc/readme.html
[3. 释放TCP端口] https://stackoverflow.com/questions/11583562/how-to-kill-a-process-running-on-particular-port-in-linux

<br />

#### 备注
[备注一] 初稿，2019年07月12号。