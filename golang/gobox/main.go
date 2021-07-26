package main

import (
	"encoding/json"
	"flag"
	"fmt"
	"os"
	"sync"
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

// Employee is an interface for printing employee details
type Employee interface {
	PrintName(name string)
	PrintSalary(basic int, tax int) int
}

// Emp user-defined type
type Emp int

type Kmp struct {
	id   int
	name string
}

func (e Kmp) PrintName(name string) {
	fmt.Printf("ID:%d name:%s\n", e.id, e.name)
}
func (e Kmp) PrintSalary(basic int, tax int) int {
	fmt.Printf("Salary is %d\n", basic+tax)
	return basic + tax
}

// PrintName method to print employee name
func (e Emp) PrintName(name string) {
	fmt.Println("Employee Id:\t", e)
	fmt.Println("Employee Name:\t", name)
}

// PrintSalary method to calculate employee salary
func (e Emp) PrintSalary(basic int, tax int) int {
	var salary = (basic * tax) / 100
	return basic - salary
}

func main5() {
	var e1 Employee
	e1 = Emp(1)
	e1.PrintName("John Doe")
	fmt.Println("Employee Salary:", e1.PrintSalary(25000, 5))

	e1 = Kmp{22, "smith"}
	e1.PrintName("dolly")
	e1.PrintSalary(999, 888)
}

type I interface {
	M()
	// Q()
}

type T struct {
	S string
}

// This method means type T implements the interface I,
// but we don't need to explicitly declare that it does so.
func (t T) M() {
	fmt.Println(t.S)
}

func main3() {
	var i I = T{"hello"}
	i.M()
}

func worker(id int, wg *sync.WaitGroup) {

	// defer wg.Done()

	fmt.Printf("Worker %d starting\n", id)

	time.Sleep(time.Second)
	fmt.Printf("Worker %d done\n", id)
	wg.Add(-1)
}

func main2() {

	var wg sync.WaitGroup

	for i := 1; i <= 5; i++ {
		wg.Add(1)
		go worker(i, &wg)
	}
	// wg.Add(9)

	wg.Wait()
}

func main() {
	// main5()
	// main2()
	// var yy := BGet("https://google.com")
	now := time.Now()
	fmt.Println("gcbox runs @ ", now)

	if len(os.Args) < 2 {
		fmt.Println("!!No command to run")
		os.Exit(-1)
	}

	switch os.Args[1] {
	case "runsrv":
		DeployServers(1)
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
	fmt.Println("End")

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
