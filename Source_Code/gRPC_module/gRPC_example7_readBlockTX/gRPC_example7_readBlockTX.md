## 1. 读取文件的权限控制

第一步

```shell
$ sudo chown -R "$USER:" /path/to/the/directory
```

第二步

```shell
$ chmod -R 700 /path/to/the/directory
```

这个步骤的核心参考资料: https://askubuntu.com/questions/466605/cannot-open-output-file-permission-denied




## 2. 读取分割Hyperledger的Block Data和Transaction Data

根据之前博客教程，逐步运行Hyperledger Fabric系统之后，读取整个系统的生成的原始Block Data。

Ubuntutu00工作路径
```shell
$ cd /home/joe/go/src/readBlock
```

源代码

```go
package main
 
import (
       "os"
       "fmt"
       "io"
       "io/ioutil"
       "bufio"
       "errors"
       "encoding/base64"
 
       "github.com/golang/protobuf/proto"
       "github.com/hyperledger/fabric/protos/common"
 lutil "github.com/hyperledger/fabric/common/ledger/util"
 putil "github.com/hyperledger/fabric/protos/utils"
)
 
var ErrUnexpectedEndOfBlockfile = errors.New("unexpected end of blockfile")
 
var (
    file        *os.File
    fileName    string
    fileSize    int64
    fileOffset  int64
    fileReader  *bufio.Reader
)
 
// Parse a block
func handleBlock(block * common.Block) {
    fmt.Printf("Block: Number=[%d], CurrentBlockHash=[%s], PreviousBlockHash=[%s]\n",
        block.GetHeader().Number,
        base64.StdEncoding.EncodeToString(block.GetHeader().DataHash),
        base64.StdEncoding.EncodeToString(block.GetHeader().PreviousHash))
 
    if putil.IsConfigBlock(block) {
        fmt.Printf("    txid=CONFIGBLOCK\n")
    } else {
        for _, txEnvBytes := range block.GetData().GetData() {
            if txid, err := extractTxID(txEnvBytes); err != nil {
                fmt.Printf("ERROR: Cannot extract txid, error=[%v]\n", err)
                return
            } else {
                fmt.Printf("    txid=%s\n", txid)
            }
        }
    }
 
    // write block to file
    b, err := proto.Marshal(block)
    if err != nil {
        fmt.Printf("ERROR: Cannot marshal block, error=[%v]\n", err)
        return
    }
 
    filename := fmt.Sprintf("block%d.block", block.GetHeader().Number)
    if err := ioutil.WriteFile(filename, b, 0644); err != nil {
        fmt.Printf("ERROR: Cannot write block to file:[%s], error=[%v]\n", filename, err)
    }
 
    // Then you could use utility to read block content, like:
    // $ configtxlator proto_decode --input block0.block --type common.Block
}
 
func nextBlockBytes() ([]byte, error) {
    var lenBytes []byte
    var err error
 
    // At the end of file
    if fileOffset == fileSize {
        return nil, nil
    }
 
    remainingBytes := fileSize - fileOffset
    peekBytes := 8
    if remainingBytes < int64(peekBytes) {
        peekBytes = int(remainingBytes)
    }
    if lenBytes, err = fileReader.Peek(peekBytes); err != nil {
        return nil, err
    }
 
    length, n := proto.DecodeVarint(lenBytes)
    if n == 0 {
        return nil, fmt.Errorf("Error in decoding varint bytes [%#v]", lenBytes)
    }
 
    bytesExpected := int64(n) + int64(length)
    if bytesExpected > remainingBytes {
        return nil, ErrUnexpectedEndOfBlockfile
    }
 
    // skip the bytes representing the block size
    if _, err = fileReader.Discard(n); err != nil {
        return nil, err
    }
 
    blockBytes := make([]byte, length)
    if _, err = io.ReadAtLeast(fileReader, blockBytes, int(length)); err != nil {
        return nil, err
    }
 
    fileOffset += int64(n) + int64(length)
    return blockBytes, nil
}
 
func deserializeBlock(serializedBlockBytes []byte) (*common.Block, error) {
    block := &common.Block{}
    var err error
    b := lutil.NewBuffer(serializedBlockBytes)
    if block.Header, err = extractHeader(b); err != nil {
        return nil, err
    }
    if block.Data, err = extractData(b); err != nil {
        return nil, err
    }
    if block.Metadata, err = extractMetadata(b); err != nil {
        return nil, err
    }
    return block, nil
}
 
func extractHeader(buf *lutil.Buffer) (*common.BlockHeader, error) {
    header := &common.BlockHeader{}
    var err error
    if header.Number, err = buf.DecodeVarint(); err != nil {
        return nil, err
    }
    if header.DataHash, err = buf.DecodeRawBytes(false); err != nil {
        return nil, err
    }
    if header.PreviousHash, err = buf.DecodeRawBytes(false); err != nil {
        return nil, err
    }
    if len(header.PreviousHash) == 0 {
        header.PreviousHash = nil
    }
    return header, nil
}
 
func extractData(buf *lutil.Buffer) (*common.BlockData, error) {
    data := &common.BlockData{}
    var numItems uint64
    var err error
 
    if numItems, err = buf.DecodeVarint(); err != nil {
        return nil, err
    }
    for i := uint64(0); i < numItems; i++ {
        var txEnvBytes []byte
        if txEnvBytes, err = buf.DecodeRawBytes(false); err != nil {
            return nil, err
        }
        data.Data = append(data.Data, txEnvBytes)
    }
    return data, nil
}
 
func extractMetadata(buf *lutil.Buffer) (*common.BlockMetadata, error) {
    metadata := &common.BlockMetadata{}
    var numItems uint64
    var metadataEntry []byte
    var err error
    if numItems, err = buf.DecodeVarint(); err != nil {
        return nil, err
    }
    for i := uint64(0); i < numItems; i++ {
        if metadataEntry, err = buf.DecodeRawBytes(false); err != nil {
            return nil, err
        }
        metadata.Metadata = append(metadata.Metadata, metadataEntry)
    }
    return metadata, nil
}
 
func extractTxID(txEnvelopBytes []byte) (string, error) {
    txEnvelope, err := putil.GetEnvelopeFromBlock(txEnvelopBytes)
    if err != nil {
        return "", err
    }
    txPayload, err := putil.GetPayload(txEnvelope)
    if err != nil {
        return "", nil
    }
    chdr, err := putil.UnmarshalChannelHeader(txPayload.Header.ChannelHeader)
    if err != nil {
        return "", err
    }
    return chdr.TxId, nil
}
 
 
func main() {
    
    //fileName = "hyperledger/production/ledgersData/chains/chains/mychannel/blockfile_000000"
    fileName = "/opt/app/fabric/peer/data/ledgersData/chains/chains/mychannel/blockfile_000000"

    var err error
    if file, err = os.OpenFile(fileName, os.O_RDONLY, 0600); err != nil {
        fmt.Printf("ERROR: Cannot Open file: [%s], error=[%v]\n", fileName, err)
        return
    }
    defer file.Close()
 
 
    if fileInfo, err := file.Stat(); err != nil {
        fmt.Printf("ERROR: Cannot Stat file: [%s], error=[%v]\n", fileName, err)
        return
    } else {
        fileOffset = 0
        fileSize   = fileInfo.Size()
        fileReader = bufio.NewReader(file)
    }
 
    // Loop each block
    for {
        if blockBytes, err := nextBlockBytes(); err != nil {
            fmt.Printf("ERROR: Cannot read block file: [%s], error=[%v]\n", fileName, err)
            break
        } else if blockBytes == nil {
            // End of file
            break
        } else {
            if block, err := deserializeBlock(blockBytes); err != nil {
                fmt.Printf("ERROR: Cannot deserialize block from file: [%s], error=[%v]\n", fileName, err)
                break
            } else {
                handleBlock(block)
            }
        }
    }
}
```






