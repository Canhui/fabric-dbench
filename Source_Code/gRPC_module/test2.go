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
