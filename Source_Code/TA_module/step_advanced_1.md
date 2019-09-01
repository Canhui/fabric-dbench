## 1. HashCode
HashCode是int类型，返回一个字符串的数值类型的哈希值。通常来讲，如果两个字符串相同，则其HashCode也相同；如果两个字符串不同，则其HashCode也不同。下面，我们通过一个例子实现散列存储，


#### 1.1. 计算数值型散列值
给定两个字符串"word" 和 "hello"，分别计算其数值型散列值分别为"3655434"和"99162322"，如下，

```java
public static void main(String[] args) {
        
        String msg1 = "word";
        String msg2 = "hello";
        
        System.out.println("hashCode of msg1 is " + msg1.hashCode());
        System.out.println("hashCode of msg2 is " + msg2.hashCode());
}
```

显示结果如下，
```shell
hashCode of msg1 is 3655434
hashCode of msg2 is 99162322
```

#### 1.2. 计算字符串的存储位置
我们已经计算出两个字符串的散列值。下面，我们通过字符串的散列值计算出字符串的存储位置，如下，
```java
public static void main(String[] args) {
        
        int STORAGEFILES = 10;
        String msg1 = "word";
        String msg2 = "hello";
        
        System.out.println("hashCode of msg1 is " + msg1.hashCode());
        System.out.println("hashCode of msg2 is " + msg2.hashCode());
        System.out.println("location of msg1 is " + Math.abs(msg1.hashCode())%STORAGEFILES);
        System.out.println("location of msg2 is " + Math.abs(msg2.hashCode())%STORAGEFILES);
}
```

显示结果如下，
```shell
hashCode of msg1 is 3655434
hashCode of msg2 is 99162322
location of msg1 is 4
location of msg2 is 2
```




