package main

import (
	"flag"
	"fmt"
	"sync"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/go-resty/resty/v2"
)

type echoParams struct {
	name       string
	dsthost    string
	port       string
	terminator bool
	delay      int
}

var gEchoParams = echoParams{}

func handlePing(c *gin.Context) {
	var err error

	pvo := makeDefaultVo()
	count := c.Query("count")
	fmt.Printf("query.(delay count)=(%d %s)", gEchoParams.delay, count)
	time.Sleep(time.Duration(gEchoParams.delay) * time.Millisecond)
	if gEchoParams.terminator {
		pvo.Status = fmt.Sprintf("Hello#%s.%s(%s)", count, gEchoParams.name, gEchoParams.port)
		fmt.Println("outputA is", pvo)
		c.JSON(200, pvo)
		return
	}

	client := resty.New()
	dur, _ := time.ParseDuration("10m")
	client.SetTimeout(dur)
	req := fmt.Sprintf("%s/ping?count=%s", gEchoParams.dsthost, count)
	fmt.Println("req=", req)
	resp, err := client.R().Get(req)
	if err != nil {
		fmt.Println(err)
		c.AbortWithError(404, err)
		return
	}
	pvi, errx := parseVo(resp.Body())
	if errx != nil {
		fmt.Println(errx)
		c.JSON(404, nil)
		return
	}
	pvo.Status = fmt.Sprintf("Hello#%s.%s(%s).{%s}", count, gEchoParams.name, gEchoParams.port, pvi.Status)
	fmt.Println("outputB is", pvo)
	c.JSON(200, pvo)
}

func EchoSrvA(args []string) {

	cmds := flag.NewFlagSet("echosrv", flag.ExitOnError)

	cmds.StringVar(&gEchoParams.dsthost, "dsthost", "http://localhost:8081", "host url")
	cmds.StringVar(&gEchoParams.port, "port", "8081", "my expose port(=8081)")
	cmds.BoolVar(&gEchoParams.terminator, "terminator", false, "Be a terminator(=false)")
	cmds.StringVar(&gEchoParams.name, "name", "echosrv", "My name(=echosrv)")
	cmds.IntVar(&gEchoParams.delay, "delay", 0, "process delay in ms(0 ms)")

	cmds.Parse(args)

	fmt.Println("process.delay=", gEchoParams.delay, "ms")

	r := gin.Default()
	// r.GET("/ping", handlePing)
	r.GET("/xing", func(c *gin.Context) {
		pvo := makeDefaultVo()
		// count := c.Query("count")
		// fmt.Printf("query.(delay count)=(%d %s)", gEchoParams.delay, count)
		// time.Sleep(time.Duration(gEchoParams.delay) * time.Millisecond)
		// if gEchoParams.terminator {
		pvo.Status = fmt.Sprintf("Hello.from{%s:%s}",
			gEchoParams.name, gEchoParams.port)
		// fmt.Println("outputA is", pvo)
		c.JSON(200, pvo)
		// return
		// }
	})
	r.Run(":" + gEchoParams.port) // listen and serve on 0.0.0.0:8080
}

func DeployClients(args []string) {
	wiscmd := flag.NewFlagSet("wiscon", flag.ExitOnError)
	pcount := wiscmd.Int("count", 1, "concurrent servers")
	pruns := wiscmd.Int("runs", 1, "runs")

	wiscmd.Parse(args)

	var wg sync.WaitGroup
	for i := 0; i < *pcount; i++ {
		sname := fmt.Sprintf("srv%03d", i)
		sport := fmt.Sprintf("%d", 8100+i)
		wg.Add(1)
		go runCli(sname, sport, *pruns)
	}
	wg.Wait()
}

func runCli(sname string, sport string, runs int) {
	client := resty.New()
	dur, _ := time.ParseDuration("10m")
	client.SetTimeout(dur)
	req := fmt.Sprintf("http://%s:%s/xping", "localhost", sport)
	fmt.Println("req=", req)
	for i := 0; i < runs; i++ {
		resp, err := client.R().Get(req)
		if err != nil {
			fmt.Println(err)
			break
		}
		fmt.Println(resp)
	}

}

func DeployServers(args []string) {
	gin.SetMode(gin.ReleaseMode)

	wiscmd := flag.NewFlagSet("wiscon", flag.ExitOnError)
	pcount := wiscmd.Int("count", 1, "concurrent servers")

	wiscmd.Parse(args)
	var wg sync.WaitGroup
	for i := 0; i < *pcount; i++ {
		sname := fmt.Sprintf("srv%03d", i)
		sport := fmt.Sprintf("%d", 8100+i)
		wg.Add(1)
		go runSrv(sname, sport)
	}
	wg.Wait()
}
func runSrv(sname string, sport string) {
	visitors := 0

	r := gin.Default()
	r.GET("/xping", func(c *gin.Context) {
		pvo := makeDefaultVo()
		// count := c.Query("count")
		// fmt.Printf("query.(delay count)=(%d %s)", gEchoParams.delay, count)
		// time.Sleep(time.Duration(gEchoParams.delay) * time.Millisecond)
		// if gEchoParams.terminator {
		pvo.Status = fmt.Sprintf("Hello.from{%s:%s}, cnt=%d",
			sname, sport, visitors)
		visitors += 1
		// fmt.Println("outputA is", pvo)
		c.JSON(200, pvo)
		// return
		// }
	})
	fmt.Printf("make srv@%s\n", sport)
	r.Run(":" + sport) // listen and serve on 0.0.0.0:8080
}
