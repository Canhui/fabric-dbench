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

#### 2.2. `192.168.0.103`端源代码

新建项目`example1_multihosts_one_server_one_client`，如下，

```shell
$ cd $HOME/go/src/google.golang.org/grpc/examples
$ mkdir example1_multihosts_one_server_one_client
$ cd example1_multihosts_one_server_one_client
```

新建Server和Client的依赖文件`helloworld/helloworld.proto`，如下，

```shell
$ cd example1_multihosts_one_server_one_client
$ mkdir helloworld
$ touch helloworld.proto
$ vi helloworld.proto
```

```go
syntax = "proto3";

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

编译/helloworld/helloworld.proto文件生成/helloworld/helloworld.pb.go文件，如下，

```shell
$ cd $HOME/go/src/google.golang.org/grpc/examples/example1_multihosts_one_server_one_client
$ protoc -I helloworld helloworld/helloworld.proto --go_out=plugins=grpc:helloworld
```


新建Server端代码`greeter_server/main.go`，如下，
```shell
$ cd example1_multihosts_one_server_one_client
$ mkdir greeter_server
$ touch main.go
$ vi main.go
```

```go
package main

import (
    "context"
    "log"
    "net"

    "google.golang.org/grpc"
    pb "google.golang.org/grpc/examples/example1_multihosts_one_server_one_client/helloworld"
)

const (
    port = "192.168.0.106:50051"
)

// server is used to implement helloworld.GreeterServer.
type server struct{}

// SayHello implements helloworld.GreeterServer
func (s *server) SayHello(ctx context.Context, in *pb.HelloRequest) (*pb.HelloReply, error) {
    log.Printf("Received: %v", in.Name)
    return &pb.HelloReply{Message: "Hello " + in.Name}, nil
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

新建Client端代码`greeter_client/main.go`，如下，
```shell
$ cd example1_multihosts_one_server_one_client
$ mkdir greeter_client
$ touch main.go
$ vi main.go
```

```go
package main

import (
    "context"
    "log"
    "os"
    "time"

    "google.golang.org/grpc"
    pb "google.golang.org/grpc/examples/example1_multihosts_one_server_one_client/helloworld"
)

const (
    address     = "192.168.0.106:50051"
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
}
```


<br />

#### 2.3. `192.168.0.106`端源代码

新建项目`example1_multihosts_one_server_one_client`，如下，

```shell
$ cd $HOME/go/src/google.golang.org/grpc/examples
$ mkdir example1_multihosts_one_server_one_client
$ cd example1_multihosts_one_server_one_client
```

新建Server和Client的依赖文件`helloworld/helloworld.proto`，如下，

```shell
$ cd example1_multihosts_one_server_one_client
$ mkdir helloworld
$ touch helloworld.proto
$ vi helloworld.proto
```

```go
syntax = "proto3";

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

编译/helloworld/helloworld.proto文件生成/helloworld/helloworld.pb.go文件，如下，

```shell
$ cd $HOME/go/src/google.golang.org/grpc/examples/example1_multihosts_one_server_one_client
$ protoc -I helloworld helloworld/helloworld.proto --go_out=plugins=grpc:helloworld
```


新建Client端代码`greeter_client/main.go`，如下，
```shell
$ cd example1_multihosts_one_server_one_client
$ mkdir greeter_client
$ touch main.go
$ vi main.go
```

```go
package main

import (
    "context"
    "log"
    "os"
    "time"

    "google.golang.org/grpc"
    pb "google.golang.org/grpc/examples/example1_multihosts_one_server_one_client/helloworld"
)

const (
    address     = "192.168.0.106:50051"
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
}
```

<br />

#### 2.4. 调试运行

`192.168.0.103`进入目标文件夹，启动Server服务端，如下，
```shell
$ cd $HOME/go/src/google.golang.org/grpc/examples/example1_multihosts_one_server_one_client
$ go run greeter_server/main.go
```


`192.168.0.106`进入目标文件夹，启动Client客户端，如下，
```shell
$ cd $HOME/go/src/google.golang.org/grpc/examples/example1_multihosts_one_server_one_client
$ go run greeter_client/main.go
```



## 参考资料

