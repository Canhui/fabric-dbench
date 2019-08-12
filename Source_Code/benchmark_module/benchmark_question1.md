## 1. Research Question (about transaction arrival rate)

Does a higher transaction arrival rate means a larger throughput? Is there a necessary relationship between then? why and why not? 

#### 1.1. Method

Peer configuration

Transaction Arrival Rate: 0 TPS --> see Throughput results
Transaction Arrival Rate: 10 TPS --> see Throughput results
Transaction Arrival Rate: 20 TPS --> see throughput results
...
Transaction Arrival Rate: 50 TPS --> see throughput results 
Transaction Arrival Rate: 60 TPS --> see throughput results
Transaction Arrival Rate: 70 TPS --> see throughput results
Transaction Arrival Rate: 80 TPS --> see throughput results
Transaction Arrival Rate: 90 TPS --> see throughput results
Transaction Arrival Rate: 100 TPS --> see throughput results


#### 1.2. Reasons/Analysis

TO DO 1: See transaction timeout. Timeout set for validating transaction of hyperledger.
TO DO 2: See transaction dealy.
TO DO 3: see transaction size (transaction size越大，峰值越向左移).
TO DO 4: see queue length.
TO DO 5: see failed transactions.
TO DO 6: see what is the content of a transaction?
TO DO 7: see number of transactions in a block?
TO DO 8: multi-channels to throughput?

A large number of transactions results in a longer delay?
How to see transaction size? Transaction proposal size? 
How to see the length of a queue?
Why a higher transaction arrival rate results in a lower throughput?


#### 1.3. Experiments
-------------------基础网络环境配置如下--------------------------------------
实验环境配置如下，其中orderer采用solo模式，
Orderer: 192.168.0.109
peer0.org1: 192.168.0.109
peer1.org1: 192.168.0.111
peer0.org2: 192.168.0.112

-------------------用户身份配置如下--------------------------------------
peer0.org1的管理员身份:
192.168.0.109上
`fabric-samples/Admin@org1.example.com`
`./peer.sh node status`

peer0.org1的管理员身份:
192.168.0.111上
`fabric-samples/Admin@org1.example.com`
`sudo ./peer.sh node status`

peer0.org2的管理员身份: 
192.168.0.112上面
`fabric-samples/Admin@org2.example.com`
`sudo ./peer.sh node status`


-------------------channel配置如下--------------------------------------


创建channel，然后peer分别加入channel。

注: 多个channels在这里改进/部署。


-------------------chaincode配置如下--------------------------------------

每一个peer都安装一份相应的chaincode。

sudo ./peer.sh chaincode invoke -o orderer.example.com:7050  --tls true --cafile ./tlsca.example.com-cert.pem -C mychannel -n demo -c '{"Args":["write","key1","keydfsqqfghqqghqqfghqqdfsqqqyrtyfqgfhqqqdfgqwwerqqdfghsqqqdfsqfdfghqqwerqqfghqwerqqwrwerqfghqdfsqqthqqgfhwerqqwerwerwdfgreeqqyrtyfqgfhqqqdfgqwwerqqdfghsqqqyrtyfqgfhqqqdfgqwwerqqdfghsqqqyrtyfqgfhqqqdfgqwwerqqdfghsqqqyrtyfqgfhqqqdfgqwwerqqdfghsqqqyrtyfqgfhqqqdfgqwwerqqdfghsqqqyrtyfqgfhqqqdfgqwwerqqdfghsqqqyrtyfqgfhqqqdfgqwwerqqdfghsqqqyrtyfqgfhqqqdfgqwwerqqdfghsqqqyrtyfqgfhqqqdfgqwwerqqdfghsqqqyrtyfqgfhqqqdfgqwwerqqdfghsqqqyrtyfqgfhqqqdfgqwwerqqdfghsqqqyrtyfqgfhqqqdfgqwwerqqdfghsqqqyrtyfqgfhqqqdftyfqgfhqqqdfgqwwerqqwrwerqfghqdfsqqthqqgfhwerqqwerwerwdfgreeqqyrtyfqgfhqqqdfgqwwerqqdfghsqqqyrtyfqgfhqqqdfgqwwerqqdfghsqqqyrtyfqgfhqqqdfgqwwerqqdfghsqqqyrtyfqgfhqqqdfgqwwerqqdfghsqqqyrtyfqgfhqqqdfgqwwqdfgqwwerqqdfghsqqqyrtyfqgfhqqqdfgqwwerqqdfghsqqqyrtyfqgfhqqqdfgqwwerqqdfghsqqqyrtyfqgfhqqqdfgqwwerqqdfghsqqqyrtyfqgfhqqqdfgqwwerqqdfghsqqqyrtyfqgfhqqqdfgqwwerqqdfghsqqqyrtyfqgfhqqqdfgqwwerqqdfghsqqqyrtyfqgfhqqqdfgqwwerqqdfghsqqqyrtyfqgfhqqqdfgqwwerqqdfghsqqqyrtyfqgfhqqqdqgfhqqqdfgqwwerqqdfghsqqqyrtyfqgfhqqqdfgqwwerqqdfghsqqqyrtyfqgfhqqqdfgqwwerqqdfghsqqqyrtyfqgfhqqqdfgqwwerqqdfghsqqqyrtyfqgfhqqqdfgqwwerqqdfghsqqqyrtyfqgfhqqqdfgqwwerqqdfghsqqqyrtyfqgfhqqqdfgqwwerqqdfghsdfghsqqqyrtyfqgfhqqqdfgqwwerqqdfghsqqqyrtyfqgfhqqqdfgqwwerqqdfghsqqqyrtyfqgfhqqqdfgqwwerqqdfghsqqqyrtyfqgfhqqqdfgqwwerqqdfghsqqqyrtyfqgfhqqqdfgqwwerqqdfghsqqqyrtyfqgfhqqqdfgqwwerqqdfghsqqqyrtyfqgfhqqqdfgqwwerqqdfghsqqqyrtyfqgfhqqqdfgqwwfghjkl;fghjkl;dfghjcvbnm,sdfghjkl;fghjkl;dfghjcvbnm,sdfghjkl;fghjkl;dfghjcvbnm,sdfghjkl;fghjkl;dfghjfwersdfrtyqst"]}'

sudo ./peer.sh chaincode query -C mychannel -n demo -c '{"Args":["query","key1"]}'




-----------------测试方案:制造不同的workload，查看Throughput如下------------------

orderer所在机器: 192.168.0.109
peer0.org1的管理员所在机器: 192.168.0.111

目标: 通过peer0.org1的管理员制造不同的workload，orderer处理workload，查看整个hyperledger系统的Throughput性能。

工具: 采用Jmeter










## Reference
[1. benchamrk paper] Benchmarking a blockchain-based certification storage system.
