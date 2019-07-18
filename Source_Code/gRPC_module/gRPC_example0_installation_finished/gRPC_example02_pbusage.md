## 1. Golang "import" Usage

#### 1.1. example: helloworld

新建工作路径

```shell
$ cd $GOPATH/src
$ mkdir example1
$ cd example1
$ touch main.go
$ mkdir lib
$ cd lib
$ touch lib.go
```

lib.go内容如下，

```go
package lib
import (
    "fmt"
)

func Test() {
    fmt.Println("helloworld from lib.Test()")
}
```

main.go调用lib.go，如下，
```go
package main
import {
    "example1/lib"
}

func main() {
    lib.Test()
}
```

测试如下，

```shell
~/go/src/example1$ go run main.go
helloworld from lib.Test()
```



#### 1.2. example: interface 

新建工作路径

```shell
$ cd $GOPATH/src
$ mkdir example2
$ cd example2
$ touch main.go
$ mkdir lib
$ cd lib
$ touch lib.go
```

lib.go内容如下，

```go
package lib

type Geometry interface{ // The Geometry interface
    Area() float64
    Perim() float64
}
```

main.go调用lib.go，实现接口的所有方法，如下，

```go
package main
import (
    "fmt"
    "example2/lib"
)

type Rectangle struct{ // Optional: Define Rectangle's own Data Structure
    width, height float64
}

func (r Rectangle) Area() float64 { // Must: Implement the first function of the interface
    return r.width * r.height
}

func (r Rectangle) Perim() float64 { // Must: Implement the second function of the interface
    return 2*r.width + 2*r.height
}

func main() {
    r := Rectangle{width:3, height:4}
    fmt.Println(lib.Geometry.Area(r)) // Optional: use the first function of the interface
    //fmt.Println(lib.Geometry.Perim(r)) // Optional: use the second function of the interface
}
```

测试如下，

```shell
~/go/src/example2$ go run main.go
12
```

<br />
<br />

## 备注
[备注一] 初稿, 2019年07月18号。