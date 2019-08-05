本节整理上一节的Orderer和Peer证书之间的逻辑关系；同时，整理User证书的业务逻辑关系。

<br />

## 1. Admin@org1.example.com用户
**步骤1.1.** 创建Admin@org1.example.com文件夹，该文件夹包括超级用户运行时所需的全部文件。

```shell
~/fabric-samples$ mkdir Admin@org1.example.com
```

**步骤1.2.** 复制证书。

```shell
~/fabric-samples$ cp -rf certs/peerOrganizations/org1.example.com/users/Admin\@org1.example.com/* Admin\@org1.example.com/
```

**步骤1.3.** 复制core.yaml文件。

```shell
~/fabric-samples$ cp peer0.org1.example.com/core.yaml  Admin\@org1.example.com/
```

**步骤1.4.** 为了方便，创建peer.sh文件，该文件包含Admin@org1.example.com用户的启动参数。

```shell
~/fabric-samples$ cd Admin@org1.example.com
~/fabric-samples/Admin@org1.example.com$ touch peer.sh
```

并往peer.sh文件中写入如下内容。

```shell
#!/bin/bash
PATH=`pwd`/../bin:$PATH

export FABRIC_CFG_PATH=`pwd`

export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_TLS_CERT_FILE=./tls/client.crt
export CORE_PEER_TLS_KEY_FILE=./tls/client.key

export CORE_PEER_MSPCONFIGPATH=./msp
export CORE_PEER_ADDRESS=peer0.org1.example.com:7051
export CORE_PEER_LOCALMSPID=Org1MSP
export CORE_PEER_TLS_ROOTCERT_FILE=./tls/ca.crt
export CORE_PEER_ID=cli
export CORE_LOGGING_LEVEL=INFO

peer $*
```

**步骤1.5.** 测试该peer.sh脚本。

```shell
~/fabric-samples/Admin@org1.example.com$ sudo chmod +x peer.sh
~/fabric-samples/Admin@org1.example.com$ ./peer.sh node status
status:STARTED 
2019-06-09 21:11:57.040 HKT [main] main -> INFO 001 Exiting.....
```


<br />
<br />



## 2. 分析Admin@org1.example.com的MSP/TLS


#### 2.1. msp/admincerts/Admin@org1.example.com-cert.pem

发现: 该User用户和Peer节点共享同一个Admin证书。


/certs/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp/admincerts/Admin@org1.example.com-cert.pem

```shell
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




#### 2.2. msp/cacerts/ca.org1.example.com-cert.pem

发现: 该User用户和Peer节点共享一个ca证书。


```shell
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



#### 2.3. msp/keystore/

发现: 该User的私钥和Peer的私钥不一致。


```shell
-----BEGIN PRIVATE KEY-----
MIGHAgEAMBMGByqGSM49AgEGCCqGSM49AwEHBG0wawIBAQQgJ/RIKpVgxCjZi+7K
rtEVSYPiiqdDhWCWBLChx7/cpiehRANCAARHHzGN6PsULh9nzgXjq7S47wxfDOOC
taG8x3D6vrT/jUxlXEwMqaUSw7ucrCaqYfqWw5XVUKyyavvTHYRrkfUO
-----END PRIVATE KEY-----
```


#### 2.4. msp/signcerts/Admin@org1.example.com-cert.pem

发现: 该User的证书和Peer的admin证书相同。

```shell
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




#### 2.5. msp/tlscacerts/tlsca.org1.example.com-cert.pem

发现: 该User的tlsca证书和Peer的tlsca证书相同。


```shell
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



#### 2.6. tls/ca.crt

发现: 该User的tls的ca证书和Peer的tls的ca证书相同。

```shell
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



#### 2.7. tls/client.crt
```shell
-----BEGIN CERTIFICATE-----
MIICOzCCAeKgAwIBAgIRAMCNmF3pxQA4LNUteRbF69EwCgYIKoZIzj0EAwIwdjEL
MAkGA1UEBhMCVVMxEzARBgNVBAgTCkNhbGlmb3JuaWExFjAUBgNVBAcTDVNhbiBG
cmFuY2lzY28xGTAXBgNVBAoTEG9yZzEuZXhhbXBsZS5jb20xHzAdBgNVBAMTFnRs
c2NhLm9yZzEuZXhhbXBsZS5jb20wHhcNMTkwNzMxMTMwNTIwWhcNMjkwNzI4MTMw
NTIwWjBbMQswCQYDVQQGEwJVUzETMBEGA1UECBMKQ2FsaWZvcm5pYTEWMBQGA1UE
BxMNU2FuIEZyYW5jaXNjbzEfMB0GA1UEAwwWQWRtaW5Ab3JnMS5leGFtcGxlLmNv
bTBZMBMGByqGSM49AgEGCCqGSM49AwEHA0IABBdQ5vTKzGHj2yQe+GYWmDaaJMlu
FPf3WodwvAzNLzWp980evD2d3ICCz7moyX/dcJFt8pq/kV5ll29a076e6VajbDBq
MA4GA1UdDwEB/wQEAwIFoDAdBgNVHSUEFjAUBggrBgEFBQcDAQYIKwYBBQUHAwIw
DAYDVR0TAQH/BAIwADArBgNVHSMEJDAigCC+azTNh20je4VWHqw6ztonpndBAqeY
XArbhzFn1w/uQjAKBggqhkjOPQQDAgNHADBEAiBPr+et4yy4ve0K4CtleBnfdkL9
q9Uh5TRP+Z+sv8j3sAIgAegqFPDFLVNb1EqOauY8RvF94SLkEeo4z0LGpOzOyx0=
-----END CERTIFICATE-----
```


#### 2.8. tls/client.key
```shell
-----BEGIN PRIVATE KEY-----
MIGHAgEAMBMGByqGSM49AgEGCCqGSM49AwEHBG0wawIBAQQgFrp2UlEs0iJ6JZdP
8lOH2yDr8h5I/QlqR0OREQHVZdqhRANCAAQXUOb0ysxh49skHvhmFpg2miTJbhT3
91qHcLwMzS81qffNHrw9ndyAgs+5qMl/3XCRbfKav5FeZZdvWtO+nulW
-----END PRIVATE KEY-----
```



## 3. 如何验证

下一步解决User在接入Peer的时候，证书验证如何工作？


https://hyperledger-fabric.readthedocs.io/en/release-1.4/_images/membership.diagram.4.png

Local and channel MSPs. The trust domain (e.g., the organization) of each peer is defined by the peer's local MSP, e.g., ORG1 or ORG2. Representation of an organization on a channel is achieved by adding the organization's MSP to the channel configuration. For example, the channel of this figure is managed by both ORG1 and ORG2. Similar principles apply for the network, orderers and users, but these are not shown here for simplicity.

You may find it helpful to see how local and channel MSPs are used by seeing what happens when a blockchain administrator installs and instantiates a smart contract, as shown in the diagram. See https://hyperledger-fabric.readthedocs.io/en/release-1.4/membership/membership.html.





下一步: openssl使用使用私钥，构造证书链；同时，反复读取官方解释。


下一步: 完成Block/Channel中配置信息的解析，分析。



## 参考资料
[1. Hyperledger TLS/MSP的解释] https://hyperledger-fabric.readthedocs.io/en/release-1.4/membership/membership.html


