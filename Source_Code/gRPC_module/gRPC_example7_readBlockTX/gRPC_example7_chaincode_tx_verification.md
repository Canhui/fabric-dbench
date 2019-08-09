## 0. chaincode ownership

Chaincode should only be installed on endorsing peer nodes of the owning members of the chaincode to protect the confidentiality of the chaincode logic from other members on the network. Those members without chaincode, cannot be the endorsers of the chaincode's transactions; that is, they cannot execute the chaincode. However, they can still validate and commit the transactions to the ledger.




## 1. chaincode concept

Question 1: what is chaincode

Chaincode is the term for programs that run on top of the blockchain to implement the business logic of how applications interact with the ledger. For example, when a transaction is proposed, it triggers chaincode that decides what state change should be applied to the ledger.

Chaincode runs in a secured Docker container isolated from the endorsing peer process. Chaincode initializes and manages ledger state through transactions submitted by applications.

All peers need to update the ledger, so all peers do Validate step. But not every peer needs to Execute the smart contract. Hyperledger Fabric uses endorsement policies to define which peers need to execute which transactions. This means that a given chaincode can be kept private from peers that are not part of the endorsement policy.


Question 2: how chaincode is installed in blockchain? any certificate mechanism?

Chaincode is assigned by a peer.

Chaincode should be installed by all peers.

Refer to: https://medium.com/kokster/understanding-hyperledger-fabric-chaincode-e7767d50f0b4



Question 3: what is the relationship between chaincode and channel?

Assets are created and updated by a specific chaincode, and cannot be accessed by another chaincode. Applications interact with the blockchain ledger through the chaincode. Therefore, the chaincode needs to be installed on every peer that will endorse a transaction and instantiated on the channel.


Question 4: how docker container access local files?


Question 5: chaincode endorsement policy?

Refer to: https://hyperledger-fabric.readthedocs.io/en/release-1.2/endorsement-policies.html

Refer to: https://medium.com/kokster/hyperledger-fabric-endorsing-transactions-3c1b7251a709



<br />
<br />



## 2. chaincode running mechanism

chaincode running mechanism
https://stackoverflow.com/questions/51053553/how-can-be-a-chaincode-executed-in-parallel

下一步:验证chaincode通过grpc端口通信和peer节点？


Docker access host Example 1:

https://dev.to/bufferings/access-host-from-a-docker-container-4099

https://github.com/bufferings/docker-access-host

https://community.wia.io/d/15-accessing-the-host-from-inside-a-docker-container



<br />
<br />

## 3. docker host and isolated containers

https://docs.docker.com/v17.09/engine/userguide/networking/images/network_access.png



## 4. Probelm: the typical issue here is that the chaincode container will not be able to communicate with the peer itself



## 5. possible solution

To ensure communication via container names, these containers are needed to linked with each other in a one way or another. Docker0 bridge allows port mapping and linking to allow communication between container and host.https://www.google.com/search?ei=tdVMXeDfFJXchwO6wJjABA&q=host+how+to+communication+with+container&oq=host+how+to+communication+with+container&gs_l=psy-ab.3..33i160l2.329422.335477..335646...4.0..1.113.2990.37j2....2..0....1..gws-wiz.......0i71j0j0i10j0i22i30j0i22i10i30j33i22i29i30j33i22i10i29i30.RK_IbY0Az4o&ved=&uact=5




#### 5.1. port mapping (Docker0 bridge)

example 1: https://cloudkul.com/blog/understanding-communication-docker-containers/

example 2: https://runnable.com/docker/binding-docker-ports

All docker ports are exposed to a specific host port. Then host sends something to docker and docker replies to host port. Port 7053 is the 





#### 5.2. port linking (Docker0 bridge)

example 1: https://docs.docker.com/network/links/







## Reference
[1. Official Chaincode Initialization] https://hyperledger-fabric.readthedocs.io/en/release-1.4/chaincode4noah.html