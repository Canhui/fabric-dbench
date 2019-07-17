package main

import (
    "context"
    "fmt"
    "time"
)

func contextHandler() {
    ctx, cancel:= context.WithTimeout(context.Background(), 10*time.Second)

    go doSomething(ctx)

    time.Sleep(100 * time.Second) // 主线程main挂起不能早于子线程goroutine
    cancel()
}

func doSomething(ctx context.Context) {
    for {
        time.Sleep(1 * time.Second)
        select {
        case <- ctx.Done():
            return
        default:
            fmt.Println("Work...")
        }
    }
}

func main() {
    contextHandler()
}

// package main

// import (
// 	"context"
// 	"fmt"
// 	"time"
// )

// func contextHandler() {
// 	ctx, cancel:= context.WithTimeout(context.Background(), 10*time.Second)
// 	defer cancel()

// 	doSomething(ctx)
// }

// func doSomething(ctx context.Context) {
// 	for {
// 		time.Sleep(1 * time.Second)
// 		select {
// 		case <- ctx.Done():
// 			return
// 		default:
// 			fmt.Println("Work...")
// 		}
// 	}
// }

// func main() {
// 	contextHandler()
// }



// ---------------------------------------------------------------------

// package main
// import "fmt"

// func printHello(ch chan int) {
//     fmt.Println("hi, this is from printHello()")
//     ch <- 2 // send a value (2) to the channel
// }

// func main() {
//     ch := make(chan int) // make a channel

//     go func() {
//         fmt.Println("hi, this is from main.func()")
//         ch <- 1 // send a value (1) to the channel
//     }()

//     go printHello(ch) // send a value (2) to the channel
    
//     i := <- ch // read first value (1 or 2) from the channel
//     <- ch // read second value (2 or 1) from the channel
//     close(ch) // channel队列之前写入两个值，也读取完两个值。所以，队列为空，这里可以关闭。
//     fmt.Println("Received", i)   
// }




//-----------------------------------------------------------------------

// package main

// import (
//     "context"
//     //"log"
//     //"os"
//     "fmt"
//     "time"
// )

// //var logg *log.Logger

// func someHandler() {
//     ctx, cancel := context.WithCancel(context.Background())
    
//     go doStuff(ctx)

// 	//10秒后取消doStuff
//     time.Sleep(5 * time.Second)
//     cancel()

// }

// //每1秒work一下，同时会判断ctx是否被取消了，如果是就退出
// func doStuff(ctx context.Context) {
//     for {
//         time.Sleep(1 * time.Second)
//         select {
//         case <-ctx.Done():
//         	fmt.Println("done")
//             //logg.Printf("done")
//             return
//         default:
//         	fmt.Println("work")
//             //logg.Printf("work")
//         }
//     }
// }

// func main() {
//     //logg = log.New(os.Stdout, "", log.Ltime)
//     someHandler()
//     //logg.Printf("down")
// }

// ------------------------------------------------------------------

// package main

// import "fmt"
// import "golang.org/x/net/context"

// // A message processes parameter and returns the result on responseChan.
// // ctx is places in a struct, but this is ok to do.
// type message struct {
// 	responseChan chan<- int
// 	parameter    string
// 	ctx          context.Context
// }

// func ProcessMessages(work <-chan message) {
// 	for job := range work {
// 		select {
// 		// If the context is finished, don't bother processing the
// 		// message.
// 		case <-job.ctx.Done():
// 			continue
// 		default:
// 		}
// 		// Assume this takes a long time to calculate
// 		hardToCalculate := len(job.parameter)
// 		select {
// 		case <-job.ctx.Done():
// 		case job.responseChan <- hardToCalculate:
// 		}
// 	}
// }

// func newRequest(ctx context.Context, input string, q chan<- message) {
// 	r := make(chan int)
// 	select {
// 	// If the context finishes before we can send msg onto q,
// 	// exit early
// 	case <-ctx.Done():
// 		fmt.Println("Context ended before q could see message")
// 		return
// 	case q <- message{
// 		responseChan: r,
// 		parameter:    input,
// 		// We are placing a context in a struct.  This is ok since it
// 		// is only stored as a passed message and we want q to know
// 		// when it can discard this message
// 		ctx: ctx,
// 	}:
// 	}

// 	select {
// 	case out := <-r:
// 		fmt.Printf("The len of %s is %d\n", input, out)
// 	// If the context finishes before we could get the result, exit early
// 	case <-ctx.Done():
// 		fmt.Println("Context ended before q could process message")
// 	}
// }

// func main() {
// 	q := make(chan message)
// 	go ProcessMessages(q)
// 	ctx := context.Background()
// 	newRequest(ctx, "hi", q)
// 	newRequest(ctx, "hello", q)
// 	close(q)
// }

// ----------------------------------------------------------------
// package main 
 
// import (
//     "fmt"
//     "context"
//     "time"
// )
 
// type Context interface {
//     Deadline() (deadline time.Time, ok bool)
//     Done() <-chan struct{}
//     Err() error
//     Value(key interface{}) interface{}
// }

// func contextDemo(name string, ctx context.Context) {    
//     for {
//         if ok {
//             fmt.Println(name, "will expire at:", deadline)
//         } else {
//             fmt.Println(name, "has no deadline")
//         }
//         time.Sleep(time.Second)
//     }
// }

// func main() {
//     timeout := 3 * time.Second
//     deadline := time.Now().Add(4 * time.Hour)
//     timeOutContext, _ := context.WithTimeout(
//         context.Background(), timeout)
//     cancelContext, cancelFunc := context.WithCancel(
//         context.Background())
//     deadlineContext, _    := context.WithDeadline(
//         cancelContext, deadline)
 
 
//     go contextDemo("[timeoutContext]", timeOutContext)
//     go contextDemo("[cancelContext]", cancelContext)
//     go contextDemo("[deadlineContext]", deadlineContext)
 
//     // Wait for the timeout to expire
//     <- timeOutContext.Done()
 
//     // This will cancel the deadline context as well as its
//     // child - the cancelContext
//     fmt.Println("Cancelling the cancel context...")
//     cancelFunc()
 
//     <- cancelContext.Done()
//     fmt.Println("The cancel context has been cancelled...")
 
//     // Wait for both contexts to be cancelled
//     <- deadlineContext.Done()
//     fmt.Println("The deadline context has been cancelled...")
// }

// -----------------------------------------------------------------

// package main

// import (
// 	// "bufio"
// 	"context"
// 	"fmt"
// 	"log"
// 	// "os"
// 	"time"
// )

// func withTimeOut() {
// 	ctx := context.Background()
// 	ctx, cancel := context.WithTimeout(ctx, time.Second)
// 	defer cancel()

// 	sleepAndTalk(ctx, 5*time.Second, "Hello withTimeOut!")
// }

// func withCancel() {
// 	ctx := context.Background()
// 	ctx, cancel := context.WithCancel(ctx)

// 	// go func() {
// 	// 	s := bufio.NewScanner(os.Stdin)
// 	// 	s.Scan()
// 	// 	cancel()
// 	// }()

// 	sleepAndTalk(ctx, 5*time.Second, "Hello withCancel!")
// }

// func background() {
// 	ctx := context.Background()
// 	sleepAndTalk(ctx, 5*time.Second, "Hello background!")
// }

// func sleepAndTalk(ctx context.Context, d time.Duration, s string) {
// 	select {
// 	case <-time.After(d):
// 		fmt.Println(s)
// 	case <-ctx.Done():
// 		log.Println(ctx.Err())
// 	}
// }

// func main() {
// 	background()
// 	withCancel()
// 	withTimeOut()
// }
