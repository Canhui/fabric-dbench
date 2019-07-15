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














proto编译方式如下

```shell
~/go/src/google.golang.org/grpc/examples/filetransfer-via-grpc$ protoc -I pb/ pb/transfer.proto --go_out=plugins=grpc:pb
```





## 参考资料

[1. Github文件传输] https://github.com/nandakumar111/filetransfer-via-grpc





[1. Github gRPC核心项目] https://github.com/ZacharyZYH/grpcTransfer
[2. gRPC message 传输] https://alexandreesl.com/2017/05/02/grpc-transporting-massive-data-with-googles-serialization/

[2. Github gRPC sharding的项目] https://github.com/johanbrandhorst/chunker
[3. Github gRPC sharding chunks的项目] https://jbrandhorst.com/post/grpc-binary-blob-stream/
