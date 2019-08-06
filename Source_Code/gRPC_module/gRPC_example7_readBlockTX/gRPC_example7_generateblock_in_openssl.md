
## 1. 线索

The cert that you place in `signcerts` and the cert you place in `admincerts` must be signed or issued by the root or intermediate certs in the intermediatecerts directory.


## 2. Openssl TLS原理

SSL是安全套接层(Secure Socket Layer)的缩写，而TLS表示传输层安全(Transport Layer Security)的缩写。SSL最初由网景公司提出，最初目的是为了保护web安全，然而现在用来提高传输层的安全。TLS是IETF基于SSLv3制定的标准，两者基本一致，只是些许的差别。首先我们来看一下SSLv3/TLS协议在TCP/IP协议栈中的位置，通常我们认为SSLv3/TLS处于传输层和应用层之间。

https://www.freecodecamp.org/news/openssl-command-cheatsheet-b441be1e8c4a/

https://www.poftut.com/use-openssl-s_client-check-verify-ssltls-https-webserver/


今晚: https://github.com/denji/golang-tls

今晚: https://gist.github.com/denji/12b3a568f092ab951456


gRPC TLS: https://bbengfort.github.io/programmer/2017/03/03/secure-grpc.html

gRPC TLS: https://medium.com/pantomath/how-we-use-grpc-to-build-a-client-server-system-in-go-dd20045fa1c2

gRPC TLS中文: https://segmentfault.com/a/1190000016601783


OpenSSL证书教程: https://jamielinux.com/docs/openssl-certificate-authority/appendix/index.html

关键博客: https://blog.didiyun.com/index.php/2018/12/12/grpc-golang-1/

证书基本概念: https://www.jianshu.com/p/41f7ae43e37b


TLS的原理:https://hacpai.com/article/1447920990604








## 3. MEDIUM博客


https://medium.com/ibm-garage/using-3rd-party-root-cas-in-hyperledger-fabric-3cafa91d1260








## Reference
[1. signcerts/admincerts] https://stackoverflow.com/questions/47819069/hyperledger-fabric-cannot-build-network-from-my-own-ca?rq=1

[2. MSP/TLS tutorial] file:///C:/Users/chwang/Downloads/hyperledger-fabric-blockchain-integration-guide.pdf

[3. Do this] https://medium.com/ibm-garage/using-3rd-party-root-cas-in-hyperledger-fabric-3cafa91d1260

