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



















从Hyperledger Fabric获取本地的文件系统中的Block File

Read block data from local file system blog: https://blog.csdn.net/weixin_34342992/article/details/87449350


从Hyperledger Fabric获取Transaction信息


TX/Blk的格式如下: https://blockchain-fabric.blogspot.com/2017/04/hyperledger-fabric-v10-block-structure.html


读取Hyperledger Block Data的官方英文原文: http://www.programmersought.com/article/3087804573/

读取Hyperledger Block Data的中文原文: https://www.jianshu.com/p/5e6cbdfe2657


KVLedger官方函数文档: https://godoc.org/github.com/hyperledger/fabric/core/ledger/kvledger

https://gowalker.org/github.com/hyperledger/fabric/core/ledger/kvledger



