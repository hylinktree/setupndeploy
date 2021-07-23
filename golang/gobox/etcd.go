package main

import (
	"encoding/json"
	"fmt"

	"github.com/go-resty/resty"
)

type _inode struct {
	Dir           *bool    `json:"dir"`
	Key           *string  `json:"key"`
	Nodes         []_inode `json:"nodes"`
	CreatedIndex  *uint64  `json:"createdIndex"`
	ModifiedIndex *uint64  `json:"modifiedIndex"`
}

type etcd_response struct {
	ErrorCode     *int    `json:"errorCode"`
	Message       *string `json:"message"`
	Cause         *string `json:"cause"`
	Index         *int    `json:"index"`
	Action        *string `json:"action"`
	Dir           *bool   `json:"dir"`
	Node          *_inode `json:"node"`
	PrevNode      *_inode `json:"prevNode"`
	CreatedIndex  *uint64 `json:"createdIndex"`
	ModifiedIndex *uint64 `json:"modifiedIndex"`
}

func SimpleGet(psi *string) string {
	fmt.Println("f1.input=", *psi)
	// Create a Resty Client
	client := resty.New()

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
	//fmt.Println("raw.out=", ro)

	var bo []byte
	bo, errx = json.Marshal(ro)
	if errx != nil {
		fmt.Println(err)
		return ""
	}

	return string(bo)
}
