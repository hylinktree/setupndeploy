package main

import (
	"encoding/json"
	"flag"
	"fmt"
	"os"
	"time"

	"github.com/go-resty/resty/v2"
)

const (
	// URLFormatDayJob : dayjob 2006-01-02
	URLFormatDayJob = "%s/stat/between_wisByHour/day/%s/%s"

	// URLFormatWeekJob : weekjob 2006-ww
	URLFormatWeekJob = "%s/stat/between_wisByHour/week/%s/%s"

	// URLFormatMonthJob : monthjob 2006-mm
	URLFormatMonthJob = "%s/stat/between_wisByHour/month/%s/%s"

	// URLFormatYearJob : yearjob 2006
	URLFormatYearJob = "%s/stat/between_wisByHour/year/%d"
)

type wisResponse struct {
	Code    *int    `json:"code"`
	Status  *string `json:"status"`
	Message *string `json:"message"`
}

type postmanArgsResponse struct {
	Foo1 *string `json:"foo1"`
	Foo2 *string `json:"foo2"`
}

type postmanResponse struct {
	Args *postmanArgsResponse `json:"args"`
}

func WisController(args []string) {
	wiscmd := flag.NewFlagSet("wiscon", flag.ExitOnError)

	phost := wiscmd.String("host", "http://gdca.io:9200", "host url")
	pbackoffs := wiscmd.Int("backs", 1, "backoff days")
	palljobs := wiscmd.Bool("alljobs", false, "perform all jobs")
	pdayjob := wiscmd.Bool("dayjob", false, "perform day job")
	pweekjob := wiscmd.Bool("weekjob", false, "perform week job")
	pmonthjob := wiscmd.Bool("monthjob", false, "perform month job")
	pyearjob := wiscmd.Bool("yearjob", false, "perform year job")

	wiscmd.Parse(args)
	fmt.Printf("options:\n\t(host, backs)=(%s, %d)\n"+
		"\tflags.(all day week month year)=(%t %t %t %t %t)\n"+
		"\tremains=%s\n",
		*phost, *pbackoffs, *palljobs, *pdayjob, *pweekjob, *pmonthjob, *pyearjob, wiscmd.Args())

	var ta, tb time.Time
	var err error
	for {
		args = wiscmd.Args()
		tb = time.Now()
		if len(args) == 0 {
			ta = tb.AddDate(0, 0, -*pbackoffs)
			break
		}

		ta, err = time.Parse("2006-01-02", args[0])
		if err != nil {
			fmt.Println(err)
			os.Exit(-1)
		}

		if len(args) > 1 {
			tb, err = time.Parse("2006-01-02", args[1])
			if err != nil {
				fmt.Println(err)
				os.Exit(-1)
			}
		}
		break
	}

	fmt.Printf("\trange.(begin end)=(%s %s)\n",
		fmt.Sprintf("%s", ta.Format("2006-01-02")),
		fmt.Sprintf("%s", tb.Format("2006-01-02")))

	var url, strsta, strstp, errstr string
	var pro *wisResponse
	var year, week int

	// perform day job
	if *palljobs || *pdayjob {
		strsta = fmt.Sprintf("%s", ta.Format("2006-01-02"))
		strstp = fmt.Sprintf("%s", tb.Format("2006-01-02"))
		url = fmt.Sprintf(URLFormatDayJob, *phost, strsta, strstp)
		fmt.Printf("sending day job %s ... ", url)
		if pro, errstr = WisCall(&url); errstr != "" {
			fmt.Printf("Fail(%s)\n", errstr)
			return
		}
		fmt.Printf("Pass\n\t(%s)\n", *pro.Message)
	}

	// perform week job
	if *palljobs || *pweekjob {
		year, week = ta.ISOWeek()
		strsta = fmt.Sprintf("%04d-%02d", year, week)
		year, week = tb.ISOWeek()
		strstp = fmt.Sprintf("%04d-%02d", year, week)
		url = fmt.Sprintf(URLFormatWeekJob, *phost, strsta, strstp)
		fmt.Printf("sending week job %s ... ", url)
		if pro, errstr = WisCall(&url); errstr != "" {
			fmt.Printf("Fail(%s)\n", errstr)
			return
		}
		fmt.Printf("Pass\n\t(%s)\n", *pro.Message)
	}

	// perform month job
	if *palljobs || *pmonthjob {
		strsta = fmt.Sprintf("%04d-%02d", ta.Year(), ta.Month())
		strstp = fmt.Sprintf("%04d-%02d", tb.Year(), tb.Month())
		url = fmt.Sprintf(URLFormatMonthJob, *phost, strsta, strstp)
		fmt.Printf("sending month job %s ... ", url)
		if pro, errstr = WisCall(&url); errstr != "" {
			fmt.Printf("Fail(%s)\n", errstr)
			return
		}
		fmt.Printf("Pass\n\t(%s)\n", *pro.Message)
	}

	// perform year job
	if !*palljobs && !*pyearjob {
		return
	}

	url = fmt.Sprintf(URLFormatYearJob, *phost, ta.Year())
	fmt.Printf("sending year job %s ... ", url)
	if pro, errstr = WisCall(&url); errstr != "" {
		fmt.Printf("Fail(%s)\n", errstr)
		return
	}
	fmt.Printf("Pass\n\t(%s)\n", *pro.Message)

	// perform next year, if needed
	if ta.Year() == tb.Year() {
		return
	}

	url = fmt.Sprintf(URLFormatYearJob, *phost, tb.Year())
	fmt.Printf("sending year job %s ... ", url)
	if pro, errstr = WisCall(&url); errstr != "" {
		fmt.Printf("Fail(%s)\n", errstr)
		return
	}
	fmt.Printf("Pass\n\t(%s)\n", *pro.Message)
}

