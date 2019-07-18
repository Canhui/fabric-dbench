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
