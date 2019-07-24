channel主要作用于go线程间通信。channel默认采用阻塞模式，通过信号来实现线程之间的相互等待/通信。线程之间以channel为中介，向channel取值，从channel读值。特别注意单信道被channel读写时均会挂起该线程，可能报错。

## 1. eg1

channel `c` 通道只允许int类型的数据的传输。

```go
package main
import "fmt"

func main() {
    c := make(chan int)
   
    fmt.Printf("Type of c is %T\n", c)
    fmt.Printf("Value of c is %v\n", c)
}
```


## 2. eg2

```go
package main
import "fmt"

func greet(c chan string) {
    fmt.Println("Data from channel c:" + <-c)
}

func main() {
    c := make(chan string)
    fmt.Println("Main thread works")
    go greet(c)
    c <- " this is c"
    fmt.Println("Main thread stopped")
}
```

Golang的channel默认是阻塞模式。这意味着，其一，main线程会等待goroutine线程完成；其二，goroutine线程(这里是greet函数)被阻塞，直到其接收到channel c的输入。


## 3. eg3

注意，channel关闭之后，不允许再进行读写操作。

```go
package main
import "fmt"

func greet(c chan string) {
    fmt.Println("Data from channel c:" + <-c)
}

func main() {
    c := make(chan string)
    fmt.Println("Main thread works")
    go greet(c)
    c <- " this is c"
    close(c)
    c <- " this is another c"
    fmt.Println("Main thread stopped")
}
```


## 4. eg4
channel主要作用于go线程间通信。main线程和子线程通过channel通信。

```go
package main
import "fmt"

func squares(c chan int){
    for i := 0; i <= 9; i++ {
        c <- i
    }
    close(c)
}

func main() {
    c := make(chan int)
    fmt.Println("Main thread works")
    go squares(c)

    for {
        val, ok := <- c
        if ok == false {
            fmt.Println(val, ok, "break loop here!")
            break
        } else {
            fmt.Println(val, ok)
        }
    }
    fmt.Println("Main thread stopped")
}
```

另外一种版本的实现方法如下，

```go
package main
import "fmt"

func squares(c chan int){
    for i := 0; i <= 9; i++ {
        c <- i
    }
    close(c)
}

func main() {
    c := make(chan int)
    fmt.Println("Main thread works")
    go squares(c)

    for val := range c {
        fmt.Println(val)
    }
    fmt.Println("Main thread stopped")
}
```

## 5. eg5

channel的声明`c := make(chan Type, n)`，当channel c写入c个值的时候，该channel c才处于阻塞状态；否则，该channel c并不会处于阻塞状态。

该channel c不full，channel c并不会处于阻塞状态，如下，

```go
package main
import "fmt"

func squares(c chan int){
    num1 := <- c
    num2 := <- c
    num3 := <- c
    fmt.Println(num1)
    fmt.Println(num2)
    fmt.Println(num3)
    close(c)
}

func main() {
    c := make(chan int, 3)
    fmt.Println("Main thread works")
    go squares(c)

    c <- 1
    c <- 2
    fmt.Println("Main thread stopped")
}
```

当channel c写入c个值的时候，channel c full，该channel c才处于阻塞状态，如下，

```go
package main
import "fmt"

func squares(c chan int){
    num1 := <- c
    num2 := <- c
    num3 := <- c
    fmt.Println(num1)
    fmt.Println(num2)
    fmt.Println(num3)
    close(c)
}

func main() {
    c := make(chan int, 3)
    fmt.Println("Main thread works")
    go squares(c)

    c <- 1
    c <- 2
    c <- 3
    fmt.Println("Main thread stopped")
}
```


## 6. eg6

channel的只读模式，只写模式，代码如下，

```go
package main
import "fmt"

func greet(roc <- chan string) {
    fmt.Println("Hello " + <- roc) // step2: 阻塞goroutine线程(channel的读/写都是阻塞的)，返回main线程
}

func main() {
    c := make(chan string)
    fmt.Println("Main thread started")
    go greet(c)

    c <- "J" // step1: 阻塞main线程(channel的读/写都是阻塞的)，进入goroutine线程
    fmt.Println("Main thread ended")
}
```




## 7. eg7

匿名goroutine线程模式

```go
package main
import "fmt"

func main() {
    c := make(chan string)
    fmt.Println("Main thread started")

    go func(c chan string) {
        fmt.Println("Hello " + <- c)
    }(c)

    c <- "J"
    fmt.Println("Main thread ended")
}
```


## 8. eg8

channel结合select-case语句，如下，只要一个case成立，main线程就会继续。

```go
package main
import (
    "fmt"
    "time"
)

func service1(c chan string) {
    time.Sleep(4 * time.Second)
    c <- "hello from service 1"
}

func service2(c chan string) {
    time.Sleep(3 * time.Second)
    c <- "hello from service 2"
}

func main() {
    start := time.Now()
    fmt.Println("Main thread started", time.Since(start))

    chan1 := make(chan string)
    chan2 := make(chan string)

    go service1(chan1)
    go service2(chan2)

    select {
    case res := <- chan1:
        fmt.Println("Response from service1", res)
    case res := <- chan2:
        fmt.Println("Response from service2", res)
    }
}
```

注意，default会使得channel语境下的select-case语句由block变为un-blocking。


