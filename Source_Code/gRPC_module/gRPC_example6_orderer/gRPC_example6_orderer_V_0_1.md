T=0: server阻塞式地监听来自client的请求。

T=1: client发送一个请求给server。
T=2: client关闭发送。

T=3: server中断阻塞式监听。
T=4: server持续发送响应。

T=5: client持续接收来自server的响应。

--------------------------------------------------------------------------

Q1: client端有没有缓冲区，存放来自server的响应？server的响应丢了怎么办？
Q2: server如何根据client发送的信息的类型予以不同的回复？

--------------------------------------------------------------------------

## 1.1. orderer.proto

源代码如下，

```go
syntax = "proto3";

package orderer;

service StreamService {
    //rpc List(StreamRequest) returns (stream StreamResponse) {};
    //rpc Record(stream StreamRequest) returns (StreamResponse) {};
    rpc Route(stream StreamRequest) returns (stream StreamResponse) {};
}

message StreamPoint {
    //string name = 1;
    //int32 value = 2;
    string key = 1;
    string value = 2;
}

message StreamRequest {
    StreamPoint pt = 1;
}

message StreamResponse {
    StreamPoint pt = 1;
}
```

编译协议文件如下，

protoc -I proto/ proto/orderer.proto --go_out=plugins=grpc:proto




## 1.2. orderer.go

源代码如下，

```go
package main

import (
    "log"
    "net"
    "io"
    "strconv"
    "google.golang.org/grpc"
    pb "google.golang.org/grpc/examples/example6_orderer/proto"
)

type StreamService struct{}

const (
    PORT = "9002"
)

func (s *StreamService) Route(stream pb.StreamService_RouteServer) error {
    // Blocking read until CloseSend() from client side
    r, err := stream.Recv()
    if err == io.EOF {
        return nil
    }
    if err != nil {
        return err
    }
    log.Printf("stream.Recv pt.name: %s, pt.value: %s", r.Pt.Key, r.Pt.Value)
    // Continuously send messages from server side to client side 
    for n := 0; n <= 9; n++ {
        err_send := stream.Send(&pb.StreamResponse{
            Pt: &pb.StreamPoint{
                Key:  "gPRC Stream Client: Key",
                Value: "this is value"+strconv.Itoa(100),
            },
        })
        if err_send != nil {
            return err_send
        }
    }
    for n := 0; n <= 9; n++ {
        err_send := stream.Send(&pb.StreamResponse{
            Pt: &pb.StreamPoint{
                Key:  "gPRC Stream Client: Key",
                Value: "this is value"+strconv.Itoa(101),
            },
        })
        if err_send != nil {
            return err_send
        }
    }

    return nil
}

func main() {
    server := grpc.NewServer()
    pb.RegisterStreamServiceServer(server, &StreamService{})

    lis, err := net.Listen("tcp", ":"+PORT)
    if err != nil {
        log.Fatalf("net.Listen err: %v", err)
    }
    server.Serve(lis)
}
```

## 1.2. anchor_peer1.go

源代码如下，

```go
package main

import (
    "log"
    "io"
    "context"
    "google.golang.org/grpc"
    pb "google.golang.org/grpc/examples/example6_orderer/proto"
)

const (
    PORT = "9002"
)

func connectOrderer(client pb.StreamServiceClient, r *pb.StreamRequest) error {
    // client setup one context
    stream, err := client.Route(context.Background())
    if err != nil {
        return err
    }
    // client send one request and stream.CloseSend()
    err = stream.Send(r)
    if err != nil {
        return err
    }
    stream.CloseSend()
    // client only receive NINE responses from the forever server
    for n := 0; n <= 20; n++ {
        resp, err := stream.Recv()
        if err == io.EOF {
            break
        }
        if err != nil {
            return err
        }
        log.Printf("resp: pj.name: %s, pt.value: %s", resp.Pt.Key, resp.Pt.Value)
    }
    return nil
}

func main() {
    conn, err := grpc.Dial(":"+PORT, grpc.WithInsecure())
    if err != nil {
        log.Fatalf("grpc.Dial err: %v", err)
    }
    defer conn.Close()
    client := pb.NewStreamServiceClient(conn)

    err = connectOrderer(client, &pb.StreamRequest{Pt: &pb.StreamPoint{Key: "hello", Value: "world"}})
    if err != nil {
        log.Fatalf("printLists.err: %v", err)
    }
}
```