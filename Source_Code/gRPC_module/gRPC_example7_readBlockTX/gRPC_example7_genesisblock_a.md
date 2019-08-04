## 1. 配置Peer/Orderer所属IP
网络配置方案如下图
| 物理机器      | Hyperledger Fabric部件 |
|---------------|------------------------|
| 192.168.0.103 | orderer.example.com    |
| 192.168.0.103 | peer0.org1.example.com |

**步骤1.1** 192.168.0.103"机器通过"sudo vi /etc/hosts"命令打开hosts文件，并写入下列内容。

```shell
# Hyperledger cluster
192.168.0.103 orderer.example.com
192.168.0.103 peer0.org1.example.com
```

<br />
<br />

## 2. 准备证书 (Orderer+Peers)
**步骤2.1.** 创建“crypto-config.yaml”文件于"cd $HOME/fabric-samples"路径下。注："crypto-config.yaml"参考"cd $HOME/fabric-samples/config"路径下默认的配置文件。

```shell
$ cd $HOME/fabric-samples
~/fabric-samples$ vi crypto-config.yaml
```

下列内容写入“crypto-config.yaml”。
```yaml
OrdererOrgs:
  - Name: Orderer
    Domain: example.com
    Specs:
      - Hostname: orderer
PeerOrgs:
  - Name: Org1
    Domain: org1.example.com
    Template:
      Count: 1
    Users:
      Count: 1
```

**步骤2.2.** 生成配置文件，并将配置文件写入"certs"文件夹。
```shell
~/fabric-samples$ ./bin/cryptogen generate --config=crypto-config.yaml --output ./certs
org1.example.com
```

<br />
<br />

## 3. 配置Orderer
**步骤3.1.** 新建"orderer.example.com"文件夹，用于存放Orderer节点启动运行所需的全部文件。

```shell
~/fabric-samples$ mkdir orderer.example.com
```

**步骤3.2.** 拷贝“fabric-samples/bin/orderer”到文件夹。

```shell
~/fabric-samples$ cp bin/orderer orderer.example.com/
```

**步骤3.3.** 拷贝"fabric-sample/certs/ordererOrganizations/example.com/orderers/orderer.example.com/"路径下的所有内容到文件夹。

```shell
~/fabric-samples$ cp -rf certs/ordererOrganizations/example.com/orderers/orderer.example.com/* orderer.example.com/
```

**步骤3.4.** 创建"orderer.yaml"文件到"orderer.example.com"文件夹下。

```shell
~/fabric-samples$ cd orderer.example.com
~/fabric-samples/orderer.example.com$ touch orderer.yaml
```
并往"orderer.yaml"中写入下列内容。
```yaml
General:
    LedgerType: file
    ListenAddress: 0.0.0.0
    ListenPort: 7050
    TLS:
        Enabled: true
        PrivateKey: ./tls/server.key
        Certificate: ./tls/server.crt
        RootCAs:
          - ./tls/ca.crt
#        ClientAuthEnabled: false
#        ClientRootCAs:
    LogLevel: debug
    LogFormat: '%{color}%{time:2006-01-02 15:04:05.000 MST} [%{module}] %{shortfunc} -> %{level:.4s} %{id:03x}%{color:reset} %{message}'
#    GenesisMethod: provisional
    GenesisMethod: file
    GenesisProfile: SampleInsecureSolo
    GenesisFile: ./genesisblock
    LocalMSPDir: ./msp
    LocalMSPID: OrdererMSP
    Profile:
        Enabled: false
        Address: 0.0.0.0:6060
    BCCSP:
        Default: SW
        SW:
            Hash: SHA2
            Security: 256
            FileKeyStore:
                KeyStore:
FileLedger:
    Location:  /opt/app/fabric/orderer/data
    Prefix: hyperledger-fabric-ordererledger
RAMLedger:
    HistorySize: 1000
Kafka:
    Retry:
        ShortInterval: 5s
        ShortTotal: 10m
        LongInterval: 5m
        LongTotal: 12h
        NetworkTimeouts:
            DialTimeout: 10s
            ReadTimeout: 10s
            WriteTimeout: 10s
        Metadata:
            RetryBackoff: 250ms
            RetryMax: 3
        Producer:
            RetryBackoff: 100ms
            RetryMax: 3
        Consumer:
            RetryBackoff: 2s
    Verbose: false
    TLS:
      Enabled: false
      PrivateKey:
        #File: path/to/PrivateKey
      Certificate:
        #File: path/to/Certificate
      RootCAs:
        #File: path/to/RootCAs
    Version:
```

注意：“orderer.example.com"文件夹的内容将最终存放于”/opt/app/fabric/orderer"路径下。相应地，Hyperledger Fabric的账本数据存在在"/opt/app/fabric/orderer/data"路径下。

**步骤3.5.** 新建data目录存放orderer数据。

```shell
~/fabric-samples/orderer.example.com$ mkdir data
```

<br />
<br />

## 4. 配置 peer0.org1.example.com
**步骤4.1.** 新建"peer0.org1.example.com"文件夹，用于存放peer0.org1节点启动运行所需的全部文件。

