## 1. Bidirectional stream

客户端一直发送，服务端(每两秒回复一次)一直响应。

#### 1.1. .proto文件

```shell
$ cd stream
$ vi stream.proto
```

```go
syntax = "proto3";

package proto;

service StreamService {
    rpc List(StreamRequest) returns (stream StreamResponse) {};
    rpc Record(stream StreamRequest) returns (StreamResponse) {};
    rpc Route(stream StreamRequest) returns (stream StreamResponse) {};
}


message StreamPoint {
    string name = 1;
    int32 value = 2;
}

message StreamRequest {
    StreamPoint pt = 1;
}

message StreamResponse {
    StreamPoint pt = 1;
}
```

编译.proto文件

```shell
$ protoc -I stream/ stream/stream.proto --go_out=plugins=grpc:stream
```

#### 1.2. server.go文件

```go
package main

import (
    "log"
    "net"
    "io"
    "google.golang.org/grpc"
//    "time"
    pb "google.golang.org/grpc/examples/example3_serverside_stream/stream"
)

type StreamService struct{}

const (
    PORT = "9002"
)

func (s *StreamService) List(r *pb.StreamRequest, stream pb.StreamService_ListServer) error {
    return nil
}

//func (s *StreamService) List(r *pb.StreamRequest, stream pb.StreamService_ListServer) error {
//    for n := 0; n <= 6; n++ {
//        time.Sleep(2*time.Second)
//        err := stream.Send(&pb.StreamResponse{
//            Pt: &pb.StreamPoint{
//                Name:  r.Pt.Name,
//                Value: r.Pt.Value + int32(n),
//            },
//        })
//        if err != nil {
//            return err
//        }
//    }
//    return nil
//}


//func (s *StreamService) Record(stream pb.StreamService_RecordServer) error {
//    for {
//        r, err := stream.Recv()
//        if err == io.EOF {
//            return stream.SendAndClose(&pb.StreamResponse{Pt: &pb.StreamPoint{Name: "gRPC Stream Server: Record", Value: 1}})
//        }
//        if err != nil {
//            return err
//        }
//
//        log.Printf("stream.Recv pt.name: %s, pt.value: %d", r.Pt.Name, r.Pt.Value)
//    }
//
//    return nil
//}

func (s *StreamService) Record(stream pb.StreamService_RecordServer) error {
    return nil
}

//func (s *StreamService) Route(stream pb.StreamService_RouteServer) error {
//    return nil
//}

func (s *StreamService) Route(stream pb.StreamService_RouteServer) error {
    n := 0
    for {
        err := stream.Send(&pb.StreamResponse{
            Pt: &pb.StreamPoint{
                Name:  "gPRC Stream Client: Route",
                Value: int32(n),
            },
        })
        if err != nil {
            return err
        }
        r, err := stream.Recv()
        if err == io.EOF {
            return nil
        }
        if err != nil {
            return err
        }
        n++
        log.Printf("stream.Recv pt.name: %s, pt.value: %d", r.Pt.Name, r.Pt.Value)
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



#### 1.3. client.go文件

```go
package main

import (
    "log"
    "io"
    "context"
    "google.golang.org/grpc"
    pb "google.golang.org/grpc/examples/example3_serverside_stream/stream"
)

const (
    PORT = "9002"
)

func printRoute(client pb.StreamServiceClient, r *pb.StreamRequest) error {
    stream, err := client.Route(context.Background())
    if err != nil {
        return err
    }

    for n := 0; n <= 6; n++ {
        err = stream.Send(r)
        if err != nil {
            return err
        }

        resp, err := stream.Recv()
        if err == io.EOF {
            break
        }
        if err != nil {
            return err
        }

        log.Printf("resp: pj.name: %s, pt.value: %d", resp.Pt.Name, resp.Pt.Value)
    }

    stream.CloseSend()

    return nil
}

//func printRecord(client pb.StreamServiceClient, r *pb.StreamRequest) error {
//    stream, err := client.Record(context.Background())
//    if err != nil {
//        return err
//    }
//
//    for n := 0; n < 6; n++ {
//        err := stream.Send(r)
//        if err != nil {
//            return err
//        }
//    }
//
//    resp, err := stream.CloseAndRecv()
//    if err != nil {
//        return err
//    }
//
//    log.Printf("resp: pj.name: %s, pt.value: %d", resp.Pt.Name, resp.Pt.Value)
//
//    return nil
//}

//func printLists(client pb.StreamServiceClient, r *pb.StreamRequest) error {
//    stream, err := client.List(context.Background(), r)
//    if err != nil {
//        return err
//    }
//
//    for {
//        resp, err := stream.Recv()
//        if err == io.EOF {
//            break
//        }
//        if err != nil {
//            return err
//        }
//
//        if resp.Pt.Value == 2018 {
//            log.Printf("yes")
//        } else {
//            log.Printf("resp: pj.name: %s, pt.value: %d", resp.Pt.Name, resp.Pt.Value)
//        }
//    }
//
//    return nil
//}

func main() {
    conn, err := grpc.Dial(":"+PORT, grpc.WithInsecure())
    if err != nil {
        log.Fatalf("grpc.Dial err: %v", err)
    }
    defer conn.Close()
    client := pb.NewStreamServiceClient(conn)

    err = printRoute(client, &pb.StreamRequest{Pt: &pb.StreamPoint{Name: "gRPC Stream Client: List", Value: 2018}})
    if err != nil {
        log.Fatalf("printLists.err: %v", err)
    }
}
```