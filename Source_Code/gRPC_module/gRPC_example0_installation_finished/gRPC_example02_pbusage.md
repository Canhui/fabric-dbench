## 1. Golang "import" Usage

#### 1.1. example: helloworld

新建工作路径

```shell
$ cd $GOPATH/src
$ mkdir example1
$ cd example1
$ touch main.go
$ mkdir lib
$ cd lib
$ touch lib.go
```

lib.go内容如下，

```go
package lib
import (
    "fmt"
)

func Test() {
    fmt.Println("helloworld from lib.Test()")
}
```

main.go调用lib.go，如下，
```go
package main
import {
    "example1/lib"
}

func main() {
    lib.Test()
}
```

测试如下，

```shell
~/go/src/example1$ go run main.go
helloworld from lib.Test()
```

<br />

#### 1.2. example: interface 

新建工作路径

```shell
$ cd $GOPATH/src
$ mkdir example2
$ cd example2
$ touch main.go
$ mkdir lib
$ cd lib
$ touch lib.go
```

lib.go内容如下，

```go
package lib

type Geometry interface{ // The Geometry interface
    Area() float64
    Perim() float64
}
```

main.go调用lib.go，实现接口的所有方法，如下，

```go
package main
import (
    "fmt"
    "example2/lib"
)

type Rectangle struct{ // Optional: Define Rectangle's own Data Structure
    width, height float64
}

func (r Rectangle) Area() float64 { // Must: Implement the first function of the interface
    return r.width * r.height
}

func (r Rectangle) Perim() float64 { // Must: Implement the second function of the interface
    return 2*r.width + 2*r.height
}

func main() {
    r := Rectangle{width:3, height:4}
    fmt.Println(lib.Geometry.Area(r)) // Optional: use the first function of the interface
    //fmt.Println(lib.Geometry.Perim(r)) // Optional: use the second function of the interface
}
```

测试如下，

```shell
~/go/src/example2$ go run main.go
12
```

<br />

#### 1.3. example: gRPC

新建工作路径

```shell
$ cd $HOME/go/src/google.golang.org/grpc/examples
$ mkdir example0_interface
$ touch $HOME/go/src/google.golang.org/grpc/examples/example0_interface/lib/lib.proto
$ touch $HOME/go/src/google.golang.org/grpc/examples/example0_interface/server/main.go
$ touch $HOME/go/src/google.golang.org/grpc/examples/example0_interface/client/main.go
```

lib/lib.proto内容如下，

```go
syntax = "proto3";
package lib; // go namespace

message HelloRequest {
    string Name = 1;
}

message HelloReply {
    string Reply = 1;
}

service Greeter {
    rpc SayHello (HelloRequest) returns (HelloReply) {}
}
```

编译lib/lib.proto文件如下，

```shell
$ protoc -I lib/ lib/lib.proto --go_out=plugins=grpc:lib
```

<br />

server/main.go内容如下。服务端实现interface中的SayHello()函数。

```go
package main

import (
    "context"
    "google.golang.org/grpc"
    "net"
    "log"
    pb "google.golang.org/grpc/examples/example0_interface/lib"
)

const (
    port = ":50051"
)

type data struct{}

// Implement SayHello() function of interface Greeter
func (d *data) SayHello(ctx context.Context, in_var *pb.HelloRequest)(*pb.HelloReply, error){
    log.Printf("Received at server side: %v", in_var.Name)
    return &pb.HelloReply{Reply:"Hello" + in_var.Name}, nil
}

func main(){
    lis, err := net.Listen("tcp", port)
    if err != nil{
        log.Fatalf("fail to listen: %v", err)
    }

    s := grpc.NewServer()
    pb.RegisterGreeterServer(s, &data{})
    if err := s.Serve(lis); err != nil {
        log.Fatalf("fail to serve: %v", err)
    }
}
```




<br />

client/main.go内容如下，客户端连接服务端，请求服务端的SayHello()函数。

```go
package main
import (
    "context"
    "log"
    "os"
    "time"
    "google.golang.org/grpc"
    pb "google.golang.org/grpc/examples/example0_interface/lib"
)

const (
    address = "localhost:50051"
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
    log.Printf("Greeting from server side: %s", r.Reply)
}
```





















<br />
<br />

## 备注
[备注一] 初稿, 2019年07月18号。