```shell
~/fabric-samples$ mkdir peer0.org1.example.com
```

**步骤4.2.** 拷贝“fabric-samples/bin/peer”到文件夹。

```shell
~/fabric-samples$ cp bin/peer peer0.org1.example.com/
```

**步骤4.3.** 拷贝"fabric-sample/certs/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/"路径下的所有内容到文件夹。

```shell
~/fabric-samples$ cp -rf certs/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/* peer0.org1.example.com/
```

**步骤4.4.** 创建"core.yaml"文件到"peer0.org1.example.com"文件夹下。

```shell
~/fabric-samples$ cd peer0.org1.example.com
~/fabric-samples/peer0.org1.example.com$ touch core.yaml
```

并往"core.yaml"中写入下列内容。

```yaml
logging:
    peer:       debug
    cauthdsl:   warning
    gossip:     warning
    ledger:     info
    msp:        warning
    policies:   warning
    grpc:       error
    format: '%{color}%{time:2006-01-02 15:04:05.000 MST} [%{module}] %{shortfunc} -> %{level:.4s} %{id:03x}%{color:reset} %{message}'
peer:
    id: peer0.org1.example.com
    networkId: dev
    listenAddress: 0.0.0.0:7051
    address: 0.0.0.0:7051
    addressAutoDetect: false
    gomaxprocs: -1
    gossip:
        bootstrap: 127.0.0.1:7051
        bootstrap: peer0.org1.example.com:7051
        useLeaderElection: true
        orgLeader: false
        endpoint:
        maxBlockCountToStore: 100
        maxPropagationBurstLatency: 10ms
        maxPropagationBurstSize: 10
        propagateIterations: 1
        propagatePeerNum: 3
        pullInterval: 4s
        pullPeerNum: 3
        requestStateInfoInterval: 4s
        publishStateInfoInterval: 4s
        stateInfoRetentionInterval:
        publishCertPeriod: 10s
        skipBlockVerification: false
        dialTimeout: 3s
        connTimeout: 2s
        recvBuffSize: 20
        sendBuffSize: 200
        digestWaitTime: 1s
        requestWaitTime: 1s
        responseWaitTime: 2s
        aliveTimeInterval: 5s
        aliveExpirationTimeout: 25s
        reconnectInterval: 25s
        externalEndpoint: peer0.org1.example.com:7051
        election:
            startupGracePeriod: 15s
            membershipSampleInterval: 1s
            leaderAliveThreshold: 10s
            leaderElectionDuration: 5s
    events:
        address: 0.0.0.0:7053
        buffersize: 100
        timeout: 10ms
    tls:
        enabled: true
        cert:
            file: ./tls/server.crt
        key:
            file: ./tls/server.key
        rootcert:
            file: ./tls/ca.crt
        serverhostoverride:
    fileSystemPath: /opt/app/fabric/peer/data
    BCCSP:
        Default: SW
        SW:
            Hash: SHA2
            Security: 256
            FileKeyStore:
                KeyStore:
    mspConfigPath: msp
    localMspId: Org1MSP
    profile:
        enabled:    true
        listenAddress: 0.0.0.0:6060
vm:
    endpoint: unix:///var/run/docker.sock
    docker:
        tls:
            enabled: false
            ca:
                file: docker/ca.crt
            cert:
                file: docker/tls.crt
            key:
                file: docker/tls.key
        attachStdout: false
        hostConfig:
            NetworkMode: host
            Dns:
               # - 192.168.0.1
            LogConfig:
                Type: json-file
                Config:
                    max-size: "50m"
                    max-file: "5"
            Memory: 2147483648
chaincode:
    peerAddress:
    id:
        path:
        name:
    builder: $(DOCKER_NS)/fabric-ccenv:$(ARCH)-$(PROJECT_VERSION)
    golang:
        runtime: $(BASE_DOCKER_NS)/fabric-baseos:$(ARCH)-$(BASE_VERSION)
    car:
        runtime: $(BASE_DOCKER_NS)/fabric-baseos:$(ARCH)-$(BASE_VERSION)
    java:
        Dockerfile:  |
            from $(DOCKER_NS)/fabric-javaenv:$(ARCH)-$(PROJECT_VERSION)
    startuptimeout: 300s
    executetimeout: 30s
    mode: net
    keepalive: 0
    system:
        cscc: enable
        lscc: enable
        escc: enable
        vscc: enable
        qscc: enable
    logging:
      level:  info
      shim:   warning
      format: '%{color}%{time:2006-01-02 15:04:05.000 MST} [%{module}] %{shortfunc} -> %{level:.4s} %{id:03x}%{color:reset} %{message}'
ledger:
  blockchain:
  state:
    stateDatabase: goleveldb
    couchDBConfig:
       couchDBAddress: 127.0.0.1:5984
       username:
       password:
       maxRetries: 3
       maxRetriesOnStartup: 10
       requestTimeout: 35s
       queryLimit: 10000
  history:
    enableHistoryDatabase: true
```

**步骤4.5.** 新建data目录存放peer0.org1数据。

```shell
~/fabric-samples/peer0.org1.example.com$ mkdir data
```

