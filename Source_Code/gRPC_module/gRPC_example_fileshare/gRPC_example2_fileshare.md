## 1. 新建项目'example2_file_transfer'

#### 1.1. 工作目录

进入工作目录
```shell
$ cd $HOME/go/src/google.golang.org/grpc/examples
$ mkdir example2_file_transfer
$ cd example2_file_transfer
```

<br />

#### 1.2. Protocol Buffer v3代码

新建目录transfer

```shell
$ cd $HOME/go/src/google.golang.org/grpc/examples/example2_file_transfer
$ cd transfer
$ touch transfer.proto
$ vi transfer.proto
```

```go
syntax = "proto3";

package transfer;

service GuploadService {
    rpc Upload(stream Chunk) returns (UploadStatus) {}
}

message Chunk {
    bytes Content = 1;
    string totalSize = 2;
    string received = 3;
}

enum UploadStatusCode {
    Unknown = 0;
    Ok = 1;
    Failed = 2;
}

message UploadStatus {
    string Message = 1;
    UploadStatusCode Code = 2;
}
```

protoc plugin for Go编译/transfer/transfer.proto文件生成/transfer/transfer.pb.go文件，如下，

```shell
$ cd $HOME/go/src/google.golang.org/grpc/examples/example2_file_transfer
$ protoc -I transfer/ transfer/transfer.proto --go_out=plugins=grpc:transfer
```

<br />

#### 1.3. receive_server代码

新建目录receive_server

```shell
$ cd $HOME/go/src/google.golang.org/grpc/examples/example2_file_transfer
$ mkdir receive_server
$ touch main.go
$ vi main.go
```

```go
package main

import (
    "fmt"
    "github.com/pkg/errors"
    "github.com/prometheus/common/log"
    "google.golang.org/grpc"
    "io"
    "net"
    "os"
    pb "google.golang.org/grpc/examples/example2_file_transfer/transfer"
)

const (
    port = "localhost:50051"
)

type server struct {
}

func (s *server) Upload(stream pb.GuploadService_UploadServer) (err error) {
    // open output file
    fo, err := os.Create("/home/joe/go/src/google.golang.org/grpc/examples/example2_file_transfer/receive_server/output.dmg")
    if err != nil {
        return errors.New("failed to create file")
    }
    // close fo on exit and check for its returned error
    defer func() {
        if err := fo.Close(); err != nil {
            panic(err)
        }
    }()
    var res *pb.Chunk
    for {
        res, err = stream.Recv()

        if err == io.EOF {
            err = stream.SendAndClose(&pb.UploadStatus{
                Message: "Upload received with success",
                Code:    pb.UploadStatusCode_Ok,
            })
            if err != nil {
                err =  errors.New("failed to send status code")
                return err
            }
            return nil
        }
        fmt.Println(res.Received)
        // write a chunk
        if _, err := fo.Write(res.Content); err != nil {
            err =  errors.New(err.Error())
            return err
        }
    }
}

func main(){
    lis, err := net.Listen("tcp", port)
    if err != nil {
        log.Fatalf("failed to listen: %v", err)
    }
    s := grpc.NewServer()

    pb.RegisterGuploadServiceServer(s, &server{})

    if err := s.Serve(lis); err != nil {
        log.Fatalf("failed to serve: %v", err)
    }
}
```


<br />

#### 1.4. sned_client代码

新建目录send_client
```shell
$ cd $HOME/go/src/google.golang.org/grpc/examples/example2_file_transfer
$ mkdir send_client
$ touch main.go
$ vi main.go
```

```go
package main

import (
    "context"
    "fmt"
    "github.com/pkg/errors"
    "github.com/prometheus/common/log"
    "google.golang.org/grpc"
    "io"
    "os"
    "strconv"
    pb "google.golang.org/grpc/examples/example2_file_transfer/transfer"
)

const (
    address     = "localhost:50051"
    defaultName = "world"
)

func main()  {
    conn, err := grpc.Dial(address, grpc.WithInsecure())
    if err != nil{
        log.Fatalf("didn't connect %v", err)
    }
    defer conn.Close()
    c := pb.NewGuploadServiceClient(conn)

    var (
        buf     []byte
        status  *pb.UploadStatus
    )
    // open input file
    fi, err := os.Open("/home/joe/go/src/google.golang.org/grpc/examples/example2_file_transfer/send_client/input.dmg")
    if err != nil {
        fmt.Println("Not able to open")
        return
    }

    stat, err := fi.Stat()
    if err != nil {
        return
    }
    // close fi on exit and check for its returned error
    defer func() {
        if err := fi.Close(); err != nil {
            fmt.Println("Not able to open")
            return
        }
    }()

    ctx := context.Background()
    stream, err := c.Upload(ctx)
    if err != nil {
        err = errors.Wrapf(err,
            "failed to create upload stream for file %s",
            fi)
        return
    }
    defer stream.CloseSend()

    buf = make([]byte,stat.Size())
    for {
        // read a chunk
        n, err := fi.Read(buf)
        if err != nil && err != io.EOF {
            err = errors.Wrapf(err,
                "failed to send chunk via stream")
            return
        }
        if n == 0 {
            break
        }
        var i int64
        for i = 0 ; i < ((stat.Size()/100)*100)  ; i += 100 {
            err = stream.Send(&pb.Chunk{
                Content: buf[i:i+100],
                TotalSize:strconv.FormatInt(stat.Size(), 10),
                Received:strconv.FormatInt(i+100, 10),
            })
        }
        if stat.Size()%100 > 0{
            err = stream.Send(&pb.Chunk{
                Content: buf[((stat.Size()/100)*100):((stat.Size()/100*100)+ (stat.Size()%100))],
                TotalSize:strconv.FormatInt(stat.Size(), 10),
                Received:string(stat.Size()%100),
            })
        }

        if err != nil {
            err = errors.Wrapf(err,
                "failed to send chunk via stream")
            return
        }
    }


    status, err = stream.CloseAndRecv()
    if err != nil {
        err = errors.Wrapf(err,
            "failed to receive upstream status response")
        return
    }

    if status.Code != pb.UploadStatusCode_Ok {
        err = errors.Errorf(
            "upload failed - msg: %s",
            status.Message)
        return
    }

    return

}
```









## 参考资料

[1. Github文件传输] https://github.com/nandakumar111/filetransfer-via-grpc






