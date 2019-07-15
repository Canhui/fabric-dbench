## 1. 新建项目'example2_file_transfer'

进入工作目录
```shell
$ cd $HOME/go/src/google.golang.org/grpc/examples
$ mkdir example2_file_transfer
$ cd example2_file_transfer
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