<br />
<br />

## 5. 部署Orderer
**步骤5.1.** 创建/opt/app/fabric/orderer目录。

```shell
~/fabric-samples$ sudo mkdir -p /opt/app/fabric/orderer
```

**步骤5.2.** 复制配置文件到/opt/app/fabric/order目录。

```shell
~/fabric-samples$ sudo cp -r orderer.example.com/* /opt/app/fabric/orderer/
```

<br />
<br />

## 6. 部署 peer0.org1.example.com

**步骤6.1.** 创建/opt/app/fabric/peer目录。

```shell
~/fabric-samples$ sudo mkdir -p /opt/app/fabric/peer
```

**步骤6.2.** 复制配置文件到/opt/app/fabric/peer目录。

```shell
~/fabric-samples$ sudo cp -r peer0.org1.example.com/* /opt/app/fabric/peer/
```

<br />
<br />

## 7. 配置创世块和锚点
**步骤7.1.** 创建configtx.yaml文件。

```shell
~/fabric-samples$ touch configtx.yaml
```

写入下列内容。

```yaml
Organizations:
    - &OrdererOrg
        Name: OrdererOrg
        ID: OrdererMSP
        MSPDir: ./certs/ordererOrganizations/example.com/msp
    - &Org1
        Name: Org1MSP
        ID: Org1MSP
        MSPDir: ./certs/peerOrganizations/org1.example.com/msp
        AnchorPeers:
            - Host: peer0.org1.example.com
              Port: 7051
Orderer: &OrdererDefaults
    OrdererType: solo
    Addresses:
        - orderer.example.com:7050
    BatchTimeout: 2s
    BatchSize:
        MaxMessageCount: 10
        AbsoluteMaxBytes: 99 MB
        PreferredMaxBytes: 512 KB
    Kafka:
        Brokers:
            - 127.0.0.1:9092
    Organizations:
Application: &ApplicationDefaults
    Organizations:
Profiles:
    TwoOrgsOrdererGenesis:
        Orderer:
            <<: *OrdererDefaults
            Organizations:
                - *OrdererOrg
        Consortiums:
            SampleConsortium:
                Organizations:
                    - *Org1
    TwoOrgsChannel:
        Consortium: SampleConsortium
        Application:
            <<: *ApplicationDefaults
            Organizations:
                - *Org1
```

**步骤7.2.** 生成创世块和锚点配置。

```shell
~/fabric-samples$ ./bin/configtxgen -profile TwoOrgsOrdererGenesis -outputBlock ./genesisblock
```

**步骤7.4.** 复制创世块和锚点到Orderer。

```
~/fabric-samples$ sudo cp genesisblock /opt/app/fabric/orderer/
```

<br />
<br />

## 8. 启动Hyperledger
启动orderer。

```shell
$ cd /opt/app/fabric/orderer
$ sudo ./orderer
```

启动 peer0.org1.example.com。

```shell
$ cd /opt/app/fabric/peer
$ sudo ./peer node start 
```

<br />
<br />



## 9. 查看genesis block证书
此时的状态时，orderer有一个genesis block，但是还没有出现channel，所以没有一条完整的chaindata。

orderer不完整的chaindata路径如下，

```shell
$ cd /opt/app/fabric/orderer/data/chains/testchainid/blockfile_000000
```

下面我们查看blockfile_000000的信息。

Ubuntutu00工作路径
```shell
$ cd /home/joe/go/src/readBlock
```

代码 readBlock.go 格式如下，
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
    fileName = "/opt/app/fabric/orderer/data/chains/testchainid/blockfile_000000"

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

编译执行，

```shell
$ go build readBlock.go
# run it
$ sudo ./readBlock
```

将block0.block转换成block0.json格式 (这里有误，我们下次修改)，如下，

```shell
/home/joe/fabric-samples/bin/configtxlator proto_decode --input block0.block --type common.Block --output block0.json
```


<br />
<br />

## 10. 查看orderer MSP和TLS

#### 10.1. msp/admincerts/Admin@example.com-cert.pem

```
-----BEGIN CERTIFICATE-----
MIICCjCCAbGgAwIBAgIRANZ4yN8P2vFsvbwWBCtaKp4wCgYIKoZIzj0EAwIwaTEL
MAkGA1UEBhMCVVMxEzARBgNVBAgTCkNhbGlmb3JuaWExFjAUBgNVBAcTDVNhbiBG
cmFuY2lzY28xFDASBgNVBAoTC2V4YW1wbGUuY29tMRcwFQYDVQQDEw5jYS5leGFt
cGxlLmNvbTAeFw0xOTA3MzExMzA1MjBaFw0yOTA3MjgxMzA1MjBaMFYxCzAJBgNV
BAYTAlVTMRMwEQYDVQQIEwpDYWxpZm9ybmlhMRYwFAYDVQQHEw1TYW4gRnJhbmNp
c2NvMRowGAYDVQQDDBFBZG1pbkBleGFtcGxlLmNvbTBZMBMGByqGSM49AgEGCCqG
SM49AwEHA0IABC6NTR1LQNBXYllOzCfJ3C8hPoepN9OAgljuS34d1ywdJ3pe/qwV
mTgZrkMAI6QlJRR6Q/0QKDYCl+NlBTyzT52jTTBLMA4GA1UdDwEB/wQEAwIHgDAM
BgNVHRMBAf8EAjAAMCsGA1UdIwQkMCKAIHdNu0YQeij/J3Cz5uusv50rP9+yDR8l
OkTi8jUrHY6MMAoGCCqGSM49BAMCA0cAMEQCIBwPZuAQ5Np7NdL9dYQLfVme9LKL
Pcb/vS8VqX2cOe3uAiBCphhnpAXQ+0aqsE1P6UP5SgAT3sgbQ05U28yFD0Tpwg==
-----END CERTIFICATE-----
```

