## 1. Get client IP

工作目录

```shell
cd /home/joe/go/src/google.golang.org/grpc/examples/example5_clientIP
mkdir service
```

#### 1.1. .proto文件

```go
syntax = "proto3";
package hello; // go namespace

message HelloRequest { // HelloRequest -- protocol message definition
    string name = 1; // =1 -- the tag for identifing each element in a message structure 
}

message HelloReply {
    string message = 1;
}

service Greeter { // Greeter -- service that uses the protocol message defined before
    rpc SayHello (HelloRequest) returns (HelloReply) {}
}
```

编译成Go代码库，供server和client调用，如下，
```shell
$ protoc -I service/ service/service.proto --go_out=plugins=grpc:service
```

#### 1.2. server文件

```go
package main

import (
    "context"
    "log"
    "net"
    //"strings"
    "google.golang.org/grpc"
    "google.golang.org/grpc/peer"
    pb "google.golang.org/grpc/examples/example5_clientIP/service"
)

const (
    port = ":50051"
)

// server is used to implement helloworld.GreeterServer.
type server struct{}

// SayHello implements helloworld.GreeterServer
func (s *server) SayHello(ctx context.Context, in *pb.HelloRequest) (*pb.HelloReply, error) {
    log.Printf("Received: %v", in.Name)
    //loginip := strings.Split(ctx.Request.RemoteAddr, ":")[0]
    //log.Printlf(loginip)
    //log.Printlf(ctx.peer())
    pr, ok := peer.FromContext(ctx)
    if !ok {
        log.Printf("failed to get peer from ctx")
    } else {
        //log.Printf(uint(pr.Addr))
        log.Printf(pr.Addr.String())
        //log.Printf(""+pr.Addr.(*net.TCPAddr).Port)
        //log.Printf(pr.Addr)
    }
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


#### 1.3. client文件

```go
package main
import (
    "context"
    "log"
    "os"
    "time"
    "google.golang.org/grpc"
    pb "google.golang.org/grpc/examples/example5_clientIP/service"
)

const (
    address = "192.168.0.103:50051"
    defaultName = "world"
)

func main() {
    // set up a connection to the server
    conn, err := grpc.Dial(address, grpc.WithInsecure())
    if err != nil {
        log.Fatalf("fail to connect to server: %v", err)
    }
    defer conn.Close()
    c := pb.NewGreeterClient(conn)

    // construct the response and contact the server
    value := defaultName
    if len(os.Args) > 1 {
        value = os.Args[1]
    }
    ctx, cancel := context.WithTimeout(context.Background(), time.Second)
    defer cancel()
    r, err := c.SayHello(ctx, &pb.HelloRequest{Name: value})
    if err != nil {
        log.Fatalf("fail to greet: %v", err)
    }
    log.Printf("Greeting from server side: %s", r.Message)
}
```



## 2. 其他

处理字符串IP地址：删除端口号，获取纯粹的IP地址。如下，

```go
package main
import( 
    "fmt"
    "strings"
)

func main() {
    ip := "192.168.0.103:50051"
    comma := strings.Index(ip, ":")
    fmt.Println(ip[:comma])
}
```







## 参考资料
[1. 获取客户端IP参考] https://groups.google.com/forum/#!topic/grpc-io/UodEY4N78Sk
[2. 获取客户端IP] https://github.com/grpc/grpc-go/blob/c962da7be9c620c4a19158d978d1bf995c480098/test/end2end_test.go#L138
[3. 获取客户端IP] https://godoc.org/google.golang.org/grpc/peer


