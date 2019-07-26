## 1. Go-Event Official Project

https://github.com/docker/go-events



## 2. Go-Event Official Example


example2.1: https://levelup.gitconnected.com/lets-write-a-simple-event-bus-in-go-79b9480d8997

example2.2: https://thoughtbot.com/blog/writing-a-server-sent-events-server-in-go


基于event事件的例子，大量接口随便写，一个终端读，

```go
package main
import (
    "fmt"
    "github.com/docker/go-events"
    "time"
)

type eventRecv struct {
    name string
}

func (e *eventRecv)Write(event events.Event) error {
    fmt.Printf("%s receives %d\n", e.name, event.(int))
    return nil
}

func (e *eventRecv)Close() error {
    return nil
}

func createEventRecv(name string) *eventRecv {
    return &eventRecv{name}
}

func main() {
    e1 := createEventRecv("A")
    e2 := createEventRecv("B")
    e3 := createEventRecv("C")

    bc1 := events.NewBroadcaster(e1, e2, e3)
    bc2 := events.NewBroadcaster(e1, e2)

    bc1.Write(1)
    bc2.Write(2)
    time.Sleep(4*time.Second)
}
```








## 参考资料
[1. Hyperledger event事件用于block propagation] https://hyperledger-fabric.readthedocs.io/en/release-1.4/peer_event_services.html
[2. 官方go-event] https://github.com/docker/go-events
[3. 官方go-event example] https://nanxiao.me/go-events-package-intro/