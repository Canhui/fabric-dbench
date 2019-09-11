## 1. 自然对数e的意义

## 1.1. 什么是自然对数

e = \lim_{\delta t\rightarrow 0} (1+\delta t)^{\frac{1}{\delta t}}


## 1.2. 自然对数的意义

Case 1: 向银行存款100元，采用年复利方式存款，年利率100\%，问下一年利息加本金总共多少钱？
100\times(1+100\%)^{1}

Case 2: 向银行存款100元，采用半年复利方式存款，年利率100\%，问下一年利息加本金总共多少钱？
100\times(1+\frac{100\%}{2})^{2}

Case 3: 向银行存款100元，采用月复利方式存款，年利率100\%，问下一年利息加本金总共多少钱？
100\times(1+\frac{100\%}{12})^{12}

Case 4: 向银行存款100元，采用日复利方式存款，年利率100\%，问下一年利息加本金总共多少钱？
100\times(1+\frac{100\%}{365})^{365}

Case 5: 向银行存款100元，采用小时复利方式存款，年利率100\%，问下一年利息加本金总共多少钱？
100\times(1+\frac{100\%}{365\times24})^{365\times24}

Case 6: 向银行存款100元，采用最小极限时间复利方式存款，年利率100\%，问下一年利息加本金总共多少钱？
\lim_{\delta t\rightarrow 0} 100\times(1+\frac{100\%}{\frac{1}{\delta t}})^{\frac{1}{\delta t}}=100e




## 2. 二项分布

二项分布，即重复n次伯努利试验。事件发生的概率为p，事件不发生的概率为1-p，即n次独立重复伯努利试验中，事件发生k次的概率是
P(X=k)=\left ( \begin{matrix}n\\ k\end{matrix} \right )p^{k}\left ( 1-p \right )^{n-k}
=\frac{n!}{(n-k)!k!}p^{k}\left ( 1-p \right )^{n-k}


一个袋子，40%是黑球，60%是白球。有放回地拿球。现拿三次球，并记录每次球的颜色。问拿一个白球和两个黑球的概率P是多少？

重复n=3次伯努利试验，事件发生的概率p=0.4，事件不发生的概率为1-p=0.6，即事件发生2次的概率是



$$P(X=2)=\left ( \begin{matrix}3\\ 2\end{matrix} \right )0.4^{2}\left \times( 0.6 \right )^{1}$$




## 3. 泊松分布



应用到排队论: 1天内，k=10分钟，来30个transactions的概率，来300个transactions的概率。


下一步：Matlab函数实现，具体应用例子https://wenku.baidu.com/view/4a53348fddccda38366baf5a.html

下下步：泊松分布数据如何生成https://www.zhihu.com/question/38167673

下下下步：jmeter值泊松分布程序如何实现？







## 参考资料
[1. 自然对数] https://zhuanlan.zhihu.com/p/26263743
[2. 公式推导参考] https://blog.csdn.net/a493823882/article/details/78175824
[3. 二项分布公式查看] https://baike.baidu.com/item/%E4%BA%8C%E9%A1%B9%E5%88%86%E5%B8%83/1442377?fr=aladdin
[4. 泊松分布的前提] https://wenku.baidu.com/view/4a53348fddccda38366baf5a.html