其中，cat block0.block存放了Admin@example.com-cert.pem非自签名证书，Admin@example.com-cert.pem是ca.example.com-cert.pem的子证书链证书。

```shell
$ openssl verify -CAfile ca.example.com-cert.pem /opt/app/fabric/orderer/msp/admincerts/Admin@example.com-cert.pem
```


#### 10.2. msp/cacerts/ca.example.com-cert.pem
```
-----BEGIN CERTIFICATE-----
MIICLzCCAdagAwIBAgIRAN9ZcrnR397TmZ5NCus19rAwCgYIKoZIzj0EAwIwaTEL
MAkGA1UEBhMCVVMxEzARBgNVBAgTCkNhbGlmb3JuaWExFjAUBgNVBAcTDVNhbiBG
cmFuY2lzY28xFDASBgNVBAoTC2V4YW1wbGUuY29tMRcwFQYDVQQDEw5jYS5leGFt
cGxlLmNvbTAeFw0xOTA3MzExMzA1MjBaFw0yOTA3MjgxMzA1MjBaMGkxCzAJBgNV
BAYTAlVTMRMwEQYDVQQIEwpDYWxpZm9ybmlhMRYwFAYDVQQHEw1TYW4gRnJhbmNp
c2NvMRQwEgYDVQQKEwtleGFtcGxlLmNvbTEXMBUGA1UEAxMOY2EuZXhhbXBsZS5j
b20wWTATBgcqhkjOPQIBBggqhkjOPQMBBwNCAATOfVDNgfbqyNiAmiQDbMrHvBDL
s94MpGawIbgHAJINfSRkwpb9QWM0MGL1dFFD7YPSqEP50+IWwQAqZrGUo9cDo18w
XTAOBgNVHQ8BAf8EBAMCAaYwDwYDVR0lBAgwBgYEVR0lADAPBgNVHRMBAf8EBTAD
AQH/MCkGA1UdDgQiBCB3TbtGEHoo/ydws+brrL+dKz/fsg0fJTpE4vI1Kx2OjDAK
BggqhkjOPQQDAgNHADBEAiBFsLQ+iFhQe4Q1J9mo6jx+bmH8YZqxubxnpmOVKL+Y
ngIgWGzW1rK1BXXGvHP9jN4Z6z7rWvNJ+mVm7bhgSl/7IL8=
-----END CERTIFICATE-----
```

其中，cat block0.block存放了ca.example.com-cert.pem自签名证书。


#### 10.3. msp/keystore
```
1f32ec4af3760c508bd3d9effc5f026e16dd9917de8ac0652afa951249fdfb48_sk
```

```
-----BEGIN PRIVATE KEY-----
MIGHAgEAMBMGByqGSM49AgEGCCqGSM49AwEHBG0wawIBAQQg8MipjFs02MbBXzok
PB1X6rZ/NcGj+YMUc2u4Q59mRs+hRANCAARd+TvXDnjTmtyL95m9qcO+pkx3Zgc7
unU7LX5rOil3xI4EaBPXFLRBsYSW8wx0vqpTiUY8eS/PpHXE5j82d5Jq
-----END PRIVATE KEY-----
```



#### 10.4. msp/signcerts/orderer.example.com-cert.pem

```
-----BEGIN CERTIFICATE-----
MIICDTCCAbOgAwIBAgIRALVIHOxSFCJqCx7bGCCypXcwCgYIKoZIzj0EAwIwaTEL
MAkGA1UEBhMCVVMxEzARBgNVBAgTCkNhbGlmb3JuaWExFjAUBgNVBAcTDVNhbiBG
cmFuY2lzY28xFDASBgNVBAoTC2V4YW1wbGUuY29tMRcwFQYDVQQDEw5jYS5leGFt
cGxlLmNvbTAeFw0xOTA3MzExMzA1MjBaFw0yOTA3MjgxMzA1MjBaMFgxCzAJBgNV
BAYTAlVTMRMwEQYDVQQIEwpDYWxpZm9ybmlhMRYwFAYDVQQHEw1TYW4gRnJhbmNp
c2NvMRwwGgYDVQQDExNvcmRlcmVyLmV4YW1wbGUuY29tMFkwEwYHKoZIzj0CAQYI
KoZIzj0DAQcDQgAEXfk71w5405rci/eZvanDvqZMd2YHO7p1Oy1+azopd8SOBGgT
1xS0QbGElvMMdL6qU4lGPHkvz6R1xOY/NneSaqNNMEswDgYDVR0PAQH/BAQDAgeA
MAwGA1UdEwEB/wQCMAAwKwYDVR0jBCQwIoAgd027RhB6KP8ncLPm66y/nSs/37IN
HyU6ROLyNSsdjowwCgYIKoZIzj0EAwIDSAAwRQIhAKLEXi6EmKIJYFhHRANAWaPR
xoS36wFDaAa2OUzam26YAiAXF2WYOGfHEswu+fy2iA9wS6kSv0vgSMSpv53VWTfX
UQ==
-----END CERTIFICATE-----
```


