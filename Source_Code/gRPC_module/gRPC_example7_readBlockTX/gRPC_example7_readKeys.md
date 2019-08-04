## 1. About Public Key

Hyperledger does use a Public Key Infrastructure framework. The "Public and Private Keys" heading in the document about the Hyperledger Fabric explains enrollment certificates and transaction certificates. As the above document topic mentions, the Hyperledger protocol specification is also a good reference. A couple of sections are most applicable. 

Public keys for users are stored on the file system where user enrollment was initiated, so this makes sharing the public key simpler. Hyperledger version 0.6 uses elliptic curve certificates. Native encryption is not provided for the elliptic curve certificate itself, so the contents of the public key are readable. If there is a desire to use a derivation scheme such as ECIES, that can be done.

The results of following the Hyperledger Fabric client example can be used for reference. Within the SDK Demo 


<br />
<br />

## 2. About the Public-Private Key System

If you want the Fabric CA server to use a CA signing certificate and key file which you provide, you must place your files in the location referenced by ca.certfile and ca.keyfile respectively. Both files must be PEM-encoded and must not be encrypted. More specifically, the contents of the CA certificate file must begin with -----BEGIN CERTIFICATE----- and the contents of the key file must begin with -----BEGIN PRIVATE KEY-----.

The CSR can be customized to generate X.509 certificates and keys that support Elliptic Curve (ECDSA). The following setting is an example of the implementation of Elliptic Curve Digital Signature Algorithm (ECDSA) with curve prime256v1 and signature algorithm ecdsa-with-SHA256.







<br />
<br />


## 3. Where is the public key

Question: Where is the keyValStore?



<br />
<br />

## Reference
[1. 关于Hyperledger的公钥私钥体系] https://hyperledger-fabric-ca.readthedocs.io/en/release-1.4/users-guide.html

