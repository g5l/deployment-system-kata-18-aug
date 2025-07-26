package main

import (
    "fmt"
    "log"
    "net/http"
    "os"
)

func main() {
    port := os.Getenv("PORT")
    if port == "" {
        port = "8080"
    }

    http.HandleFunc("/", handleHome)
    http.HandleFunc("/health", handleHealth)

    fmt.Printf("Server starting on port: ", port)
    log.Fatal(http.ListenAndServe(":"+port, nil))
}

func handleHome(w http.ResponseWriter, r *http.Request) {
    fmt.Fprintf(w, `
    <h1>Hello DevOps World!</h1>
    <p><a href="/health">Health Check</a></p>
    `)
}

func handleHealth(w http.ResponseWriter, r *http.Request) {
    fmt.Fprintf(w, "OK - Application is healthy!")
}