func AGet(psi *string) *wisResponse {
	fmt.Println("f1.input=", *psi)
	// Create a Resty Client
	client := resty.New()
	dur, _ := time.ParseDuration("24h")
	client.SetTimeout(dur)

	resp, err := client.R().Get(*psi)
	if err != nil {
		fmt.Println(err)
		return nil
	}

	ro := wisResponse{}
	errx := json.Unmarshal(resp.Body(), &ro)
	if errx != nil {
		fmt.Println(err)
		return nil
	}
	fmt.Println("raw.out=", ro)

	var bo []byte
	bo, errx = json.Marshal(ro)
	if errx != nil {
		fmt.Println(err)
		return nil
	}
	fmt.Println("formatted.out=", string(bo))

	return &ro
}

func WisCall(psi *string) (*wisResponse, string) {
	//fmt.Println("f1.input=", *psi)
	// Create a Resty Client
	client := resty.New()
	dur, _ := time.ParseDuration("24h")
	client.SetTimeout(dur)

	resp, err := client.R().Get(*psi)
	if err != nil {
		fmt.Println(err)
		return nil, "connection failure"
	}

	ro := wisResponse{}
	errx := json.Unmarshal(resp.Body(), &ro)
	if errx != nil {
		fmt.Println(err)
		return nil, "illegal json response"
	}

	if *ro.Code != 0 || *ro.Status != "ok" {
		return nil, fmt.Sprintf("Bad response (%d, %s)", *ro.Code, *ro.Status)
	}
	return &ro, ""
}

func CGet(psi *string) *postmanResponse {
	fmt.Println("f1.input=", *psi)
	// Create a Resty Client
	client := resty.New()
	dur, _ := time.ParseDuration("24h")
	client.SetTimeout(dur)

	resp, err := client.R().Get(*psi)
	if err != nil {
		fmt.Println(err)
		return nil
	}

	ro := postmanResponse{}
	errx := json.Unmarshal(resp.Body(), &ro)
	if errx != nil {
		fmt.Println(err)
		return nil
	}
	fmt.Println("raw.out=", ro)

	var bo []byte
	bo, errx = json.Marshal(ro)
	if errx != nil {
		fmt.Println(err)
		return nil
	}
	fmt.Println("formatted.out=", string(bo))

	return &ro
}
