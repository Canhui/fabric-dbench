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




## 参考资料
[1. main单信道channel挂起报错] https://studygolang.com/articles/9479