## 3. 下一步，读取TX/Blk的每一个字节

configtxlator

https://www.jianshu.com/p/8954afbeed9d


读取block0.block每一个字节成json格式

```shell
$ /home/joe/fabric-samples/bin/configtxlator proto_decode --input block0.block --type common.Block
```


```shell
$ /home/joe/fabric-samples/bin/configtxlator proto_decode --type common.Block --input block4.block --output block4.json
```

encode格式如下

```shell
$ /home/joe/fabric-samples/bin/configtxlator proto_encode --type common.Block --input block4.json --output blockout.pb
```


block的格式如下：https://hyperledger-fabric.readthedocs.io/en/release-1.4/ledger/ledger.html


Q: Hyperledger Block中的metadata是怎么回事？

This section contains the time when the block was written, as well as the certificate, public key and signature of the block writer. Subsequently, the block committer also adds a valid or invalid indicator for every transaction, through this information is not included in the hash, as that is created when the block is created.







## 4. TO DO

#### 4.1. 关于Blockchain的区块格式

说明书

https://blockchain-fabric.blogspot.com/2017/04/hyperledger-fabric-v10-block-structure.html

实际试验

combine block4.json去进行分析，问题是如何分析json文件？结合协议进行分析。

参考在线JSON解析网址：https://c.runoob.com/front-end/53

