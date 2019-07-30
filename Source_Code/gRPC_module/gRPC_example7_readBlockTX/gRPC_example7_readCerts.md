## 1. 关于证书链的使用

关于TLS/MSP： https://www.geek-share.com/detail/2728217061.html



TLS的KEY,CERT: https://medium.com/coinmonks/designing-a-hyperledger-fabric-network-7adcd78dabc3


MSP的框架：https://hyperledger-fabric.readthedocs.io/en/release-1.2/idemix.html




## 2. Blog1: https://www.cnblogs.com/wzjwffg/p/9882870.html

x509证书包含三种文件: key, csr和crt。

其中，key是私钥；csr是证书请求文件，用于申请证书，在制作csr文件的时候，必须使用自己的私钥来签署申请，还可以设定一个密钥；crt是CA认证后的证书，是证书认证者用自己的私钥给你签署的一个证书。

根证书是CA认证中心给自己颁发的证书，是证书链的起点。任何安装CA根证书的服务器都意味着该服务器是可信任的，也是信任的原点。


数字证书是由证书认证机构对证书申请者的真实身份认证之后，用CA的根证书对申请人的一些基本信息以及申请人的公钥进行签名后形成的一个数字文件。数字证书包含有证书所标识的公钥。该证书的真实性由颁发机构保证。



#### 2.1. openssl的后缀文件

.key格式: 私钥
.csr格式: 用户证书申请请求,包含有用户的公钥
.crt格式: 证书文件
.crl格式: 证书吊销列表
.pem格式: 用于导入导出证书的时候的证书格式



#### 2.2. CA根证书的生成步骤

```shell
# ca.key: 生成根证书服务器的私钥
$ openssl genrsa -out ca.key 2048 

# ca.csr: 根证书申请请求
$ openssl req -new -key ca.key -out ca.csr

# ca.crt: 根证书服务器的私钥签署根证书请求，得到自签名的根证书
$ openssl x509 -req -days 365 -in ca.csr -signkey ca.key -out ca.crt 
```

在实际软件开发工作中，往往服务器采用self signed certificate自签名的方式。


When the CA is started for the first time, it will generate all of its required state and writes this state to the directory given in its configuration. The certificates for the CA services are self-signed as the current default. If those certificates shall be signed by some root CA, this ca be done manually by using the private and public keys in the CA state directory, and replacing the self-signed certificates with root-signed ones.

参考: https://openblockchain.readthedocs.io/en/latest/Setup/ca-setup/


#### 2.3. 用户证书的生成步骤

```shell
# server.key: 用户服务器的私钥
$ openssl genrsa -des3 -out server.key 1024

# server.csr: 用户证书申请请求
$ openssl req -new -key server.key -out server.csr

# server.crt: 根服务器的私钥ca.key签署用户证书
openssl ca -in server.csr -out /home/joe/go/src/readCerts/server.crt -cert ca.crt -keyfile ca.key 
```



可能遇到的问题："Using configuration from /usr/lib/ssl/openssl.cnf
I am unable to access the ./demoCA/newcerts directory
./demoCA/newcerts: No such file or directory"，参考解决方案:https://ubuntuforums.org/showthread.php?t=2353936

可能遇到serial的问题:
https://stackoverflow.com/questions/39270992/creating-self-signed-certificates-with-open-ssl-on-windows

```shell
# 根目录下
mkdir ./demoCA
mkdir ./demoCA/newcerts
mkdir ./demoCA/certs
mkdir ./demoCA/crl
cd ./demoCA
echo 00 > serial
touch index.txt
```