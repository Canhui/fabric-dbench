## 1. Java实现CallBack功能

回调函数也叫回调模式，是一种软件设计模式。具体来讲，给定回调函数CallBack()，和被观察者函数A(x,x)。编程实现上，回调函数作为被观察者函数的输入A(x,x,CallBack)，以便在观察/记录函数A的log日志。

<br />
<br />

## 2. 举例A
给定一个服务器，该服务器主要任务是计算一个困难值。客户端发送计算请求给服务器。在现实环境中，服务端一旦成功收到客户请求，应该立即回复“服务端收到请求”；服务端一旦成功计算完毕，应该立即回复“服务端计算完毕”——这里我们可以通过Callback回调函数实现。

#### 2.1. 定义回调函数
回调函数的功能有两个：“服务端收到请求”和“服务端计算完毕”。代码如下，
```java
// Callback functions
interface ComputeCallBack{
    public void onRequestReceived();
    public void onRequestFinished();
}
```

#### 2.2. 服务端使用回调函数提供服务
服务端收到请求时，调用ComputeCallBack.onRequestReceived()函数；服务端计算完毕时，调用ComputeCallBack.onRequestFinished()。代码如下，
```java
// Server uses callback functions to log beginning and end points/timestamps
class TestCallBack {     
    public void compute(int n, ComputeCallBack cb) {
        cb.onRequestReceived();
        for (int i = 0; i < n; i++) {
            System.out.println(i);
        }
        cb.onRequestFinished();
    }
}
```

#### 2.3. 测试
服务端的ComputeCallBack.onRequestReceived()和ComputeCallBack.onRequestFinished()函数均为接口函数。客户端在请求服务端服务之前，需要自己定义服务端使用的所有接口。代码如下，

```java
// Main Test
public class CallBack {
    public static void main(String[] args) {
        
        // User 1 request the computing service
        new TestCallBack().compute(10, new ComputeCallBack() {  
            public void onRequestReceived() {
                System.out.println("Server received the request from User 1, and start computing.");
            }
            
            @Override
            public void onRequestFinished() {
                System.out.println("Server finished the request from User 1, and return results.");  
            }
        });
   
    }
}
```


测试结果如下，
```shell
Server received the request from User 1, and start computing.
0
1
2
3
4
5
6
7
8
9
Server finished the request from User 1, and return results.
```

<br />
<br />

## 完整代码如下

```java
// Callback functions
interface ComputeCallBack{
    public void onRequestReceived();
    public void onRequestFinished();
}

// Server uses callback functions to log beginning and end points/timestamps
class TestCallBack {     
    public void compute(int n, ComputeCallBack cb) {
        cb.onRequestReceived();
        for (int i = 0; i < n; i++) {
            System.out.println(i);
        }
        cb.onRequestFinished();
    }
}

// Main Test
public class CallBack {
    public static void main(String[] args) {
        
        // User 1 request the computing service
        new TestCallBack().compute(10, new ComputeCallBack() {  
            public void onRequestReceived() {
                System.out.println("Server received the request from User 1, and start computing.");
            }
            
            @Override
            public void onRequestFinished() {
                System.out.println("Server finished the request from User 1, and return results.");  
            }
        });
   
    }
}
```

另外，不同客户端可以实现自己的CallBack函数接口，这里不再累赘。