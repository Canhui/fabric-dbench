## 1. 关于Golang defer

defer是Golang的一个重要的关键字。defer在其所在的函数/方法运行结束时，才开始运行。


#### 1.1. example 1: helloworld

例子一，defer在其所在的main函数执行结束时，才开始执行，如下，

```go
package main
import "fmt"

func main() {
    defer fmt.Println("world")
    fmt.Println("hello")
}
```

运行结果，

```shell
hello
world
```

<br />


例子二，defer在其所在的main函数执行结束时，才开始执行，如下，

```go
package main
import "fmt"

func main() {
    defer fmt.Println("world")
    panic("main stop here...")
    fmt.Println("hello")
}
```

运行结果，

```
world
panic: main stop here...
```


#### 1.2. example 2: defer内部执行次序

通过前面的例子，知道defer在其所在的main函数执行结束时，才开始执行。

下面这个例子，要说明：defer在执行时，采用后来者先执行(last-in-first-out后来居上)的执行方式，如下，

```go
package main
import "fmt"

func main() {
    for i := 1; i <= 3; i++ {
        defer fmt.Println(i)
    }
}
```

运行结果，

```
3
2
1
```


#### 1.3. example 3: defer的常见用于资源释放

下面例子，main执行完毕后，通过defer释放文件句柄，如下，

```go
package main
import (
    "log"
    "os"
)

func main() {
    f, err := os.Open("data.txt")
    if err != nil{
        log.Printf("fail to open the file")
        return
    }
    defer f.Close()

    buffer := make([]byte, 4)
    nbytes, err := f.Read(buffer)
    log.Printf("%d bytes: %s\n", nbytes, string(buffer[:nbytes]))
}

```


运行结果，

```shell
4 bytes: data
```

## 参考资料
[1. defer的用法] https://yourbasic.org/golang/defer/

<br />

#### 备注
[备注一] 初稿，2019年07月18号。



