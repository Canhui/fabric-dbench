## 1. 前提

Golang Context Package依赖两个核心概念: goroutine和channel。

#### 1.1. Goroutine

test3.go的线程函数如下，

```go
package main
import "fmt"

func printHello() {
    fmt.Println("hi, this is from printHello()")
}

func main() {
    go func() {
        fmt.Println("hi, this is from main.func()")
    }()
    go printHello()
    fmt.Println("hi, this is from main")
}
```

上述例子通常只输出"hi, this is from main"，不输出"hi, this is from printHello()"或"hi, this is from main.func()"——因为内联函数线程，Goroutine线程和main()主函数线程是平等的。main主函数线程结束时，内联函数线程和Goroutine线程如果尚未结束，输出就只有"hi, this is from main"一句。
```shell
joe@ubuntu01:~/Public/Coding_Storage/Source_Code/gRPC_module$ go run test3.go
hi, this is from main
joe@ubuntu01:~/Public/Coding_Storage/Source_Code/gRPC_module$ go run test3.go
hi, this is from main
joe@ubuntu01:~/Public/Coding_Storage/Source_Code/gRPC_module$ go run test3.go
hi, this is from main
```



一个简单粗暴的解决方法是，main()主线程完成后通过sleep()函数等待其他两个线程，修改后的test3.go的线程函数如下，

```go
package main
import "fmt"
import "time"

func printHello() {
    fmt.Println("hi, this is from printHello()")
}

func main() {
    go func() {
        fmt.Println("hi, this is from main.func()")
    }()
    go printHello()
    fmt.Println("hi, this is from main")
    time.Sleep(1*time.Second)
}
```

运行

```shell
joe@ubuntu01:~/Public/Coding_Storage/Source_Code/gRPC_module$ go run test3.go
hi, this is from main
hi, this is from main.func()
hi, this is from printHello()
joe@ubuntu01:~/Public/Coding_Storage/Source_Code/gRPC_module$ go run test3.go
hi, this is from main
hi, this is from main.func()
hi, this is from printHello()
joe@ubuntu01:~/Public/Coding_Storage/Source_Code/gRPC_module$ go run test3.go
hi, this is from main
hi, this is from printHello()
hi, this is from main.func()
```


通过线程sleep()来同步其余所有线程的方法效率低且不实用，因为无法确定sleep()一秒还是sleep()一分钟。

第二种同步线程的方法是Channel()，这也是Golang的一个核心概念。

<br />

#### 1.2. Channel

Golang进程间通信可以通过Channel实现。

```go
package main
import "fmt"

func printHello(ch chan int) {
    fmt.Println("hi, this is from printHello()")
    ch <- 2 // send a value (2) to the channel
}

func main() {
    ch := make(chan int) // make a channel

    go func() {
        fmt.Println("hi, this is from main.func()")
        ch <- 1 // send a value (1) to the channel
    }()

    go printHello(ch) // send a value (2) to the channel
    
    i := <- ch // read first value (1 or 2) from the channel
    <- ch // read second value (2 or 1) from the channel
    close(ch) // channel队列之前写入两个值，也读取完两个值。所以，队列为空，这里可以关闭。
    fmt.Println("Received", i)   
}
```

运行

```shell
$ go run test3.go
hi, this is from printHello()
Received 2
hi, this is from main.func()
$ go run test3.go
hi, this is from main.func()
hi, this is from printHello()
Received 1
```

<br />
<br />

## 2. Context

Context被设计用于管理(比如中止)Goroutine线程。举个例子，如果某一个线程启动一个Goroutine线程，该Goroutine线程运行太久太慢。此时，如果用户可以通过Context中止该线程。Context提供下列几种类型。

<br />


#### 2.1. context.Background()

该方法返回一个空的context，用于派生其他类型的context。

```go
ctx := context.Background()
```













<br />
<br />

## 参考资料
[1. Golang channel tutorial] https://tour.golang.org/concurrency/2
[2. Golang context package的理解] http://p.agnihotry.com/post/understanding_the_context_package_in_golang/
[3. Golang context examples] https://www.jianshu.com/p/d24bf8b6c869
[4. Golang context more examples] https://medium.com/@cep21/how-to-correctly-use-context-context-in-go-1-7-8f2c0fafdf39

[5. Golang context例子] https://www.sohamkamani.com/blog/golang/2018-06-17-golang-using-context-cancellation/
[6. Golang content例子] https://gist.github.com/astenmies/2f180213d310aa16b4b8c4e637be9441