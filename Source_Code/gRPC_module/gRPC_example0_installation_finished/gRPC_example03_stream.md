## 1. example0_stream项目

#### 1.1. 工作路径

新建工作路径如下，

```shell
$ cd $HOME/go/src/google.golang.org/grpc/examples
$ mkdir example0_stream
$ cd example0_stream
```

#### 1.2. .proto文件

新建.proto文件


```shell
$ cd example0_stream
$ mkdir hello
$ cd hello
$ vi hello.proto
```

```go
syntax = "proto3";

package hello;

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

编译.proto文件

```shell
$ cd example0_stream
$ protoc -I hello/ hello/hello.proto --go_out=plugins=grpc:hello
```

<br />

#### 1.3. 修改/server/main.go文件

新建工作路径如下，

```shell
$ cd example0_stream
$ mkdir server
$ cd server
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
    pb "google.golang.org/grpc/examples/example0_stream/hello"
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

#### 1.4. 修改/client/main.go文件

新建工作路径如下，

```shell
$ cd example0_stream
$ mkdir client
$ cd client
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
    pb "google.golang.org/grpc/examples/example0_stream/hello"
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
}
```

<br />
<br />

## 2. stream example0_stream项目

#### 2.1. 修改.proto文件

```go
syntax = "proto3";

package hello;

// The greeting service definition.
service Greeter {
  // Sends a greeting
  rpc SayHello (HelloRequest) returns (stream HelloReply) {}
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

编译.proto文件

```shell
$ cd example0_stream
$ protoc -I hello/ hello/hello.proto --go_out=plugins=grpc:hello
```




<br />
<br />

## 参考资料
[1. gRPC Stream] https://colobu.com/2017/04/06/dive-into-gRPC-streaming/
