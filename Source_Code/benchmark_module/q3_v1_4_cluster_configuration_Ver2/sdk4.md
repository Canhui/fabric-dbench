Jmeter: ubuntu01机器上，通过jmeter进行系统压力测试ubuntu00机器上orderer的性能。

## 0. 新建invoke3.sh脚本

ubuntu01机器的/home/joe/fabric-samples/nodeTest目录下，新建invoke3.sh脚本。脚本内容如下，

```shell
node invoke3.js
```

## 1. 实验一

#### 1.1. 初始状态
/opt/app/fabric/peer/data/ledgersData/chains/chains/mychannel中含有的文件：
blockfile_000000

该文件读取之后，含有block0.block到block8.block

#### 1.2. 实验设置
交易大小：1字节
交易数目：多线程，总共生成1个交易


#### 1.3. 实验结果
/opt/app/fabric/peer/data/ledgersData/chains/chains/mychannel中含有的文件：
blockfile_000000

该文件读取之后，含有block0.block到block9.block

#### 1.4. 实验分析
多了block9.block一个区块
多了一笔交易


---------------------------------------------------------------------------

## 2. 实验二

#### 2.1. 初始状态
/opt/app/fabric/peer/data/ledgersData/chains/chains/mychannel中含有的文件：
blockfile_000000

该文件读取之后，含有block0.block到block9.block

#### 2.2. 实验设置
交易大小：1字节
交易数目：多线程，总共生成30个交易

#### 2.3. 理论结果
交易快速稳定生成的前提下，多3个区块，每个区块的时间尽可能地短。

#### 2.4. 实验结果
/opt/app/fabric/peer/data/ledgersData/chains/chains/mychannel中含有的文件：
blockfile_000000

该文件读取之后，含有block0.block到block13.block

#### 2.5. 实验分析
多了block10.block，block11.block, ..., block13.block总共4个区块。

其中，block10.block包含2笔交易；
block11.block包含10笔交易；
block12.block包含10笔交易；
block13.block包含8笔交易；

peer1收到block中交易的时间戳分析；



---------------------------------------------------------------------------

## 3. 实验三： 每一个区块最多容纳10个Txs?

开始: block26.block

参数: 1 threads, 运行3次

结束: block29.block

block27: 1Tx
block28: 1Tx
block29: 1Tx



---------------------------------------------------------------------------

## 4. 实验四： 每一个区块最多容纳10个Txs?

开始: block29.block

参数: 5 threads, 运行5次

结束: block34.block

block30: 5Tx
block31: 5Tx
block32: 5Tx
block33: 5Tx
block34: 5Tx



---------------------------------------------------------------------------

## 5. 实验五： 每一个区块最多容纳10个Txs?

开始: block34.block

参数: 10 threads, 运行5次

结束: block34.block

block35: 10Tx
block36: 10Tx
block37: 10Tx
block38: 10Tx
block39: 10Tx



---------------------------------------------------------------------------

## 6. 实验六： 每一个区块最多容纳10个Txs?

开始: block39.block

参数: 20 threads, 运行5次

结束: block49.block

block40: 10Tx
block41: 10Tx
block42: 10Tx
block43: 10Tx
block44: 10Tx
block45: 10Tx
block46: 10Tx
block47: 10Tx
block48: 10Tx
block49: 10Tx


---------------------------------------------------------------------------

## 7. 实验七： 机器产生多少Transactions per Second最稳定？

开始: block50.block

参数: 30 threads, 运行5次

结束: block64.block

block50: 10Tx
block51: 10Tx
...
block64: 10Tx


---------------------------------------------------------------------------

## 8. 实验八： 机器产生多少Transactions per Second最稳定？

开始: block65.block

参数: 40 threads, 运行5次

结束: block84.block

block65: 10Tx
block66: 10Tx
...
block84: 10Tx



---------------------------------------------------------------------------

## 9. 实验九： 机器产生多少Transactions per Second最稳定？

开始: block85.block

参数: 50 threads, 运行5次

结束: block109.block

block85: 10Tx
block86: 10Tx
...
block109: 10Tx



在我们的设备上，每台机器秒<= 50 Transactions per Second是相当稳定的！

每一个Block最多可以存放10笔交易。






