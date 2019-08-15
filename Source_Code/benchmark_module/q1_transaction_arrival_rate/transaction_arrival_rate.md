





## 1. Transaction Arrival Rate





#### Orderer Setting

Settings are given as follows,

```yaml
BatchTimeout: 2s               # the amount of time to wait before creating a batch.
BatchSize:
    MaxMessageCount: 10        # the max number of messages to permit in a batch. 
    AbsoluteMaxBytes: 99MB     # the absolute maximum number of bytes allowed for the serialized messages in a batch.
    PreferredMaxBytes: 512 KB  # a message larger than the preferred max bytes will result in a batch larger than preferred max bytes
```

Transactions are collected into blocks/batches on the ordering service first. Blocks are cut either when the `BatchSize` is met (), or when `BatchTimeout` elapses. `Orderer.BatchTimeout` for instance may be specified differently on one channel than another.

It means that the ordering service will not cut a block until either of these two conditions (BatchTimeout and BatchSize) are met. You are sending less than `MaxMessageCount` transactions, so the ordering service needs to wait `BatchTimeout` seconds before it cuts the block. So in order to decrease the time it takes for the transaction to show up in your ledger, set `BatchTimeout` to a small value and `MaxMessageCount` to 1 -- But this will result block overhead for transactions (say one transaction per block).

