## 1. Multiple-Clients Connections

https://stackoverflow.com/questions/53564748/how-do-i-force-my-grpc-client-to-open-multiple-connections-to-the-server


## 2. golang concurrent Channels

example: https://blog.narenarya.in/concurrent-http-in-go.html

https://stackoverflow.com/questions/53564748/how-do-i-force-my-grpc-client-to-open-multiple-connections-to-the-server



channel让main线程等待client线程

https://stackoverflow.com/questions/49393106/trying-to-understand-the-use-of-channel-in-grpc-client-in-golang

multiple connections的客户端设置如下，




```go
package main

import (
    "context"
    "log"
//    "os"
    "time"

    "google.golang.org/grpc"
    pb "google.golang.org/grpc/examples/example5_multiclis/proto"
)

const (
    address     = "192.168.0.106:50051"
    defaultName = "world"
)

func main() {
    // Set up first connection to the server.
    conn1, err1 := grpc.Dial("192.168.0.106:50051", grpc.WithInsecure())
    if err1 != nil {
        log.Fatalf("did not connect: %v", err1)
    }
    defer conn1.Close()
    c1 := pb.NewGreeterClient(conn1)

    // Contact the server and print out its response.
    ctx, cancel := context.WithTimeout(context.Background(), time.Second)
    defer cancel()
    r1, err1 := c1.SayHello(ctx, &pb.HelloRequest{Name: defaultName})
    if err1 != nil {
        log.Fatalf("could not greet: %v", err1)
    }
    log.Printf("Greeting: %s", r1.Message)

    // Set up second connection to the server
    conn2, err2 := grpc.Dial("192.168.0.103:50051", grpc.WithInsecure())
    if err2 != nil {
        log.Fatalf("did not connect: %v", err2)
    }
    defer conn2.Close()
    c2 := pb.NewGreeterClient(conn2)

    // Contact the server and print out its response.
    ctx2, cancel2 := context.WithTimeout(context.Background(), time.Second)
    defer cancel2()
    r2, err2 := c2.SayHello(ctx2, &pb.HelloRequest{Name: defaultName})
    if err2 != nil {
        log.Fatalf("could not greet: %v", err2)
    }
    log.Printf("Greeting: %s", r2.Message)
}
```


