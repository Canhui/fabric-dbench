## 1. configtxgen介绍

configtxgen的功能如下，

Function 1: create the first block in the Blockchain.
Function 2: create channel transaction.
Function 3: create anchor peer transaction.

The configtxgen tool does not have any dependency on runtime. TX file may be signed by multiple admins using the Peer command. 









## 2. configtxgen工具的使用

关于configtxgen的工具的使用课程: https://courses.pragmaticpaths.com/courses/hyperledger-fabric/lectures/6154628


问题: 如何采用configtxgen查看genesis block?

configtxgen -inspectBlock

参考资料: https://hyperledgercn.github.io/hyperledgerDocs/configtxgen_zh/


