package main

import (
	"encoding/json"
	"net/http"
	"net/url"
	"os"
	"strconv"

	"github.com/plaid/plaid-go/plaid"

	"github.com/codegangsta/negroni"
	"github.com/gorilla/mux"
)

var APP_PORT int
var PLAID_CLIENT_ID string
var PLAID_SECRET string

var plaidClient *plaid.Client

type AccountsJsonHolder struct {
	Accounts []plaid.Account `json:"accounts"`
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
	router.HandleFunc("/accounts", AccountsHandler).Queries("public_token", "{public_token}")
	// Instantiate and start server
	n := negroni.Classic()
	n.UseHandler(router)
	n.Run(":" + strconv.Itoa(APP_PORT))
}

// AccountsHandler handles endpoint /accounts that first exchanges a public_token from the Plaid
// Link module for a Plaid access token and then uses that access_token to retrieve account data and
// balances for a user.
//
// Input: a public_token
// Output: an error or an array of accounts
func AccountsHandler(w http.ResponseWriter, r *http.Request) {
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
	// Auth Get user accounts with access token
	res, err = plaidClient.AuthGet(accessToken)
	if err != nil {
		w.Write([]byte(err.Error()))
		return
	}
	// Marshal and write response JSON
	outputHolder := AccountsJsonHolder{
		Accounts: res.Accounts,
	}
	outputJson, err := json.Marshal(outputHolder)
	if err != nil {
		w.Write([]byte(err.Error()))
		return
	}
	w.Header().Set("Content-Type", "application/json")
	w.Write(outputJson)
}
