# project-csa node.js sample app

This is a simple web app that uses [Express][1] and [plaid-node][2] to demonstrate a client and server-side integration of [Project CSA][3].

## Getting Started

Clone the repository:

```console
$ git clone git@github.com:plaid/project-csa.git
```

Then:

```console
$ cd project-csa/examples/node
```

Install dependencies:

```console
$ npm install
```

## Set your `public_key`

The Project CSA integration lives in `/public/index.html`.  You **must** edit this file to replace `{YOUR_PUBLIC_KEY}` with your actual `public_key` from the [Plaid dashboard][4] if you wish to test with real accounts.

If you only wish to test with Plaid [sandbox accounts][5], you may skip this step.

## Running the server

The entry point for the server is `/.index.js`.  Required configuration options are passed in via environment variables:

- `APP_PORT`: the port on which the server should listen
- `PLAID_CLIENT_ID` and `PLAID_SECRET`: the client id and secret associated with your Plaid account, used to make authenticated Plaid API requests on the server

For example, the command below starts the server with the sandbox client_id and secret on port 8000:

```console
$ APP_PORT=8000 PLAID_CLIENT_ID={your client_id} PLAID_SECRET={your secret} node index.js
```

**Note:** To test with real accounts, you must use your actual `client_id` and `secret`, not the sandbox ones.

Then load up <http://localhost:8000>!

And that's it!

[1]: http://expressjs.com
[2]: https://github.com/plaid/plaid-node
[3]: https://plaid.github.io/project-csa
[4]: https://plaid.com/account/
[5]: https://plaid.com/docs#sandbox
