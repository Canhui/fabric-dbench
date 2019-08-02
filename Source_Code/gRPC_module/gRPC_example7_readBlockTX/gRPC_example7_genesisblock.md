## 1. genesis block

Question 1: why we need genesis block?

The configuration block that initializes a blockchain network or channel, and also serves as the first block on a chain.

The first block in the chain, which contains the channel's initial configuration. [medium](https://medium.com/kokster/understanding-hyperledger-fabric-channel-lifecycle-a546670646e3)

It is important to understand how the genesis block is used here. The genesis block contains the channel's configuration, including information about the orderer. Here, it is passed as an argument to the JoinChannel function. When the JoinChannel function executes on the peer, it uses the genesis block to start a local copy of the ledger. Now that the peer has the channel's genesis block, it known how to connect to the orderer so it can receive the rest of the blocks in the chain.




## 关于genesis block的解读

https://hyperledger-fabric.readthedocs.io/en/release-1.4/commands/configtxgen.html

When a peer joins the blockchain network, the ledger enclave is initialized by the admin with the genesis block, which contains the blockchain configuration and the expected hash (mrenclave) of the ledger enclave.


## Question: enabled TLS mode and genesis block?

