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

    go printHello(ch)
    i := <- ch
    fmt.Println("Received", i)
    <- ch
}