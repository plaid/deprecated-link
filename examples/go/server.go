package main

import (
	"encoding/json"
	"math/rand"
	"mime"
	"net/http"
	"net/url"
	"os"
  "path"
	"path/filepath"
	"strconv"
	"strings"
	"time"

	"github.com/plaid/plaid-go/plaid"

	"github.com/codegangsta/negroni"
	"github.com/gorilla/mux"
)

var APP_PORT int
var PLAID_CLIENT_ID string
var PLAID_SECRET string

var plaidClient *plaid.Client

var songsDirectory string
var songsRelativeDirectory string = "/songs"

type SongJsonHolder struct {
	SongName string `json:"song_name"`
  SongPath string `json:"song_path"`
  SignalAX []float64 `json:"signal_ax"`
  SignalAY []float64 `json:"signal_ay"`
  SignalBX []float64 `json:"signal_bx"`
  SignalBY []float64 `json:"signal_by"`
}

func init() {
	// Get APP_PORT env var
	var err error
	appPortStr := os.Getenv("APP_PORT")
	if appPortStr == "" {
		panic("APP_PORT env var not set.")
	}
	APP_PORT, err = strconv.Atoi(appPortStr)
	if err != nil {
		panic(err)
	}
	// Get PLAID_CLIENT_ID env var
	PLAID_CLIENT_ID = os.Getenv("PLAID_CLIENT_ID")
	if PLAID_CLIENT_ID == "" {
		panic("PLAID_CLIENT_ID env var not set.")
	}
	// Get PLAID_SECRET env var
	PLAID_SECRET = os.Getenv("PLAID_SECRET")
	if PLAID_SECRET == "" {
		panic("PLAID_SECRET env var not set.")
	}
	// Create Plaid client with credentials and Tartan environment
	plaidClient = plaid.NewClient(PLAID_CLIENT_ID, PLAID_SECRET, plaid.Tartan)
}

func main() {
	// Set routes
	router := mux.NewRouter()
	router.HandleFunc("/transactions", TransactionsHandler).Queries("public_token", "{public_token}")
	router.HandleFunc("/songs", SongServer)
	// Instantiate and start server
	n := negroni.Classic()
	n.UseHandler(router)
	n.Run(":" + strconv.Itoa(APP_PORT))
}

// TransactionsHandler handles endpoint /transactions that first exchanges a public_token from the Plaid
// Link module for a Plaid access token and then uses that access_token to retrieve transaction data
//
// Input: a public_token
// Output: an error or a byte array containing transactions json
func TransactionsHandler(w http.ResponseWriter, r *http.Request) {
	// Get and URL decode public_token query param
	vars := mux.Vars(r)
	publicToken, err := url.QueryUnescape(vars["public_token"])
	if err != nil {
		w.Write([]byte(err.Error()))
		return
	}
	// Exchange public token for access token
	res, err := plaidClient.ExchangeToken(publicToken)
	if err != nil {
		w.Write([]byte(err.Error()))
		return
	}
	accessToken := res.AccessToken
	// Connect Get user accounts with access token
	res, _, err = plaidClient.ConnectGet(accessToken, nil)
	if err != nil {
		if strings.Contains(err.Error(), "code: 1110") {
			plaidClient.Upgrade(accessToken, "connect", nil)
			res, _, err = plaidClient.ConnectGet(accessToken, nil)
		}
		if err != nil {
			w.Write([]byte(err.Error()))
			return
		}
	}

	//storeAllSignals(songsDirectory)
	songName, rawSignalA, rawSignalB := findMostSimilar(transactionAmounts(res.Transactions, SAMPLE_LIMIT))
  songPath := path.Join(songsRelativeDirectory, songName)

  signalAX, signalAY := splitXY(rawSignalA)
  signalBX, signalBY := splitXY(rawSignalB)

	// Marshal and write response JSON
	outputHolder := SongJsonHolder{
		SongName: songName,
    SongPath: songPath,
    SignalAX: signalAX,
    SignalAY: signalAY,
    SignalBX: signalBX,
    SignalBY: signalBY,
	}
	outputJson, err := json.Marshal(outputHolder)
	if err != nil {
		w.Write([]byte(err.Error()))
		return
	}

	w.Header().Set("Content-Type", "application/json")
	w.Write(outputJson)
}

func SongServer(w http.ResponseWriter, r *http.Request) {
    vars := mux.Vars(r)

    // Assuming it's valid
    file := vars["filename"]

    // Super simple. Doesn't set any cache headers, check existence, avoid race conditions, etc.
    w.Header().Set("Content-Type", mime.TypeByExtension(filepath.Ext(file)))
    http.ServeFile(w, r, file)
}

func transactionAmounts(trans []plaid.Transaction, limit int) []float64 {
	var amounts []float64
	for i := 0; i < len(trans) && i < limit; i++ {
		amounts = append(amounts, float64(trans[i].Amount))
	}
	return amounts
}

func randomFloats(size int) []float64 {
	var result []float64
	source := rand.NewSource(time.Now().UnixNano())
	random := rand.New(source)
	for i := 0; i < size; i++ {
		result = append(result, random.Float64())
	}
	return result
}

func splitXY(signal [][]float64) ([]float64, []float64) {
  var signalX []float64
  var signalY []float64

  for i := 0; i < len(signal); i++ {
    signalX = append(signalX, signal[i][0])
    signalY = append(signalY, signal[i][1])
  }

  return signalX, signalY
}
