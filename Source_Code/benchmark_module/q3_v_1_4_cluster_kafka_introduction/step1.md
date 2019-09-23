## Preliminaries


**Question 1:** What is Zookeeper?

Apache ZooKeeper is an effort to develop and maintain an open-source server which enables highly reliable distributed coordination. ZooKeeper is a centralized service for maintaining configuration information, naming, providing distributed synchronization, and providing group services. All of these kinds of services are used in some form or another by distributed applications. 


**Question 2:** what is kafka? 

Kafka uses Zookeeper to manage the cluster. Zookeeper is used to coordinate the brokers/cluster topology. Zookeeper is a consistent file system for configuration information. Zookeeper gets used for leadership election for broker topic partition leaders. 

Kafka uses Zookeeper to do leadership election of kafka broker and topic partition pairs. Kafka uses zookeeper to manage service discovery for kafka brokers that form the cluster. Zookeeper sends changes of network topology to kafka, so that each node in kafka knows when a new broker joined, when a broker died, when a topic was removed or when a topic was added, etc. Zookeeper provides an in-sync view to Kafka cluster.


**Question 3:** what is kafka brokers?

A Kafka broker is modelled as kafka server that hosts topics. 








**Tutorial:** Setting up multi-broker

https://kafka.apache.org/quickstart



**Question:** 每个channel一个topic，每个topic一个broker，性能会不会比solo更好？





## Reference
[1. Zookeeper and Kafka introduction] http://cloudurable.com/blog/kafka-architecture/index.html
[2. Multi Kafka Brokers Setting Up] https://kafka.apache.org/quickstart
