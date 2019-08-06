## 1. chaincode

Question 1: what is chaincode

Chaincode is the term for programs that run on top of the blockchain to implement the business logic of how applications interact with the ledger. For example, when a transaction is proposed, it triggers chaincode that decides what state change should be applied to the ledger.

Chaincode runs in a secured Docker container isolated from the endorsing peer process. Chaincode initializes and manages ledger state through transactions submitted by applications.




Question 2: how chaincode is installed in blockchain? any certificate mechanism?

Chaincode is assigned by a peer.

Chaincode should be installed by all peers.




Question 3: chaincode security?




Question 4: chaincode endorsement policy?