目标：其一，论字节解析三个部分；其二，三大部分的依赖关系。


Fabric's block consists of three segments which are data, header and metadata.




#### 4.1.1. header

The header of each block consists of three items which are data_hash, number and previous_hash, where data_hsh is the hash of the data segment of the current block, number if the block number and previous_hash is the hash of the previous block's header.


代码参考： https://github.com/hyperledger/fabric/blob/release-1.4/protos/common/block.go

```go
type asn1Header struct {
    Number       int64
    PreviousHash []byte
    DataHash     []byte
}
```

采用SHA256生成hash。







#### 4.1.2. metadata


代码参考： https://github.com/hyperledger/fabric/blob/release-1.4/protos/common/common.proto


```go
type BlockMetadata struct {
    Metadata [][]byte 
}

// Metadata is a common structure to be used to encode block metadata
type Metadata struct {
    Value      []byte               
    Signatures []*MetadataSignature 
}

type MetadataSignature struct {
    SignatureHeader []byte 
    Signature       []byte 
}

type SignatureHeader struct {   
    Creator []byte 
    Nonce []byte 
}
```


下一步，metadata的具体代码？

This section contains the time when the block was written, as well as the certificate, public key and signature of the block writer. Subsequently

https://medium.com/@spsingh559/deep-dive-into-hyperledger-fabric-ledger-b7ecd671d55f












#### 4.1.3. data

signature + payload

其中payload分为data+header


hyperledger transaction verification?










整个数据结构去解析block4.json：https://github.com/XChainLab/documentation/blob/master/fabric/Fabric.block.data.structure.md




整个block的操作：https://yuan1028.github.io/fabric-commit-block/


























#### 关于所有的证书

Data部分
creator, id_bytes
endorsements, endorser
endorsements, signature
signature_header, id_bytes

Header部分
data_hash
previous_hash

Metadata部分
sig1
sig2











## Reference

从Hyperledger Fabric获取本地的文件系统中的Block File

Read block data from local file system blog: https://blog.csdn.net/weixin_34342992/article/details/87449350


从Hyperledger Fabric获取Transaction信息


TX/Blk的格式如下: https://blockchain-fabric.blogspot.com/2017/04/hyperledger-fabric-v10-block-structure.html


读取Hyperledger Block Data的官方英文原文: http://www.programmersought.com/article/3087804573/

读取Hyperledger Block Data的中文原文: https://www.jianshu.com/p/5e6cbdfe2657


KVLedger官方函数文档: https://godoc.org/github.com/hyperledger/fabric/core/ledger/kvledger

https://gowalker.org/github.com/hyperledger/fabric/core/ledger/kvledger



