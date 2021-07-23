package main

import "encoding/json"

type voResponse struct {
	Code    int     `json:"code"`
	Status  string  `json:"status"`
	//Message *string `json:"message"`
}

func makeVo(cod int, sta string) *voResponse {
	return &voResponse{Code: cod, Status: sta}
}

func makeDefaultVo() *voResponse {
	return makeVo(0, "ok")
}

func parseVo(data []byte) (*voResponse, error) {
	pvo := &voResponse{}
	//fmt.Println(string(resp.Body()))
	err := json.Unmarshal(data, pvo)
	if err != nil {
		return nil, err
	}
	return pvo, nil
}
