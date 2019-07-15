接口是对行为或函数集合的抽象，其定义了抽象的行为或函数。用户通过实现接口的抽象行为或函数来使用接口。接口是Golang的一个重要的概念。

<br />

## 1. 声明Interface

定义一个几何Geometry接口，包含面积Area()和周长Perim()两个函数。

```go
type Geometry interface {
    Area() float64
    Perim() float64
}
```

<br />
<br />

## 2. 实现Interface

#### 2.1. Case 1 -- Rectangle (传值实现)

Rectange通过实现Geometry接口的所有抽象函数，来实现该接口。

```go
package main
import "fmt"

type Geometry interface{ // The Geometry interface
    Area() float64
    Perim() float64
}

type Rectangle struct{ // Define Rectagle's own Data Structure
    width, height float64
}

func (r Rectangle) Area() float64 { // Implement the Area()
    return r.width * r.height
}

func (r Rectangle) Perim() float64 { // Implement the Perim()
    return 2*r.width + 2*r.height
}

func main(){
    r := Rectangle{width:3, height:4}
    fmt.Println(Geometry(r))
    fmt.Println(Geometry.Area(r))
    fmt.Println(Geometry.Perim(r))
}
```

要点一，接口的使用方法：用户通过接口+函数，来调用接口的某个函数，比如，Geometry.Area(r)。

要点二，Golang函数语法：func (r Rectangle) Area() float64表示Area()函数的输入值为Rectangle数据类型，返回值为float64数据类型——形式上等价于float64 Area(r Rectangle)。

<br />

#### 2.2. Case 2 -- Rectangle (传地址实现)

同样地，Rectange通过实现Geometry接口的所有抽象函数，来实现该接口。

```go
package main
import "fmt"

type Geometry interface{ // The Geometry interface
    Area() float64
    Perim() float64
}

type Rectangle struct{ // Define Rectagle's own Data Structure
    width, height float64
}

func (r *Rectangle) Area() float64 { // Implement the Area()
    return r.width * r.height
}

func (r *Rectangle) Perim() float64 { // Implement the Perim()
    return 2*r.width + 2*r.height
}

func main(){
    r := Rectangle{width:3, height:4}
    fmt.Println(Geometry(&r))
    fmt.Println(Geometry.Area(&r))
    fmt.Println(Geometry.Perim(&r))
}
```

要点一，接口的使用方法：用户通过接口+函数，来调用接口的某个函数，比如，Geometry.Area(&r)，注意，这里通过指针地址访问。

要点二，Golang函数语法：func (r *Rectangle) Area() float64表示Area()函数的输入值为指向Rectangle数据地址的指针类型。

要点三，传值操作通过临时变量不改变原始变量本身的值，而指针操作通过修改内存地址或其指向的内容直接改变变量本身或其值，所以，基于指针的操作或实现需要小心。



#### 2.3. Case 3 -- Circle (传值实现)

Circle通过实现Geometry接口的所有抽象函数，来实现该接口。

```go
package main
import "fmt"
import "math"

type Geometry interface{ // The Geometry interface
    Area() float64
    Perim() float64
}

type Circle struct{ // Define Rectagle's own Data Structure
    radius float64
}

func (r Circle) Area() float64 { // Implement the Area()
    return math.Pi * r.radius * r.radius
}

func (r Circle) Perim() float64 { // Implement the Perim()
    return 2 * math.Pi * r.radius
}

func main(){
    r := Circle{radius:3}
    fmt.Println(Geometry(r))
    fmt.Println(Geometry.Area(r))
    fmt.Println(Geometry.Perim(r))
}
```

要点一，接口的使用方法：用户通过接口+函数，来调用接口的某个函数，比如，Geometry.Area(r)。

要点二，Golang函数语法：func (r Circle) Area() float64表示Area()函数的输入值为Circle数据类型，返回值为float64数据类型。


<br />
<br />

## 参考资料
[1. Golang by examples] https://gobyexample.com/interfaces

<br />

#### 备注
[备注一] 初稿，2019年07月15号。





