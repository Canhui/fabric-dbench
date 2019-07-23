## 1. Server-Side Streaming RPC

#### 1.1. /stream/stream.proto文件

新建文件

```shell
$ vi $HOME/go/src/google.golang.org/grpc/examples/example0_stream/stream/stream.proto
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

编译文件

```shell
$ cd $HOME/go/src/google.golang.org/grpc/examples/example0_stream
$ protoc -I stream/ stream/stream.proto --go_out=plugins=grpc:stream
```




<br />

#### 1.2. /server/main.go文件

新建文件

```shell
$ vi $HOME/go/src/google.golang.org/grpc/examples/example0_stream/server/main.go
```

```go
package main

import (
    "log"
    "net"
    "google.golang.org/grpc"
    "time"
    pb "google.golang.org/grpc/examples/example0_stream/stream"
)

type StreamService struct{}

const (
    PORT = "9002"
)

func (s *StreamService) List(r *pb.StreamRequest, stream pb.StreamService_ListServer) error {
    for n := 0; n <= 6; n++ {
        time.Sleep(2*time.Second)
        err := stream.Send(&pb.StreamResponse{
            Pt: &pb.StreamPoint{
                Name:  r.Pt.Name,
                Value: r.Pt.Value + int32(n),
            },
        })
        if err != nil {
            return err
        }
    }

    return nil
}

//func (s *StreamService) List(r *pb.StreamRequest, stream pb.StreamService_ListServer) error {
//    return nil
//}

func (s *StreamService) Record(stream pb.StreamService_RecordServer) error {
    return nil
}

func (s *StreamService) Route(stream pb.StreamService_RouteServer) error {
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


<br />

#### 1.3. /client/main.go文件

新建文件

```shell
$ vi $HOME/go/src/google.golang.org/grpc/examples/example0_stream/client/main.go
```

```go
package main

import (
    "log"
    "io"
    "context"
    "google.golang.org/grpc"
    pb "google.golang.org/grpc/examples/example0_stream/stream"
    //pb "github.com/EDDYCJY/go-grpc-example/proto"
)

const (
    PORT = "9002"
)

func printLists(client pb.StreamServiceClient, r *pb.StreamRequest) error {
    stream, err := client.List(context.Background(), r)
    if err != nil {
        return err
    }

    for {
        resp, err := stream.Recv()
        if err == io.EOF {
            break
        }
        if err != nil {
            return err
        }

        if resp.Pt.Value == 2018 {
            log.Printf("yes")
        } else {
            log.Printf("resp: pj.name: %s, pt.value: %d", resp.Pt.Name, resp.Pt.Value)
        }
    }

    return nil
}

//func printLists(client pb.StreamServiceClient, r *pb.StreamRequest) error {
//    return nil
//}

func printRecord(client pb.StreamServiceClient, r *pb.StreamRequest) error {
    return nil
}

func printRoute(client pb.StreamServiceClient, r *pb.StreamRequest) error {
    return nil
}


func main() {
    conn, err := grpc.Dial(":"+PORT, grpc.WithInsecure())
    if err != nil {
        log.Fatalf("grpc.Dial err: %v", err)
    }
    defer conn.Close()
    client := pb.NewStreamServiceClient(conn)

    err = printLists(client, &pb.StreamRequest{Pt: &pb.StreamPoint{Name: "gRPC Stream Client: List", Value: 2018}})
    if err != nil {
        log.Fatalf("printLists.err: %v", err)
    }

    err = printRecord(client, &pb.StreamRequest{Pt: &pb.StreamPoint{Name: "gRPC Stream Client: Record", Value: 2018}})
    if err != nil {
        log.Fatalf("printRecord.err: %v", err)
    }

    err = printRoute(client, &pb.StreamRequest{Pt: &pb.StreamPoint{Name: "gRPC Stream Client: Route", Value: 2018}})
    if err != nil {
        log.Fatalf("printRoute.err: %v", err)
    }
}
```








<br />
<br />

## 2. Client-Side Streaming RPC










<br />
<br />

## 3. Bidiretional Streaming RPC 






<br />
<br />

## Reference











项目：joe@ubuntu01:~/go/src/google.golang.org/grpc/examples/example0_stream/client$

博客：https://segmentfault.com/a/1190000016503114


<br />
<br />

## 参考资料
[1. gRPC Stream] https://colobu.com/2017/04/06/dive-into-gRPC-streaming/
[2. gRPC Stream examples (tonight)] https://segmentfault.com/a/1190000016503114
[3. gRPC official stream] https://www.grpc.io/docs/tutorials/basic/go/
[4. gRPC stream perfect blog] https://rakyll.org/grpc-streaming/
