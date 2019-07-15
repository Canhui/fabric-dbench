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
