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