如果请求5秒后无法返回，我们通过default语句，返回一个初步结果，

```go
package main
import (
    "fmt"
    "time"
)

func service1(c chan string) {
    c <- "hello from service 1"
}

func service2(c chan string) {
    c <- "hello from service 2"
}

func main() {
    start := time.Now()
    fmt.Println("Main thread started", time.Since(start))

    chan1 := make(chan string)
    chan2 := make(chan string)

    go service1(chan1)
    go service2(chan2)

    time.Sleep(3 * time.Second)

    select {
    case res := <- chan1:
        fmt.Println("Response from service1", res)
    case res := <- chan2:
        fmt.Println("Response from service2", res)
    default:
        fmt.Println("Default makes things un-blocking")
    }
}
```


设置Timeout()，如下，

```go
package main
import (
    "fmt"
    "time"
)

func service(c chan string) {
    c <- "hello from service 1"
}

func main() {
    start := time.Now()
    fmt.Println("Main thread started", time.Since(start))

    chan1 := make(chan string)
    chan2 := make(chan string)

    select {
    case res := <- chan1:
        fmt.Println("Response from service1", res)
    case res := <- chan2:
        fmt.Println("Response from service2", res)
    case <-time.After(3*time.Second):
        fmt.Println("Default makes things un-blocking")
    }
}
```



## 9. eg9 等待所有线程结束

等待所有的groutine线程结束，

```go
package main
import (
    "fmt"
    "sync"
    "time"
)

func service(wg *sync.WaitGroup, instance int) {
    time.Sleep(2 * time.Second)
    fmt.Println("Service called on instance", instance)
    wg.Done()
}

func main() {
    fmt.Println("Main thread started")
    var wg sync.WaitGroup

    for i := 1; i <=3; i++ {
        wg.Add(1)
        go service(&wg, i)
    }

    wg.Wait()
    fmt.Println("Main thread ended")
}
```



## 10. eg10 等待所有channel的线程结束

通过channel等待所有的goroutine线程结束

```go
package main
import (
    "fmt"
    "time"
)

func sqrWorker(tasks <- chan int, results chan <- int, instance int) {
    for num := range tasks {
        time.Sleep(time.Millisecond)
        fmt.Printf("worker %v sending result by worker %v \n", instance, instance)
        results <- num
    }
}


func main() {
    fmt.Println("Main thread started")
    tasks := make(chan int, 10)
    results := make(chan int, 10)

    for i:=0; i < 5; i++ {
        go sqrWorker(tasks, results, i)
    }

    // pass three tasks from main thread to child thread
    for i := 0; i < 5; i++ {
        tasks <- i
    }
    
    // child thread ended, return to main thread
    close(tasks)
    for i := 0; i < 5; i++ {
        res := <- results
        fmt.Println("child thread", i,"; Result:",res)
    }

    // main thread ended
    fmt.Println("Main thread ended")
}
```


通过wg等待所有的goroutine线程结束

```go
package main
import (
    "fmt"
    "sync"
)

func sqrWorker(wg *sync.WaitGroup, tasks <- chan int, results chan <- int) {
    for num := range tasks {
        fmt.Printf("worker receives task %v \n", num)
        results <- num
    }
    // 同步goroutine都写完再返回main
    wg.Done()
}


func main() {
    var wg sync.WaitGroup
    fmt.Println("Main thread started")
    tasks := make(chan int, 5)
    results := make(chan int, 5)

    for i:=0; i < 5; i++ {
        wg.Add(1)
        go sqrWorker(&wg, tasks, results)
    }

    // pass three tasks from main thread to child thread
    for i := 0; i < 5; i++ {
        tasks <- i*2
    }
    close(tasks)

    // 同步task写完再启动多线程
    wg.Wait()
    for i := 0; i < 5; i++ {
        res := <- results
        fmt.Println("child thread", i,"; Result:",res)
    }

    // main thread ended
    fmt.Println("Main thread ended")
}
```



## 11. eg11 线程原子操作

确实所有线程都完成了，但是部分线程存在race condition竞争，导致结果错误

```go
package main
import (
    "fmt"
    "sync"
)

var i int

func worker(wg *sync.WaitGroup) {
    i = i + 1
    wg.Done()
}

func main() {
    var wg sync.WaitGroup

    for i := 0; i < 1000; i++ {
        wg.Add(1)
        go worker(&wg)
    }
    wg.Wait()

    fmt.Println("Sum of i after 1000 operations is: ",i)
}
```


所有线程都完成了，且每一个线程都是原子操作，结果正确

```go
package main
import (
    "fmt"
    "sync"
)

var i int

func worker(wg *sync.WaitGroup, m *sync.Mutex) {
    m.Lock()
    i = i + 1
    m.Unlock()
    wg.Done()
}

func main() {
    var wg sync.WaitGroup
    var m sync.Mutex

    for i := 0; i < 1000; i++ {
        wg.Add(1)
        go worker(&wg, &m)
    }
    wg.Wait()

    fmt.Println("Sum of i after 1000 operations is: ",i)


```










## 参考资料
[1. main单信道channel挂起报错] https://studygolang.com/articles/9479
[2. channel完美教程博客] https://medium.com/rungo/anatomy-of-channels-in-go-concurrency-in-go-1ec336086adb

