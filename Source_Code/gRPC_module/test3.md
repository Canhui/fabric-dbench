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




<br />
<br />

## 参考资料
[1. Golang context package的理解] http://p.agnihotry.com/post/understanding_the_context_package_in_golang/