# plaid-link Go sample app

This is a simple web app that uses [Negroni][1] and [plaid-go][2] to demonstrate a client and server-side integration of [Plaid Link][3].

## Getting Started

`go get` the repository:

```console
$ go get -u github.com/plaid/link
```

`go get` will complain about `no buildable Go source files`, but you can safely ignore this.

Then:

```console
$ cd $GOPATH/src/github.com/plaid/link/examples/go && go get
```

Build the binary:

```console
$ go build -o go-example
```

## Set your `public_key`

The Plaid Link integration lives in `/public/index.html`.  You **must** edit this file to replace `{YOUR_PUBLIC_KEY}` with your actual `public_key` from the [Plaid dashboard][4] if you wish to test with real accounts.

If you only wish to test with Plaid [sandbox accounts][5], you may skip this step.

## Running the server

The entry point for the server is `./server.go`.  Required configuration options are passed in via environment variables:

- `APP_PORT`: the port on which the server should listen
- `PLAID_CLIENT_ID` and `PLAID_SECRET`: the client id and secret associated with your Plaid account, used to make authenticated Plaid API requests on the server

For example, the command below starts the server with the sandbox client_id and secret on port 8000:

```console
$ APP_PORT=8000 PLAID_CLIENT_ID=test_id PLAID_SECRET=test_secret ./go-example
```

**Note:** To test with non-sandbox accounts, simply replace `test_id` and `test_secret` with your `client_id` and `secret`, which can be found on the [Plaid dashboard][4].

Then load up <http://localhost:8000>!

And that's it!

[1]: http://github.com/codegangsta/negroni
[2]: https://github.com/plaid/plaid-go
[3]: https://github.com/plaid/link
[4]: https://plaid.com/account/
[5]: https://plaid.com/docs#sandbox
