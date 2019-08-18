## 1. 读取分割Hyperledger的Block Data和Transaction Data

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

<br />
<br />

## 2. 分析blockfile_xxxxxx文件

## 2.1. blockfile_000000



blockfile_000000大小: 67102604
blockfile_000000包含文件: block0.block -> block2571.block


下一步: 通过script实现下列查询分析:

问题: blockfile文件的大小?
问题: blockfile包含.block文件数量？
问题: .block文件的大小？
问题: .block文件包含Txs交易数量？
问题: .block文件包含Txs交易Size?

进阶问题: blockfile文件包含多少Txs数量？


----------------------------------------------------------------

当前：blockfile_000025 包含 block5418.block, block5419.block

生成20个Transactions之后，

变成: blockfile_000025 包含 

```shell
$ sudo ./readBlock_v2
[sudo] password for joe: 
Block: Number=[5418], CurrentBlockHash=[TXfEazDaV/JWDa82ln9nVhPePGSaYzluh0A4MAK55U4=], PreviousBlockHash=[aydLbT1pGlg1BPKIPt/sxcpF9MRBcKCXWa4bC3Sz5ak=]
    txid=9eddeceadad93e9ff398e124ed4d5f6ee75fb60e9148155c35e403042ff1301d
Block: Number=[5419], CurrentBlockHash=[2I0slEf4C/kpMsKodTORGU0OxO8ThNUIHSxlDTfFaw8=], PreviousBlockHash=[D5PEAPUWMZepMhBAlySv2AQn++QNBIkarZTGmKnfy88=]
    txid=530068ba925c29d8c5ab0d36a425e9ba643c97d18dfc3bdb93937463ef72b5b0
Block: Number=[5420], CurrentBlockHash=[7UEiwAZ5g/2tpHzIIOmeZVqUr78bkfOd+P+HfcfAMeA=], PreviousBlockHash=[EQ1QiIMaom59PE7ou8fexWAFFnTB3LRXgHuDrv0HBJE=]
    txid=e7d8a59118cb8df1082ee574958815c2601b6b35b0e24acf9aa65fe37f551e63
    txid=e2547f3fa69308d1eb1e1791da24a7df67a8be23c12d1ff42c0a87fddaa1a5f1
    txid=46be77311b563771fc6a1a3487694492d237823a00933bdea5981510aaf05642
    txid=da9bc65e5faec8c537e5711abbaf8741c060807955218172a21f277e9dd32a01
    txid=beb02b85b44e070f14370e8ebb5869d9b894d16d4be1cd00e8b58a09b6fba632
Block: Number=[5421], CurrentBlockHash=[oDXSoqySe48f80Kvvrb1fJTlwvrbCAPtOmvCQKGkeK4=], PreviousBlockHash=[K+cfZTJBoYGd8bDPUm2o2yUhL1IRdYMfST709pztuvI=]
    txid=254a6f5de0a2ec921bab8cc288bfac92774ea027afba62a40b3e03b7dc79c635
    txid=4b8eb53c50f274a7478e2bd4a11856dd238104772250dd3696d3f641d46b58ac
    txid=0f8f7417adcffbada1e628f42f36840954b9a46339e8c0797fdb310fdf493eba
    txid=e3baef5439d1452cbd3f482e82699795762a472b9c7ae0d4f15f3773322db520
    txid=1c4ed667ef3d68c65b91c3e5cd78e357227bfd37f2d6618b760541ccfae5aae1
    txid=fdf0e9469405a61fecf8016e21f8be564f28d40a4ef032474e2397a8b171c7e8
    txid=1ce36f12a4543491e5b6cc73fc998853a6fc1d0d6e68e306ca136a4b2b3554b3
    txid=9842edc5348c7678e054d577df08af4ba7a7dce72b7febe241d728da0521acbb
    txid=625b9a08db029a0e7b00dd461fdccddeba9b496cd87f6718f0836d1e2c45f77a
    txid=6fa5d7c1ca5bc852ff173b6cae4690b5ea62a3a3d5a376f837def06beef9e489
Block: Number=[5422], CurrentBlockHash=[ZBaiW7mypnC0MjaDvSOjVtiFrieI14pu1aW3nMXydR0=], PreviousBlockHash=[QvBT+VphGAGqUvazdAzHMIMEzeB0qCTN7rURmpCHSWs=]
    txid=f963c59e374be3aacd1b313bca0efa39f1245895abed81a525f058361de89e7b
    txid=0a84be355604a1a0b7f90829b986b7987bd8df6acff442a349ef71fa5738d927
    txid=abcd1fce352c4c77d5de148736035831c44ec699798805f22b49beabae8cf31e
    txid=1f696970a254f9b11e3ba30dca4062f29d75ae3228403f2925dc4add858c2553
    txid=7c4af99a962c957a9b76b6d9395c58564275ce7e9285f05ee06629d0d8b69df2
```

完美！