#### 10.5. msp/tlscacerts/tlsca.example.com-cert.pem

```
-----BEGIN CERTIFICATE-----
MIICNjCCAdygAwIBAgIRAKET5odv8iiWA26m+xtoW4AwCgYIKoZIzj0EAwIwbDEL
MAkGA1UEBhMCVVMxEzARBgNVBAgTCkNhbGlmb3JuaWExFjAUBgNVBAcTDVNhbiBG
cmFuY2lzY28xFDASBgNVBAoTC2V4YW1wbGUuY29tMRowGAYDVQQDExF0bHNjYS5l
eGFtcGxlLmNvbTAeFw0xOTA3MzExMzA1MjBaFw0yOTA3MjgxMzA1MjBaMGwxCzAJ
BgNVBAYTAlVTMRMwEQYDVQQIEwpDYWxpZm9ybmlhMRYwFAYDVQQHEw1TYW4gRnJh
bmNpc2NvMRQwEgYDVQQKEwtleGFtcGxlLmNvbTEaMBgGA1UEAxMRdGxzY2EuZXhh
bXBsZS5jb20wWTATBgcqhkjOPQIBBggqhkjOPQMBBwNCAASYGK79D1jCzqWXMz5+
5HVjR3K0oVGudtl/nwz1xXuErKFHoAK2wpEBB2ei9Rk/0seJMOkSKNimEu1jAmEm
bhjoo18wXTAOBgNVHQ8BAf8EBAMCAaYwDwYDVR0lBAgwBgYEVR0lADAPBgNVHRMB
Af8EBTADAQH/MCkGA1UdDgQiBCBsSOEtoOMhruBta3jm+7UUjpj+3SCNB00cVKhl
0ShZ1DAKBggqhkjOPQQDAgNIADBFAiEAtlOfoEvUu3mW50tntJZUo9PZUaxqR3oB
6sxWjYPR3OUCIDtmGh+O+z7HvaIBubmJt+0Wffz1JolbHAJl6+f03Ku7
-----END CERTIFICATE-----
```
其中，cat block0.block存放了tlsca.example.com-cert.pem自签名证书。


#### 10.6. tls/ca.crt
```
-----BEGIN CERTIFICATE-----
MIICNjCCAdygAwIBAgIRAKET5odv8iiWA26m+xtoW4AwCgYIKoZIzj0EAwIwbDEL
MAkGA1UEBhMCVVMxEzARBgNVBAgTCkNhbGlmb3JuaWExFjAUBgNVBAcTDVNhbiBG
cmFuY2lzY28xFDASBgNVBAoTC2V4YW1wbGUuY29tMRowGAYDVQQDExF0bHNjYS5l
eGFtcGxlLmNvbTAeFw0xOTA3MzExMzA1MjBaFw0yOTA3MjgxMzA1MjBaMGwxCzAJ
BgNVBAYTAlVTMRMwEQYDVQQIEwpDYWxpZm9ybmlhMRYwFAYDVQQHEw1TYW4gRnJh
bmNpc2NvMRQwEgYDVQQKEwtleGFtcGxlLmNvbTEaMBgGA1UEAxMRdGxzY2EuZXhh
bXBsZS5jb20wWTATBgcqhkjOPQIBBggqhkjOPQMBBwNCAASYGK79D1jCzqWXMz5+
5HVjR3K0oVGudtl/nwz1xXuErKFHoAK2wpEBB2ei9Rk/0seJMOkSKNimEu1jAmEm
bhjoo18wXTAOBgNVHQ8BAf8EBAMCAaYwDwYDVR0lBAgwBgYEVR0lADAPBgNVHRMB
Af8EBTADAQH/MCkGA1UdDgQiBCBsSOEtoOMhruBta3jm+7UUjpj+3SCNB00cVKhl
0ShZ1DAKBggqhkjOPQQDAgNIADBFAiEAtlOfoEvUu3mW50tntJZUo9PZUaxqR3oB
6sxWjYPR3OUCIDtmGh+O+z7HvaIBubmJt+0Wffz1JolbHAJl6+f03Ku7
-----END CERTIFICATE-----
```


#### 10.7. tls/server.crt

