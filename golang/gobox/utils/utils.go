package utils

import (
	"fmt"
	"time"
)

func ShowDate() {
	now := time.Now()
	fmt.Println("gobox runs @ ", now)
}
