## 1. P2P Helloworld例子

#### 1.1. 基础框架

Peer1有server和client两个部分。Peer1的server提供192.168.0.103的50000监听端口供其他Peers连接。Peer1的client连接其他Peers的server的IP和端口。


Peer2有server和client两个部分。Peer2的server提供192.168.0.106的50000监听端口供其他Peers连接。Peer2的client连接其他Peers的server的IP和端口。


#### 1.2. Peer1实现

进入工作目录，

```shell
$ cd /home/joe/go/src/google.golang.org/grpc/examples/example3_p2p
$ mkdir proto
```

example3_p2p/proto/proto.proto文件，如下，

```shell
$ cd proto
$ vi proto.proto
```

```go
syntax = "proto3";

package proto;

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

编译生成Golang文件如下，

```shell
$ protoc -I proto/ proto/proto.proto --go_out=plugins=grpc:proto
```


/example3_p2p/server.go代码如下，

```go
package main

import (
    "context"
    "log"
    "net"

    "google.golang.org/grpc"
    pb "google.golang.org/grpc/examples/example3_p2p/proto"
)

const (
    port = ":50000"
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

/example3_p2p/client.go代码如下，
```go
package main

import (
    "context"
    "log"
    "os"
    "time"

    "google.golang.org/grpc"
    pb "google.golang.org/grpc/examples/example3_p2p/proto"
)

const (
    address     = "localhost:50000"
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





下一步，我们开始讲P2P代码的实现。新建peer.go文件，该文件将整合server.go和client.go的所有功能，这意味着，每一个peer节点既可以作为server进行listen监听，又可以作为client接收来自其他server的数据。




新建bootstrap.go节点，bootstrap节点就是一个server节点。每一个peer.go节点首先连接bootstrap节点，从bootstrap节点获取其他peer的addr数据。bootstrap.go的代码如下，


```shell
$ vi /home/joe/go/src/google.golang.org/grpc/examples/example3_p2p/bootstrap.go
```

bootstrap节点的IP地址192.168.0.103，端口50000，

bootstrap.go的代码如下，

```go
package main

import (
    "context"
    "log"
    "net"

    "google.golang.org/grpc"
    pb "google.golang.org/grpc/examples/example3_p2p/proto"
)

const (
    port = ":50000"
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













新建peer1.go文件，peer1连接bootstrap.go节点，bootstrap.go记录下peer1的地址，端口信息。Peer1.go整合了server.go和client.go，如下，

```shell
$ vi /home/joe/go/src/google.golang.org/grpc/examples/example3_p2p/peer1.go
```

peer1节点服务端的IP地址192.168.0.103，端口50001；客户端连接IP地址192.168.0.103，端口50000.

```go
package main

import (
    "context"
    "log"
    "net"
    "time"
    "os"

    "google.golang.org/grpc"
    pb "google.golang.org/grpc/examples/example3_p2p/proto"
)

const (
    port = "192.168.0.103:50001"
    neighaddr = "192.168.0.103:50000"
    defaultName = "world"
)

// server is used to implement helloworld.GreeterServer.
type server struct{}

// SayHello implements helloworld.GreeterServer
func (s *server) SayHello(ctx context.Context, in *pb.HelloRequest) (*pb.HelloReply, error) {
    log.Printf("Received: %v", in.Name)
    return &pb.HelloReply{Message: "Hello " + in.Name}, nil
}

func listen(){
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

func main() {
    // server on 192.168.0.103:50001
    go listen()
    
    // client connect to bootstrap 192.168.0.103:50000
    conn, err := grpc.Dial(neighaddr, grpc.WithInsecure())
    if err != nil {
        log.Fatalf("did not connect: %v", err)
    }
    defer conn.Close()
    c := pb.NewGreeterClient(conn)

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

    time.Sleep(100*time.Second)
}
```













新建peer2.go文件，peer2.go连接peer1.go，peer1和peer2组成一个p2p网络。Peer2.go整合了server.go和client.go，如下，

```shell
$ vi /home/joe/go/src/google.golang.org/grpc/examples/example3_p2p/peer2.go
```




peer2节点服务端的IP地址192.168.0.106，端口50002；客户端连接IP地址

```go
package main

import (
    "context"
    "log"
    "net"
    "time"
    "os"

    "google.golang.org/grpc"
    pb "google.golang.org/grpc/examples/example3_p2p/proto"
)

const (
    port = "192.168.0.103:50002"
    neighaddr = "192.168.0.103:50001"
    defaultName = "world"
)

// server is used to implement helloworld.GreeterServer.
type server struct{}

// SayHello implements helloworld.GreeterServer
func (s *server) SayHello(ctx context.Context, in *pb.HelloRequest) (*pb.HelloReply, error) {
    log.Printf("Received: %v", in.Name)
    return &pb.HelloReply{Message: "Hello " + in.Name}, nil
}

func listen(){
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

func main() {
    // server on 192.168.0.103:50001
    go listen()
    
    // client connect to bootstrap 192.168.0.103:50000
    conn, err := grpc.Dial(neighaddr, grpc.WithInsecure())
    if err != nil {
        log.Fatalf("did not connect: %v", err)
    }
    defer conn.Close()
    c := pb.NewGreeterClient(conn)

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

    time.Sleep(100*time.Second)
}
```






























## 参考资料
[1. P2P核心代码Github项目] https://github.com/cpurta/p2p-grpc/blob/master/cmd/internal/server/node.go