[Ref1](https://stackoverflow.com/questions/50226153/orderer-and-committer-taking-time-to-put-data-into-ledger)
[Ref2](https://stackoverflow.com/questions/42756681/how-exactly-blocks-are-created-in-hyperledger-fabric)







#### Transaction Size




Case 1: Transaction Arrival Rate: <= 5 TPS, and transaction size is <= `PreferredMaxBytes` => bottleneck is to wait `BatchTimeout` 

Key: 1 byte
Value: 1 byte


Latex result table (TAR from 1 tps to 5 tps)如下，

```latex
\begin{table}[]
\begin{tabular}{|l|l|l|l|l|l|l|l|}
\hline
\begin{tabular}[c]{@{}l@{}}Tx Arrival Rate\\ (Txs per second)\end{tabular} & Test Rounds & \begin{tabular}[c]{@{}l@{}}Accepted Txs\\ (per Round)\end{tabular} & \begin{tabular}[c]{@{}l@{}}Rejected Txs\\ (per Round)\end{tabular} & \begin{tabular}[c]{@{}l@{}}Throughput\\ (Txs per second per Round)\end{tabular} & \begin{tabular}[c]{@{}l@{}}Avg Tx Delay\\ (second)\end{tabular} & \begin{tabular}[c]{@{}l@{}}Min Tx Delay\\ (second)\end{tabular} & \begin{tabular}[c]{@{}l@{}}Max Tx Delay\\ (second)\end{tabular} \\ \hline
1                                                                          & 10          & 1                                                                  & 0                                                                  & 1                                                                     & 2.353                                                           & 2.319                                                           & 2.386                                                           \\ \hline
2                                                                          & 10          & 2                                                                  & 0                                                                  & 2                                                                     & 2.338                                                           & 1.875                                                           & 2.391                                                           \\ \hline
3                                                                          & 10          & 3                                                                  & 0                                                                  & 3                                                                     & 2.251                                                           & 1.697                                                           & 2.381                                                           \\ \hline
4                                                                          & 10          & 4                                                                  & 0                                                                  & 4                                                                     & 2.280                                                           & 1.519                                                           & 2.393                                                           \\ \hline
5                                                                          & 10          & 5                                                                  & 0                                                                  & 5                                                                     & 2.239                                                           & 1.535                                                           & 2.407                                                           \\ \hline
\end{tabular}
\end{table}
```

readxml.py代码如下，
```py
import xml.etree.ElementTree as ET


tree = ET.parse('./res.xml')
root = tree.getroot()
num = []
fail = 0
success = 0
#print('root-tag:',root.tag,',root-attrib:',root.attrib,',root-text:',root.text)
for child in root:
     #print('child-tag is:',child.tag,',child.attrib:',child.attrib,',child.text:',child.text)
    for sub in child:
        try:
            #print (1)
            success = success + 1
            num.append(float(sub.text.strip('\n')))
        except:
            fail = fail + 1

print "tx fail:", fail
print "tx success:", len(num)
print "avg tx delay:", sum(num)/len(num)
print "min tx delay:", min(num)
print "max tx delay:", max(num)
```









Case 2: Transaction Arrival Rate: <= 5 TPS, and transaction size is > `PreferredMaxBytes` => TO EXPLORE









Case 3: Transaction Arrival Rate: > 5 TPS, and transaction size is <= `PreferredMaxBytes` => To benchmark throughput (most of papers)

Key: 1 byte
Value: 1 byte

Latex result table (TAR from 10 tps to 50 tps)如下，

```latex
\begin{table}[]
\begin{tabular}{|l|l|l|l|l|l|l|l|}
\hline
\begin{tabular}[c]{@{}l@{}}Tx Arrival Rate\\ (Txs per second)\end{tabular} & Test Rounds & \begin{tabular}[c]{@{}l@{}}Accepted Txs\\ (per Round)\end{tabular} & \begin{tabular}[c]{@{}l@{}}Rejected Txs\\ (per Round)\end{tabular} & \begin{tabular}[c]{@{}l@{}}Throughput\\ (Txs per second per Round)\end{tabular} & \begin{tabular}[c]{@{}l@{}}Avg Tx Delay\\ (second)\end{tabular} & \begin{tabular}[c]{@{}l@{}}Min Tx Delay\\ (second)\end{tabular} & \begin{tabular}[c]{@{}l@{}}Max Tx Delay\\ (second)\end{tabular} \\ \hline
10                                                                         & 10          & 10                                                                 & 0                                                                  & 10                                                                              & 0.543                                                           & 0.342                                                           & 2.018                                                           \\ \hline
20                                                                         & 10          & 20                                                                 & 0                                                                  & 20                                                                              & 0.753                                                           & 0.378                                                           & 2.641                                                           \\ \hline
30                                                                         & 10          & 30                                                                 & 0                                                                  & 30                                                                              & 0.890                                                           & 0.477                                                           & 2.843                                                           \\ \hline
40                                                                         & 10          & 40                                                                 & 0                                                                  & 40                                                                              & 0.930                                                           & 0.422                                                           & 2.742                                                           \\ \hline
50                                                                         & 10          & 50                                                                 & 0                                                                  & 50                                                                              & 1.083                                                           & 0.608                                                           & 2.872                                                           \\ \hline
\end{tabular}
\end{table}
```




Latex result table (TAR from 100 tps to 300 tps)如下，

```latex
\begin{table}[]
\begin{tabular}{|l|l|l|l|l|l|l|l|}
\hline
\begin{tabular}[c]{@{}l@{}}Tx Arrival Rate in Configuration\\ (Txs per second)\end{tabular} & Test Rounds & \begin{tabular}[c]{@{}l@{}}Total Txs Generated\\ (10 Rounds)\end{tabular} & \begin{tabular}[c]{@{}l@{}}Total Accepted Txs\\ (10 Rounds)\end{tabular} & \begin{tabular}[c]{@{}l@{}}Rejected Txs\\ (per Rounds)\end{tabular} & \begin{tabular}[c]{@{}l@{}}Avg Tx Delay\\ (second)\end{tabular} & \begin{tabular}[c]{@{}l@{}}Min Tx Delay\\ (second)\end{tabular} & \begin{tabular}[c]{@{}l@{}}Max Tx Delay\\ (second)\end{tabular} \\ \hline
100                                                                                         & 10          & 1000                                                                      & 980                                                                      & 20                                                                  & 1.588                                                           & 0.390                                                           & 2.986                                                           \\ \hline
150                                                                                         & 10          & 1500                                                                      & 1254                                                                     & 246                                                                 & 2.080                                                           & 0.666                                                           & 3.108                                                           \\ \hline
200                                                                                         & 10          & 2000                                                                      & 1317                                                                     & 683                                                                 & 2.320                                                           & 0.881                                                           & 3.223                                                           \\ \hline
250                                                                                         & 10          & 2500                                                                      & 989                                                                      & 1511                                                                & 2.513                                                           & 0.527                                                           & 3.421                                                           \\ \hline
300                                                                                         & 10          & 3000                                                                      & 532                                                                      & 2468                                                                & 2.417                                                           & 0.558                                                           & 3.673                                                           \\ \hline
\end{tabular}
\end{table}
```








Case 4: Transaction Arrival Rate: >5 TPS, and transaction size is > `PreferredMaxBytes` => To benchmark throughput











#### Transaction Delay







关于constant throughput timer的介绍: https://www.blazemeter.com/blog/how-use-jmeters-throughput-constant-timer/

