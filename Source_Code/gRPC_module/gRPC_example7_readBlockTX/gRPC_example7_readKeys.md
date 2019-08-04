## 1. About Public Key

Hyperledger does use a Public Key Infrastructure framework. The "Public and Private Keys" heading in the document about the Hyperledger Fabric explains enrollment certificates and transaction certificates. As the above document topic mentions, the Hyperledger protocol specification is also a good reference. A couple of sections are most applicable. 

Public keys for users are stored on the file system where user enrollment was initiated, so this makes sharing the public key simpler. Hyperledger version 0.6 uses elliptic curve certificates. Native encryption is not provided for the elliptic curve certificate itself, so the contents of the public key are readable. If there is a desire to use a derivation scheme such as ECIES, that can be done.

The results of following the Hyperledger Fabric client example can be used for reference. Within the SDK Demo 


## 2. Where is the public key

