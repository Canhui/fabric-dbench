## 1. Hyperledger的证书链分析

Hyperledger Fabric的证书的介绍[证书介绍](https://www.cnblogs.com/preminem/p/7874710.html)。


Question: 为什么我们需要证书？这些证书用来干什么？


https://zhuanlan.zhihu.com/p/35855729



## 2. 关于local msp和channel msp的区别？

核心官方解释: https://hyperledger-fabric.readthedocs.io/en/release-1.4/membership/membership.html

英文原文: https://hyperledgercn.github.io/hyperledgerDocs/msp_zh/
中文博客: https://blog.csdn.net/maixia24/article/details/79809759

Channel MSP金在其应用的节点或者用户的文件系统下定义。在物理意义上，每个节点或者用户只有一个Local MSP。

虽然每个节点的本地文件系统上存在每个Channel MSP的副本，但是逻辑层面上，Channel MSP驻留在网络层面，并需要共识维护。



关于组织的定义：hyperledger的组织代表一组拥有共同信任的根证书的成员，这些成员由于拥有同样的信任根，彼此之间的信任程度很高。






## 3. 关于MSP中各个字段的解释？

MSP中各个文件字段的解释：https://medium.com/@grsind19/hyperledger-development-with-in-21-days-day-8-6eb1351d0cee

MSP中每个文件字段的解释：https://hyperledgercn.github.io/hyperledgerDocs/msp_zh/

为什么要区别管理员证书和Root证书？It is important to set MSP admin certificates to be different than any of the certificates considered by the MSP for root of trust, or intermediate CAs. This is a common security practice to separate the duties of management of membership components from the issuing of new certificates and/or validation of existing ones.


下一步：结合具体的实验走一边。





## 1. msp


#### 1.1. msp/admincerts/Admin@example.com-cert.pem

发现一: Admin@example.com-cert.pem不是自签名证书。

```
-----BEGIN CERTIFICATE-----
MIICCjCCAbCgAwIBAgIQDaAfg5kogfd83+yyvFpXaTAKBggqhkjOPQQDAjBpMQsw
CQYDVQQGEwJVUzETMBEGA1UECBMKQ2FsaWZvcm5pYTEWMBQGA1UEBxMNU2FuIEZy
YW5jaXNjbzEUMBIGA1UEChMLZXhhbXBsZS5jb20xFzAVBgNVBAMTDmNhLmV4YW1w
bGUuY29tMB4XDTE5MDcyODEzMTM0NloXDTI5MDcyNTEzMTM0NlowVjELMAkGA1UE
BhMCVVMxEzARBgNVBAgTCkNhbGlmb3JuaWExFjAUBgNVBAcTDVNhbiBGcmFuY2lz
Y28xGjAYBgNVBAMMEUFkbWluQGV4YW1wbGUuY29tMFkwEwYHKoZIzj0CAQYIKoZI
zj0DAQcDQgAEmAyxiXUV8EuP144+4+TtXVIefcCyoOeUjrZ1eb05yyWvgk9bzIrs
TlJDU3ZiosRoJNCYkAENdvum2sKfudWLdKNNMEswDgYDVR0PAQH/BAQDAgeAMAwG
A1UdEwEB/wQCMAAwKwYDVR0jBCQwIoAgwjXiOUoIMV9S9kjZL8NwA2jUqclCMlnu
IZQnwAb5PoEwCgYIKoZIzj0EAwIDSAAwRQIhAO/cttSUm+iW5Ls6ooTjikq+whIJ
zyfzOPoNCM4vt121AiAI4HaBYCVWZQNvQ0Ujn7gOgYTuiRL3tHS48Rmv16ZYPw==
-----END CERTIFICATE-----
```



#### 1.2. msp/cacerts/ca.example.com-cert.pem

发现一: ca.example.com-cert.pem是自签名证书。

```
-----BEGIN CERTIFICATE-----
MIICLzCCAdWgAwIBAgIQNEovB3G3ZepDCpYP/cBA5DAKBggqhkjOPQQDAjBpMQsw
CQYDVQQGEwJVUzETMBEGA1UECBMKQ2FsaWZvcm5pYTEWMBQGA1UEBxMNU2FuIEZy
YW5jaXNjbzEUMBIGA1UEChMLZXhhbXBsZS5jb20xFzAVBgNVBAMTDmNhLmV4YW1w
bGUuY29tMB4XDTE5MDcyODEzMTM0NloXDTI5MDcyNTEzMTM0NlowaTELMAkGA1UE
BhMCVVMxEzARBgNVBAgTCkNhbGlmb3JuaWExFjAUBgNVBAcTDVNhbiBGcmFuY2lz
Y28xFDASBgNVBAoTC2V4YW1wbGUuY29tMRcwFQYDVQQDEw5jYS5leGFtcGxlLmNv
bTBZMBMGByqGSM49AgEGCCqGSM49AwEHA0IABBKpR3M/AU6sdjnolR5BtB6CX/RP
EnmLvrvCgNQIFbEqHrC510+vCb/0aZ1/ZQk3Gzvjo5k57Gh+YyfgwVmadQGjXzBd
MA4GA1UdDwEB/wQEAwIBpjAPBgNVHSUECDAGBgRVHSUAMA8GA1UdEwEB/wQFMAMB
Af8wKQYDVR0OBCIEIMI14jlKCDFfUvZI2S/DcANo1KnJQjJZ7iGUJ8AG+T6BMAoG
CCqGSM49BAMCA0gAMEUCIQD4/9bDY8YAkFYXT1X233fGQuKziVDhgJ2aygQgSXJk
CQIgNnsnW91NnSpkp6p+icvyw0nXM2mf08mvifbPGwm4jQE=
-----END CERTIFICATE-----
```

该自签名证书的公钥，

```shell
$ openssl x509 -in ca.example.com-cert.pem -noout -text
04:12:a9:47:73:3f:01:4e:ac:76:39:e8:95:1e:41:
b4:1e:82:5f:f4:4f:12:79:8b:be:bb:c2:80:d4:08:
15:b1:2a:1e:b0:b9:d7:4f:af:09:bf:f4:69:9d:7f:
65:09:37:1b:3b:e3:a3:99:39:ec:68:7e:63:27:e0:
c1:59:9a:75:01
```


#### 1.3. msp/keystore/1e59dbadb036ad4_sk

```
1e59dbadb03668851cbfb6f6d6fe11fa912cdc8b554a123a0a46112b2fbedad4_sk
```



#### 1.4. msp/signcerts/orderer.example.com-cert.pem

发现一: orderer.example.com-cert.pem不是自签名证书。

```
-----BEGIN CERTIFICATE-----
MIICCzCCAbKgAwIBAgIQV09wHzE/v86iHSAix2XapzAKBggqhkjOPQQDAjBpMQsw
CQYDVQQGEwJVUzETMBEGA1UECBMKQ2FsaWZvcm5pYTEWMBQGA1UEBxMNU2FuIEZy
YW5jaXNjbzEUMBIGA1UEChMLZXhhbXBsZS5jb20xFzAVBgNVBAMTDmNhLmV4YW1w
bGUuY29tMB4XDTE5MDcyODEzMTM0NloXDTI5MDcyNTEzMTM0NlowWDELMAkGA1UE
BhMCVVMxEzARBgNVBAgTCkNhbGlmb3JuaWExFjAUBgNVBAcTDVNhbiBGcmFuY2lz
Y28xHDAaBgNVBAMTE29yZGVyZXIuZXhhbXBsZS5jb20wWTATBgcqhkjOPQIBBggq
hkjOPQMBBwNCAAQhqLCkdaHNVWWBSa4PE2UlY/L0OUaZ175eMy5/l6HEzKuw6fof
96UCKJ5dm9GamfBy3Zf+rOGZhY2KrC52GOfao00wSzAOBgNVHQ8BAf8EBAMCB4Aw
DAYDVR0TAQH/BAIwADArBgNVHSMEJDAigCDCNeI5SggxX1L2SNkvw3ADaNSpyUIy
We4hlCfABvk+gTAKBggqhkjOPQQDAgNHADBEAiAa93qFmvHBopkKxIbcMHFNpT2n
5V+104QwrQ65cN/avwIgLpyQ8QgVUvb4hbD76V7y1SgDXgWCO55ynlnC3BjhKr8=
-----END CERTIFICATE-----
```



#### 1.5. msp/tlscacerts/tlsca.example.com-cert.pem

发现一: msp/tlscacerts/tlsca.example.com-cert.pem是自签名证书

```
-----BEGIN CERTIFICATE-----
MIICNTCCAdygAwIBAgIRANYHt5HFcTdz6h99wK8CSQswCgYIKoZIzj0EAwIwbDEL
MAkGA1UEBhMCVVMxEzARBgNVBAgTCkNhbGlmb3JuaWExFjAUBgNVBAcTDVNhbiBG
cmFuY2lzY28xFDASBgNVBAoTC2V4YW1wbGUuY29tMRowGAYDVQQDExF0bHNjYS5l
eGFtcGxlLmNvbTAeFw0xOTA3MjgxMzEzNDZaFw0yOTA3MjUxMzEzNDZaMGwxCzAJ
BgNVBAYTAlVTMRMwEQYDVQQIEwpDYWxpZm9ybmlhMRYwFAYDVQQHEw1TYW4gRnJh
bmNpc2NvMRQwEgYDVQQKEwtleGFtcGxlLmNvbTEaMBgGA1UEAxMRdGxzY2EuZXhh
bXBsZS5jb20wWTATBgcqhkjOPQIBBggqhkjOPQMBBwNCAASKJFKef5TVsj4tGy6Z
QkRiuUu7HJDCihIRS9VOrOccLiZdgymYZ23G+t1yzZ7puQaETBbqY6AwTnWJTOSY
UBjOo18wXTAOBgNVHQ8BAf8EBAMCAaYwDwYDVR0lBAgwBgYEVR0lADAPBgNVHRMB
Af8EBTADAQH/MCkGA1UdDgQiBCDBBeRmeeogk740lEDY9UUmAYFYkb6bv0F+uvPl
AekOWTAKBggqhkjOPQQDAgNHADBEAiBa+VfGYetHyROrxQDlYvUu5dbU31I542r/
6oFgutFq7gIgKrRslUS4C/K19kj4Zu+VtUr93PlDipa/58p1wY0afjs=
-----END CERTIFICATE-----
```

该自签名证书的公钥，

```shell
$ openssl x509 -in tlsca.example.com-cert.pem -noout -text
04:fb:02:a8:57:f3:1f:0c:01:de:04:6b:bb:2e:63:
ad:d1:51:cc:1d:b7:4c:7c:4b:26:b9:d1:8c:36:5b:
37:a4:8d:fe:b4:9a:26:7c:23:78:4f:20:61:03:d5:
a4:6b:a9:3e:b7:0b:92:67:14:fb:72:69:15:47:50:
07:5a:67:b8:02
```



## 2. tls

#### 2.1. tls/ca.crt

发现一: tls/ca.crt 等价于 msp/tlscacerts/tlsca.example.com-cert.pem

发现二: tls/ca.crt是自签名证书

```
-----BEGIN CERTIFICATE-----
MIICNTCCAdygAwIBAgIRANYHt5HFcTdz6h99wK8CSQswCgYIKoZIzj0EAwIwbDEL
MAkGA1UEBhMCVVMxEzARBgNVBAgTCkNhbGlmb3JuaWExFjAUBgNVBAcTDVNhbiBG
cmFuY2lzY28xFDASBgNVBAoTC2V4YW1wbGUuY29tMRowGAYDVQQDExF0bHNjYS5l
eGFtcGxlLmNvbTAeFw0xOTA3MjgxMzEzNDZaFw0yOTA3MjUxMzEzNDZaMGwxCzAJ
BgNVBAYTAlVTMRMwEQYDVQQIEwpDYWxpZm9ybmlhMRYwFAYDVQQHEw1TYW4gRnJh
bmNpc2NvMRQwEgYDVQQKEwtleGFtcGxlLmNvbTEaMBgGA1UEAxMRdGxzY2EuZXhh
bXBsZS5jb20wWTATBgcqhkjOPQIBBggqhkjOPQMBBwNCAASKJFKef5TVsj4tGy6Z
QkRiuUu7HJDCihIRS9VOrOccLiZdgymYZ23G+t1yzZ7puQaETBbqY6AwTnWJTOSY
UBjOo18wXTAOBgNVHQ8BAf8EBAMCAaYwDwYDVR0lBAgwBgYEVR0lADAPBgNVHRMB
Af8EBTADAQH/MCkGA1UdDgQiBCDBBeRmeeogk740lEDY9UUmAYFYkb6bv0F+uvPl
AekOWTAKBggqhkjOPQQDAgNHADBEAiBa+VfGYetHyROrxQDlYvUu5dbU31I542r/
6oFgutFq7gIgKrRslUS4C/K19kj4Zu+VtUr93PlDipa/58p1wY0afjs=
-----END CERTIFICATE-----
```





#### 2.2. tls/server.crt

发现一: server.crt不是自签名证书。

发现二: ca.crt证书签发了server.crt证书，`openssl verify -CAfile ca.crt server.crt`。

```
-----BEGIN CERTIFICATE-----
MIICWTCCAgCgAwIBAgIRANwFm8qHmjWk1VgR/n/MLeEwCgYIKoZIzj0EAwIwbDEL
MAkGA1UEBhMCVVMxEzARBgNVBAgTCkNhbGlmb3JuaWExFjAUBgNVBAcTDVNhbiBG
cmFuY2lzY28xFDASBgNVBAoTC2V4YW1wbGUuY29tMRowGAYDVQQDExF0bHNjYS5l
eGFtcGxlLmNvbTAeFw0xOTA3MjgxMzEzNDZaFw0yOTA3MjUxMzEzNDZaMFgxCzAJ
BgNVBAYTAlVTMRMwEQYDVQQIEwpDYWxpZm9ybmlhMRYwFAYDVQQHEw1TYW4gRnJh
bmNpc2NvMRwwGgYDVQQDExNvcmRlcmVyLmV4YW1wbGUuY29tMFkwEwYHKoZIzj0C
AQYIKoZIzj0DAQcDQgAEWb3vDpZ0hnHW5ZnI/qU8IA5QhBUZgUmRYrn2QPzfwllT
gpDcEixgcbMh9XFcmTYupQw2xjl2AewonyFRRcby1aOBljCBkzAOBgNVHQ8BAf8E
BAMCBaAwHQYDVR0lBBYwFAYIKwYBBQUHAwEGCCsGAQUFBwMCMAwGA1UdEwEB/wQC
MAAwKwYDVR0jBCQwIoAgwQXkZnnqIJO+NJRA2PVFJgGBWJG+m79Bfrrz5QHpDlkw
JwYDVR0RBCAwHoITb3JkZXJlci5leGFtcGxlLmNvbYIHb3JkZXJlcjAKBggqhkjO
PQQDAgNHADBEAiAJSmpIls0XlYfvi/c7K5vGetPfktgifYD9nz5XZEx2kwIgbT73
8GE5iOmKCznDLLAg9mCfF6QEf57z/kF1REtG0zg=
-----END CERTIFICATE-----
```

#### 2.3. tls/server.key

发现一: server.key是server.crt端的私钥。














## 4. 关于MSP的配置信息在创世区块中的管理？

https://hyperledgercn.github.io/hyperledgerDocs/msp_zh/

hyperledger genesis block MSP: write_set groups, read_set groups

Refers to https://hyperledger-fabric.readthedocs.io/en/release-1.4/configtx.html

read-write set的丰富资料: https://hyperledgercn.github.io/hyperledgerDocs/read-write-set/

read-write set验证交易和更新worldState: https://hyperledgercn.github.io/hyperledgerDocs/read-write-set/


gRPC_genesisblock.md