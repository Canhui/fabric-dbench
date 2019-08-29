将log写入"data.log"文件如下，

```shell
2019-08-29 16:23:22.289 HKT [gossip.privdata] StoreBlock -> INFO b22 [mychannel] Received block [1062] from buffer
2019-08-29 16:23:22.293 HKT [committer.txvalidator] Validate -> INFO b23 [mychannel] Validated block [1062] in 4ms
2019-08-29 16:23:22.562 HKT [kvledger] CommitWithPvtData -> INFO b24 [mychannel] Committed block [1062] with 10 transaction(s) in 268ms (state_validation=0ms block_commit=185ms state_commit=33ms)
2019-08-29 16:23:22.867 HKT [gossip.privdata] StoreBlock -> INFO b25 [mychannel] Received block [1063] from buffer
2019-08-29 16:23:22.875 HKT [committer.txvalidator] Validate -> INFO b26 [mychannel] Validated block [1063] in 7ms
2019-08-29 16:23:23.129 HKT [kvledger] CommitWithPvtData -> INFO b27 [mychannel] Committed block [1063] with 10 transaction(s) in 253ms (state_validation=1ms block_commit=169ms state_commit=33ms)
2019-08-29 16:23:25.134 HKT [gossip.privdata] StoreBlock -> INFO b28 [mychannel] Received block [1064] from buffer
2019-08-29 16:23:25.137 HKT [committer.txvalidator] Validate -> INFO b29 [mychannel] Validated block [1064] in 3ms
2019-08-29 16:23:25.398 HKT [kvledger] CommitWithPvtData -> INFO b2a [mychannel] Committed block [1064] with 9 transaction(s) in 260ms (state_validation=0ms block_commit=167ms state_commit=41ms)
```

readdata.py读取"data.log"文件，readdata.py代码如下，
```python
fp =open("data.log")

# global data set
timestamp = []
blknum = []
txnum = []

# processing log
i = 0;
for line in fp.readlines():
    i = i + 1;
    if(i == 1):
        data = line.split(" ")
        #print(data[1])
        timestamp.append(data[1]) # log timestamp
        #print(data[11].strip('[').strip(']'))
        blknum.append(data[11].strip('[').strip(']')) # log blocknum

    elif(i == 3):
        data = line.split(" ")
        #print(data[13]) 
        txnum.append(data[13]) # txnum
        i = 0 # marker
fp.close()

# process results (rounds)
for i in range(len(timestamp)):
    print(timestamp[i])

print("")
for i in range(len(timestamp)):
    print(blknum[i])

print("")
for i in range(len(timestamp)):
    print(txnum[i])
```

