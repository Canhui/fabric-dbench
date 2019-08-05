## 1. 关于证书链

x509证书包含三种文件: key, csr和crt。

其中，key是私钥；csr是证书请求文件，用于申请证书，在制作csr文件的时候，必须使用自己的私钥来签署申请，还可以设定一个密钥；crt是CA认证后的证书，是证书认证者用自己的私钥给你签署的一个证书。

根证书是CA认证中心给自己颁发的证书，是证书链的起点。任何安装CA根证书的服务器都意味着该服务器是可信任的，也是信任的原点。

数字证书是由证书认证机构对证书申请者的真实身份认证之后，用CA的根证书对申请人的一些基本信息以及申请人的公钥进行签名后形成的一个数字文件。数字证书包含有证书所标识的公钥。该证书的真实性由颁发机构保证。

.key格式: 私钥
.csr格式: 用户证书申请请求,包含有用户的公钥
.crt格式: 证书文件
.crl格式: 证书吊销列表
.pem格式: 用于导入导出证书的时候的证书格式

When the CA is started for the first time, it will generate all of its required state and writes this state to the directory given in its configuration. The certificates for the CA services are self-signed as the current default. If those certificates shall be signed by some root CA, this ca be done manually by using the private and public keys in the CA state directory, and replacing the self-signed certificates with root-signed ones.

参考: https://openblockchain.readthedocs.io/en/latest/Setup/ca-setup/

关于TLS/MSP： https://www.geek-share.com/detail/2728217061.html

TLS的KEY,CERT: https://medium.com/coinmonks/designing-a-hyperledger-fabric-network-7adcd78dabc3

MSP的框架：https://hyperledger-fabric.readthedocs.io/en/release-1.2/idemix.html





## 2. 证书链的例子

#### 2.0. 问题和环境清理

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


#### 2.1. CA根证书的生成步骤

```shell
# RootCA.key: 生成根证书服务器的私钥
$ openssl genrsa -des3 -out keys/RootCA.key 2048

# RootCA.crt: 根证书服务器的私钥签署根证书请求，得到自签名的根证书
$ openssl req -new -x509 -days 3650 -key keys/RootCA.key -out keys/RootCA.crt
```

注，其中Common Name写入RootCA。


#### 2.2. 二级证书的生成步骤

```shell
# SecondCA.key: 生成二级证书的私钥
$ openssl genrsa -des3 -out keys/secondCA.key 2048
$ openssl rsa -in keys/secondCA.key -out keys/secondCA.key
$ openssl req -new -days 3650 -key keys/secondCA.key -out keys/secondCA.csr
$ openssl ca -extensions v3_ca -in keys/secondCA.csr -days 3650 -out keys/secondCA.crt -cert keys/RootCA.crt -keyfile keys/RootCA.key
```

注，其中Common Name写入SecondCA。


#### 2.3. 三级证书的生成步骤

```shell
# ThirdCA.key: 生成三级证书的私钥
$ openssl genrsa -des3 -out keys/thirdCA.key 2048
$ openssl rsa -in keys/thirdCA.key -out keys/thirdCA.key
$ openssl req -new -days 3650 -key keys/thirdCA.key -out keys/thirdCA.csr
$ openssl ca -extensions v3_ca -in keys/thirdCA.csr -days 3650 -out keys/thirdCA.crt -cert keys/secondCA.crt -keyfile keys/secondCA.key
```
注，其中Common Name写入ThirdCA。


#### 2.4. 证书格式转换

.crt证书也可以转换成.pem格式，命令如下，

```shell
$ openssl x509 -in RootCA.crt -out RootCA_crt.pem
```


#### 2.5. 证书认证/验证

自签名证书RootCA_crt.pem的验证，命令如下，

```shell
$ openssl verify RootCA_crt.pem
RootCA_crt.pem: C = AU, ST = Some-State, O = Internet Widgits Pty Ltd, CN = RootCA
error 18 at 0 depth lookup:self signed certificate
OK
```

验证RootCA_crt.pem是否签发secondCA_crt.pem证书，如下，
```shell
$ openssl verify -CAfile RootCA_crt.pem secondCA_crt.pem
secondCA_crt.pem: OK
```

验证SecondCA_crt.pem是否签发thirdCA_crt.pem证书，如下，

```shell
$ openssl verify -CAfile RootCA_crt.pem -untrusted secondCA_crt.pem thirdCA_crt.pem
```

注，多个中间链的验证`-untrusted intermediate1.pem -untrusted intermediate2.pem`，参考 https://medium.com/@superseb/get-your-certificate-chain-right-4b117a9c0fce 。





#### 2.6. 多链验证问题

If you are using intermediate certificates, you will need to make sure that the application using the certificate is sending the complete chain (including server certificate and intermediate certificate). This depends on the application you are using that uses the certificate. But usually you have to create a file containing the server certificate file and the intermediate certificate file. It is required to put the server certificate file first, and then the intermediat certificate files. 

参考： https://medium.com/@superseb/get-your-certificate-chain-right-4b117a9c0fce



<br />
<br />

## 下一步

.pem转化为private key: https://stackoverflow.com/questions/13732826/convert-pem-to-crt-and-key

https://stackoverflow.com/questions/19979171/how-to-convert-pem-into-key


关于证书验证的过程，







## 参考资料

关于证书链的图示：https://www.pianyissl.com/support/page/10

关于证书链的验证: https://medium.com/@superseb/get-your-certificate-chain-right-4b117a9c0fce


证书链的验证: https://www.poftut.com/verify-certificate-chain-openssl/

证书链的解释：https://blog.csdn.net/hanghang121/article/details/51774579































