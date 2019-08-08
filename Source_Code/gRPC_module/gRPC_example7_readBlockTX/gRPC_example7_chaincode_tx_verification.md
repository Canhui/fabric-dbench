## 1. chaincode

Question 1: what is chaincode

Chaincode is the term for programs that run on top of the blockchain to implement the business logic of how applications interact with the ledger. For example, when a transaction is proposed, it triggers chaincode that decides what state change should be applied to the ledger.

Chaincode runs in a secured Docker container isolated from the endorsing peer process. Chaincode initializes and manages ledger state through transactions submitted by applications.

All peers need to update the ledger, so all peers do Validate step. But not every peer needs to Execute the smart contract. Hyperledger Fabric uses endorsement policies to define which peers need to execute which transactions. This means that a given chaincode can be kept private from peers that are not part of the endorsement policy.






Question 2: how chaincode is installed in blockchain? any certificate mechanism?

Chaincode is assigned by a peer.

Chaincode should be installed by all peers.

Refer to: https://medium.com/kokster/understanding-hyperledger-fabric-chaincode-e7767d50f0b4





Question 3: chaincode security?








Question 4: chaincode endorsement policy?

Refer to: https://hyperledger-fabric.readthedocs.io/en/release-1.2/endorsement-policies.html

Refer to: https://medium.com/kokster/hyperledger-fabric-endorsing-transactions-3c1b7251a709