```
-----BEGIN CERTIFICATE-----
MIICWDCCAf+gAwIBAgIQW6CZyNF8zhC6bhq+5yh1qjAKBggqhkjOPQQDAjBsMQsw
CQYDVQQGEwJVUzETMBEGA1UECBMKQ2FsaWZvcm5pYTEWMBQGA1UEBxMNU2FuIEZy
YW5jaXNjbzEUMBIGA1UEChMLZXhhbXBsZS5jb20xGjAYBgNVBAMTEXRsc2NhLmV4
YW1wbGUuY29tMB4XDTE5MDczMTEzMDUyMFoXDTI5MDcyODEzMDUyMFowWDELMAkG
A1UEBhMCVVMxEzARBgNVBAgTCkNhbGlmb3JuaWExFjAUBgNVBAcTDVNhbiBGcmFu
Y2lzY28xHDAaBgNVBAMTE29yZGVyZXIuZXhhbXBsZS5jb20wWTATBgcqhkjOPQIB
BggqhkjOPQMBBwNCAATVWUQ/p69s/FS+Jz2KEQyC5n5W20VzThi2UmzszkkRJfX9
uj5rO4LhVFfROtOpx3d66jkn0J1cSE8Ny3KRt5EFo4GWMIGTMA4GA1UdDwEB/wQE
AwIFoDAdBgNVHSUEFjAUBggrBgEFBQcDAQYIKwYBBQUHAwIwDAYDVR0TAQH/BAIw
ADArBgNVHSMEJDAigCBsSOEtoOMhruBta3jm+7UUjpj+3SCNB00cVKhl0ShZ1DAn
BgNVHREEIDAeghNvcmRlcmVyLmV4YW1wbGUuY29tggdvcmRlcmVyMAoGCCqGSM49
BAMCA0cAMEQCIDmgXR9G4VJsnxFrZ4xMcw1m+/VFm+Q3NvXJQS1sGemCAiBENu/x
zbeSmtSVBpzp4I5ehkIOIBnNlyVCv5+AavGoog==
-----END CERTIFICATE-----
```









<br />
<br />

## 11. 查看peer MSP和TLS

#### 11.1. msp/admincerts/Admin@org1.example.com-cert.pem

```
-----BEGIN CERTIFICATE-----
MIICGjCCAcCgAwIBAgIRAOXY4BQ7r31V7v64TRXKYuswCgYIKoZIzj0EAwIwczEL
MAkGA1UEBhMCVVMxEzARBgNVBAgTCkNhbGlmb3JuaWExFjAUBgNVBAcTDVNhbiBG
cmFuY2lzY28xGTAXBgNVBAoTEG9yZzEuZXhhbXBsZS5jb20xHDAaBgNVBAMTE2Nh
Lm9yZzEuZXhhbXBsZS5jb20wHhcNMTkwNzMxMTMwNTIwWhcNMjkwNzI4MTMwNTIw
WjBbMQswCQYDVQQGEwJVUzETMBEGA1UECBMKQ2FsaWZvcm5pYTEWMBQGA1UEBxMN
U2FuIEZyYW5jaXNjbzEfMB0GA1UEAwwWQWRtaW5Ab3JnMS5leGFtcGxlLmNvbTBZ
MBMGByqGSM49AgEGCCqGSM49AwEHA0IABEcfMY3o+xQuH2fOBeOrtLjvDF8M44K1
obzHcPq+tP+NTGVcTAyppRLDu5ysJqph+pbDldVQrLJq+9MdhGuR9Q6jTTBLMA4G
A1UdDwEB/wQEAwIHgDAMBgNVHRMBAf8EAjAAMCsGA1UdIwQkMCKAIHJYZjdrJawm
y/zhjBpDXC9pyWV19UmvFZXZyHsIHb1AMAoGCCqGSM49BAMCA0gAMEUCIQCk5gBW
Ie3OHnQ6C9Kxzog/Yag2Tff8kw5XbR3Jph8W+wIgOu3k78HSPRGAZV0R0D1jhZ79
sR9ij9DfWDNC1R8VUo4=
-----END CERTIFICATE-----
```

#### 11.2. msp/cacerts/ca.org1.example.com-cert.pem

```
-----BEGIN CERTIFICATE-----
MIICQjCCAemgAwIBAgIQQ9rAhnk9DgCB+QHhGc1JkDAKBggqhkjOPQQDAjBzMQsw
CQYDVQQGEwJVUzETMBEGA1UECBMKQ2FsaWZvcm5pYTEWMBQGA1UEBxMNU2FuIEZy
YW5jaXNjbzEZMBcGA1UEChMQb3JnMS5leGFtcGxlLmNvbTEcMBoGA1UEAxMTY2Eu
b3JnMS5leGFtcGxlLmNvbTAeFw0xOTA3MzExMzA1MjBaFw0yOTA3MjgxMzA1MjBa
MHMxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpDYWxpZm9ybmlhMRYwFAYDVQQHEw1T
YW4gRnJhbmNpc2NvMRkwFwYDVQQKExBvcmcxLmV4YW1wbGUuY29tMRwwGgYDVQQD
ExNjYS5vcmcxLmV4YW1wbGUuY29tMFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAE
m7jhUrAnXc9hrniy+ia47gpBaYQmXJksHH5IsseSIH9Zr9TmM6qxa0hjEtGHfhhA
KHGC5fKFusbyU6vPNn+QXaNfMF0wDgYDVR0PAQH/BAQDAgGmMA8GA1UdJQQIMAYG
BFUdJQAwDwYDVR0TAQH/BAUwAwEB/zApBgNVHQ4EIgQgclhmN2slrCbL/OGMGkNc
L2nJZXX1Sa8VldnIewgdvUAwCgYIKoZIzj0EAwIDRwAwRAIgMFe15OYnsY5Dn0EI
348AMPCePPts27c4vOfsaWEwEhwCIEY9eirqBgUtA2b+2LGw0BTSd/N5mzB9ElXN
Jpbj+UJ6
-----END CERTIFICATE-----
```

