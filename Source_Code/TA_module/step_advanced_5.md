## 1. 表达式预处理

基本思路： 任意两个非operators的名词之间必须包含一个operator，否则，该operator默认为"AND"逻辑运算。

Java基本算法如下：






<br />

## 2. 逆波兰表达式

目标：将公式输入转换成逆波兰表达式。

基本算法：https://www.cnblogs.com/dojo-lzz/p/9000223.html

具体实现：http://lckiss.com/?p=2154

本地实现：Test/Test1.java

```java
import java.util.ArrayList;
import java.util.Stack;


```




<br />

## 3. 逻辑处理

目标：处理逆波兰表达式。

基本算法：

Step 1: 输入字符串类型表达式 "90+(3-1)*3+10/2"

Step 2: 通过toOpArray()函数，将字符串类型表达式转换成逆波兰表达









<br />

## 参考资料
[1. 逆波兰处理算法] https://www.cnblogs.com/dojo-lzz/p/9000223.html

