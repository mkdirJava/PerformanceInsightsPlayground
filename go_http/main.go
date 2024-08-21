package main

import (
	"io"
	"net/http"
)

func main() {
	http.HandleFunc("/test", func(w http.ResponseWriter, r *http.Request) {
		io.WriteString(w, "test")
	})
	if err := http.ListenAndServe(":8080", nil); err != nil {
		panic(err)
	}
}
