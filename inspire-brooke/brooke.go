package main

import (
	"encoding/json"
	"log"
	"math/rand"
	"net/http"
	"time"

	"github.com/gorilla/mux"
)

var quotes = []string{
	"Don't hate the player, hate the game",
	"Capitalism is a scam",
	"A whale of a good time",
}

type Brooke struct {
	Quote string `json:"quote"`
}

func getRandomQuote() string {
	s := rand.NewSource(time.Now().Unix())
	r := rand.New(s)
	i := r.Intn(len(quotes))
	return quotes[i]
}

func home(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(Brooke{Quote: getRandomQuote()})
}

func main() {
	router := mux.NewRouter().StrictSlash(true)
	router.HandleFunc("/api/brooke", home)
	log.Fatal(http.ListenAndServe(":8000", router))
}