#### 11.3. msp/keystore

```
a37b045ed37907ed5b383dee85be238adcd4ec084f04abf59584ec0d938ef773_sk
```

```
-----BEGIN PRIVATE KEY-----
MIGHAgEAMBMGByqGSM49AgEGCCqGSM49AwEHBG0wawIBAQQgJq8E+NwMzIPGJvKJ
XXj4qLYovHbgLwgL2Ridr4gTPL+hRANCAARClRlsfzUby/Q2hhDeygvbbJ2cjrX8
z79LCLM77j+hs54ncKHSiJFuUau8Y0neD3Yl4Uv4A4dGafJ04Mz/KCIi
-----END PRIVATE KEY-----
```



#### 11.4. msp/signcerts/peer0.org1.example.com-cert.pem

```
-----BEGIN CERTIFICATE-----
MIICGTCCAcCgAwIBAgIRALwxXBYMxlaaOm4FLFbWKxYwCgYIKoZIzj0EAwIwczEL
MAkGA1UEBhMCVVMxEzARBgNVBAgTCkNhbGlmb3JuaWExFjAUBgNVBAcTDVNhbiBG
cmFuY2lzY28xGTAXBgNVBAoTEG9yZzEuZXhhbXBsZS5jb20xHDAaBgNVBAMTE2Nh
Lm9yZzEuZXhhbXBsZS5jb20wHhcNMTkwNzMxMTMwNTIwWhcNMjkwNzI4MTMwNTIw
WjBbMQswCQYDVQQGEwJVUzETMBEGA1UECBMKQ2FsaWZvcm5pYTEWMBQGA1UEBxMN
U2FuIEZyYW5jaXNjbzEfMB0GA1UEAxMWcGVlcjAub3JnMS5leGFtcGxlLmNvbTBZ
MBMGByqGSM49AgEGCCqGSM49AwEHA0IABEKVGWx/NRvL9DaGEN7KC9tsnZyOtfzP
v0sIszvuP6GznidwodKIkW5Rq7xjSd4PdiXhS/gDh0Zp8nTgzP8oIiKjTTBLMA4G
A1UdDwEB/wQEAwIHgDAMBgNVHRMBAf8EAjAAMCsGA1UdIwQkMCKAIHJYZjdrJawm
y/zhjBpDXC9pyWV19UmvFZXZyHsIHb1AMAoGCCqGSM49BAMCA0cAMEQCIE44FNkB
IM5qotILnQfxnqclkY7ZbGTY+ZTR6B+v9ruYAiAm9D8Rp+SFkhcQJ1vBfWLooSin
5+Skk4Tyw9K+BQLHkQ==
-----END CERTIFICATE-----
```

#### 11.5. msp/tlscacerts/tlsca.org1.example.com-cert.pem

```
-----BEGIN CERTIFICATE-----
MIICSTCCAfCgAwIBAgIRAIWxri7B0LLvlk5IZ/TPsJEwCgYIKoZIzj0EAwIwdjEL
MAkGA1UEBhMCVVMxEzARBgNVBAgTCkNhbGlmb3JuaWExFjAUBgNVBAcTDVNhbiBG
cmFuY2lzY28xGTAXBgNVBAoTEG9yZzEuZXhhbXBsZS5jb20xHzAdBgNVBAMTFnRs
c2NhLm9yZzEuZXhhbXBsZS5jb20wHhcNMTkwNzMxMTMwNTIwWhcNMjkwNzI4MTMw
NTIwWjB2MQswCQYDVQQGEwJVUzETMBEGA1UECBMKQ2FsaWZvcm5pYTEWMBQGA1UE
BxMNU2FuIEZyYW5jaXNjbzEZMBcGA1UEChMQb3JnMS5leGFtcGxlLmNvbTEfMB0G
A1UEAxMWdGxzY2Eub3JnMS5leGFtcGxlLmNvbTBZMBMGByqGSM49AgEGCCqGSM49
AwEHA0IABHyTsgZsKPlaKKDqeyo30EuNUHV4YmOYGp2b9fdO5guRhmHv41cjwiDl
XR1iPb6dI5a7trbm6JbJKychvbFETDSjXzBdMA4GA1UdDwEB/wQEAwIBpjAPBgNV
HSUECDAGBgRVHSUAMA8GA1UdEwEB/wQFMAMBAf8wKQYDVR0OBCIEIL5rNM2HbSN7
hVYerDrO2iemd0ECp5hcCtuHMWfXD+5CMAoGCCqGSM49BAMCA0cAMEQCIDwS7iXV
ASdz+eCyZhSFV1lXoPOwemJFIVkhwnFvpZsdAiBIgWmJiEgMWctMpVmMoiRPShF6
oGPFr3C3Ghx6c0wV0w==
-----END CERTIFICATE-----
```

