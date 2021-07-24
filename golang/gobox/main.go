package main

import (
	"encoding/json"
	"flag"
	"fmt"
	"os"
	"time"

	"github.com/go-resty/resty/v2"
)

type response1 struct {
	Args    map[string]string `json:"args"`
	Headers map[string]string `json:"headers"`
	Url     string            `json:"url"`
}

func BGet(psi *string) string {
	fmt.Println("f1.input=", *psi)
	// Create a Resty Client
	client := resty.New()
	dur, _ := time.ParseDuration("24h")
	client.SetTimeout(dur)

	resp, err := client.R().Get(*psi)
	if err != nil {
		fmt.Println(err)
		return ""
	}
	fmt.Println("raw=", resp.String())

	ro := etcd_response{}
	errx := json.Unmarshal(resp.Body(), &ro)
	if errx != nil {
		fmt.Println(err)
		return ""
	}
	return *ro.Action
}

func main() {
	var yy := BGet("https://google.com")
	now := time.Now()
	fmt.Println("gcbox runs @ ", now)

	if len(os.Args) < 2 {
		fmt.Println("!!No command to run")
		os.Exit(-1)
	}

	switch os.Args[1] {
	case "wiscon":
		//wiscmd.Parse(os.Args[2:])
		WisController(os.Args[2:])
	case "echo":
		EchoSrvA(os.Args[2:])
	default:
		fmt.Println("!!Unkown command to run")
		os.Exit(-1)
	}

	flag.Parse()

}

func xmain() {
	/*
		v := flag.Bool("v", false, "v var")
		z := flag.Bool("dailyforce", true, "z var")
		q := flag.Bool("q", false, "q var")

		flag.Parse()
		fmt.Println(*v, *z, *q, flag.Args())
		if *q {
			return
		}
	*/

	now := time.Now()
	fmt.Println("gcbox runs @ ", now)
	/*	var pr2 *postmanResponse
		posturl := "https://postman-echo.com/get?foo1=bar1&foo2=bar2"
		pr2 = CGet(&posturl)
		fmt.Println("ret=", pr2)
		fmt.Println(*pr2.Args.Foo1, *pr2.Args.Foo2)
	*/

	phost := flag.String("host", "http://gdca.io:9200", "host url")
	pbackoffs := flag.Int("backs", -1, "backoff days")
	pdailywork := flag.Bool("dailywork", false, "perform daily work")
	pdayjob := flag.Bool("dayjob", false, "perform day job")
	flag.Parse()

	if *pdayjob {
		fmt.Println("perform dayjob")
	}

	if *pdailywork {
		fmt.Println("perform daily job")
	}

	return

	fmt.Printf("flags=(%s, %d)\n", *phost, *pbackoffs)
	sta := now.AddDate(0, 0, *pbackoffs)

	var url, strsta, strstp, errstr string
	var pro *wisResponse
	var year, week int

	// perform day job
	strsta = fmt.Sprintf("%s", sta.Format("2006-01-02"))
	strstp = fmt.Sprintf("%s", now.Format("2006-01-02"))
	url = fmt.Sprintf(URLFormatDayJob, *phost, strsta, strstp)
	fmt.Printf("sending day job %s ... ", url)
	if pro, errstr = WisCall(&url); errstr != "" {
		fmt.Printf("Fail(%s)\n", errstr)
		return
	}
	fmt.Printf("Pass\n\t%s\n", *pro.Message)

	// perform week job
	year, week = sta.ISOWeek()
	strsta = fmt.Sprintf("%04d-%02d", year, week)
	year, week = now.ISOWeek()
	strstp = fmt.Sprintf("%04d-%02d", year, week)
	url = fmt.Sprintf(URLFormatWeekJob, *phost, strsta, strstp)
	fmt.Printf("sending week job %s ... ", url)
	if pro, errstr = WisCall(&url); errstr != "" {
		fmt.Printf("Fail(%s)\n", errstr)
		return
	}
	fmt.Printf("Pass\n\t%s\n", *pro.Message)

	// perform month job
	strsta = fmt.Sprintf("%04d-%02d", sta.Year(), sta.Month())
	strstp = fmt.Sprintf("%04d-%02d", now.Year(), now.Month())
	url = fmt.Sprintf(URLFormatMonthJob, *phost, strsta, strstp)
	fmt.Printf("sending month job %s ... ", url)
	if pro, errstr = WisCall(&url); errstr != "" {
		fmt.Printf("Fail(%s)\n", errstr)
		return
	}
	fmt.Printf("Pass\n\t%s\n", *pro.Message)

	// perform year job
	url = fmt.Sprintf(URLFormatYearJob, *phost, sta.Year())
	fmt.Printf("sending year job %s ... ", url)
	if pro, errstr = WisCall(&url); errstr != "" {
		fmt.Printf("Fail(%s)\n", errstr)
		return
	}
	fmt.Printf("Pass\n\t%s\n", *pro.Message)

	// perform next year, if needed
	if sta.Year() == now.Year() {
		return
	}

	url = fmt.Sprintf(URLFormatYearJob, *phost, now.Year())
	fmt.Printf("sending year job %s ... ", url)
	if pro, errstr = WisCall(&url); errstr != "" {
		fmt.Printf("Fail(%s)\n", errstr)
		return
	}
	fmt.Printf("Pass\n\t%s\n", *pro.Message)
}