#### 11.6. tls/ca.crt

```
-----BEGIN CERTIFICATE-----
MIICSTCCAfCgAwIBAgIRAIWxri7B0LLvlk5IZ/TPsJEwCgYIKoZIzj0EAwIwdjEL
MAkGA1UEBhMCVVMxEzARBgNVBAgTCkNhbGlmb3JuaWExFjAUBgNVBAcTDVNhbiBG
cmFuY2lzY28xGTAXBgNVBAoTEG9yZzEuZXhhbXBsZS5jb20xHzAdBgNVBAMTFnRs
c2NhLm9yZzEuZXhhbXBsZS5jb20wHhcNMTkwNzMxMTMwNTIwWhcNMjkwNzI4MTMw
NTIwWjB2MQswCQYDVQQGEwJVUzETMBEGA1UECBMKQ2FsaWZvcm5pYTEWMBQGA1UE
BxMNU2FuIEZyYW5jaXNjbzEZMBcGA1UEChMQb3JnMS5leGFtcGxlLmNvbTEfMB0G
A1UEAxMWdGxzY2Eub3JnMS5leGFtcGxlLmNvbTBZMBMGByqGSM49AgEGCCqGSM49
AwEHA0IABHyTsgZsKPlaKKDqeyo30EuNUHV4YmOYGp2b9fdO5guRhmHv41cjwiDl
XR1iPb6dI5a7trbm6JbJKychvbFETDSjXzBdMA4GA1UdDwEB/wQEAwIBpjAPBgNV
HSUECDAGBgRVHSUAMA8GA1UdEwEB/wQFMAMBAf8wKQYDVR0OBCIEIL5rNM2HbSN7
hVYerDrO2iemd0ECp5hcCtuHMWfXD+5CMAoGCCqGSM49BAMCA0cAMEQCIDwS7iXV
ASdz+eCyZhSFV1lXoPOwemJFIVkhwnFvpZsdAiBIgWmJiEgMWctMpVmMoiRPShF6
oGPFr3C3Ghx6c0wV0w==
-----END CERTIFICATE-----
```

#### 11.7. tls/server.crt

```
-----BEGIN CERTIFICATE-----
MIICZjCCAg2gAwIBAgIQGHOeyTimQWHzlmxHPnB5vTAKBggqhkjOPQQDAjB2MQsw
CQYDVQQGEwJVUzETMBEGA1UECBMKQ2FsaWZvcm5pYTEWMBQGA1UEBxMNU2FuIEZy
YW5jaXNjbzEZMBcGA1UEChMQb3JnMS5leGFtcGxlLmNvbTEfMB0GA1UEAxMWdGxz
Y2Eub3JnMS5leGFtcGxlLmNvbTAeFw0xOTA3MzExMzA1MjBaFw0yOTA3MjgxMzA1
MjBaMFsxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpDYWxpZm9ybmlhMRYwFAYDVQQH
Ew1TYW4gRnJhbmNpc2NvMR8wHQYDVQQDExZwZWVyMC5vcmcxLmV4YW1wbGUuY29t
MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAE8+3M3UGZvITZ/d8HCZUYqngVWOwl
7R49PTTWbszlBM4Jd/mG+SdK2KrFvxfvJcbGv0DHLTjRMBbDOKLtnnGcUqOBlzCB
lDAOBgNVHQ8BAf8EBAMCBaAwHQYDVR0lBBYwFAYIKwYBBQUHAwEGCCsGAQUFBwMC
MAwGA1UdEwEB/wQCMAAwKwYDVR0jBCQwIoAgvms0zYdtI3uFVh6sOs7aJ6Z3QQKn
mFwK24cxZ9cP7kIwKAYDVR0RBCEwH4IWcGVlcjAub3JnMS5leGFtcGxlLmNvbYIF
cGVlcjAwCgYIKoZIzj0EAwIDRwAwRAIgRipCHsrvcbvKbR8FUd4nIWuBGnQujmyp
UZ6LH2uYek4CIENIbvLQpzf9EHCCM6F1cDP6rQc1W5fMAwlrXm4F1fs6
-----END CERTIFICATE-----
```

<br />
<br />

## TO DO. 使用私钥验证证书

找到相应证书的私钥


<br />
<br />

## TO DO. configtxgen工具的使用

关于configtxgen的工具的使用课程: https://courses.pragmaticpaths.com/courses/hyperledger-fabric/lectures/6154628


问题: 如何采用configtxgen查看genesis block?

configtxgen -inspectBlock

明天: https://hyperledgercn.github.io/hyperledgerDocs/configtxgen_zh/

明天: https://github.com/CATechnologies/blockchain-tutorials/wiki/Tutorial:-Hyperledger-Fabric-v1.1-%E2%80%93-Create-a-Development-Business-Network-on-zLinux#create-channeltx-and-the-genesis-block-using-the-configtxgen-tool