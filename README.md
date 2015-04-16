# Project CSA

Our mission at Plaid is to enable developers to quickly and securely integrate
their users' financial data to their applications and services. Project CSA
supports this goal by providing a drop-in module that offers a secure, elegant
authentication flow for each institution that we support. The module handles
input validation, error handling, and multi-factor authentication flows.

View the [sandbox demo][1] (use Plaid [sandbox credentials][2] &ndash;
username: `plaid_test`, password: `plaid_good`) or the [live demo][3]
(use live bank account credentials) to familiarize yourself with this module.

![Flow](http://i.imgur.com/cRts1NM.png)

## Getting started

### Step 1: Acquire public key

In order to start using CSA you'll first need to find your public key. Public
keys have been distributed on an invitation-only basis while CSA is in beta
(if you'd like an invitation, please email <info@plaid.com>).

If you received an invitation, view your account on the [Plaid dashboard][4],
under the 'Your keys' section you will find a `public_key`. You'll include
this `public_key` as a `data-` attribute in your HTML file (`data-key`,
specifically, while the `client_id` and `secret` are kept private on your
server.

*Bank account credentials are sent securely to Plaid via an HTTPS connection
along with your `public_key`. If this succeeds, Plaid will return a public
access token (`connect_access_token`) which will then be posted to your
server at an endpoint you specify. You'll then send this along with your
private `client_id` and `secret` to the CSA `/token` endpoint at
`https://connect.plaid.com/token`. This endpoint returns an access token
that can be used to make Plaid API requests to retrieve a user's transaction
or account data.*

### Step 2: Insert client-side snippet

Include the following markup in your site or web application:

```html
<!-- The CSA access token will be POST'd to /authenticate -->
<form id="some-id" method="POST" action="/authenticate"></form>

<!--
  data-client-name: a string shown to users upon successfully linking their account
  data-form-id: the DOM id of the CSA form
  data-key: your public_key, available from the dashboard
  data-product: connect or auth
  data-env: tartan or production
  data-webhook: webhook URI when using connect
-->
<script
  src="https://cdn.plaid.com/connect/stable/connect-initialize.js"
  data-client-name="Client Name"
  data-form-id="some-id"
  data-key="your-public-key-here"
  data-product="auth"
  data-env="tartan"
  data-webhook="https://myapp.com/webhook">
</script>
```

Replace `"/authenticate"` with the endpoint on your server which would handle
receiving the public access token and exchanging it for a Plaid access token,
giving you access to a user's accounts (and transactions if applicable).

Set the values of the `data-` attributes appropriately. All attributes except
`data-webhook` are required. `data-product` must be either `auth` or `connect`.
`data-env` must be either `tartan` or `production`. The `data-env` value
determines which API endpoint you will access using the Plaid access token.
For non-production use, set `data-env` to `tartan`.

The code snippet above will inject a button with text `Link your bank account`.
This button can be styled with standard CSS selectors:

```css
#some-id button {
  border: 10px solid pink;
}
```

### Step 3: Write server-side handler

In order for CSA to return the user account data to your app, you must first
include server-side code that correctly handles what Plaid returns. The data
flow is depicted below.

                                         ┌──────────────┐
                                         │              │
                                         │     CSA      │
                                         │    /token    │
                                         │   endpoint   │
                                         │              │
                                         └────────┬─────┘
                                              ▲   │
                                              │   │
                                              │   │
                           CSA access token  ╔╩╗ ╔╩╗
                           + your client id  ║2║ ║3║   Plaid access token
                              + your secret  ╚╦╝ ╚╦╝
                                              │   │
                                              │   │         Plaid access token
                                              │   ▼          + your client id
    ┌──────────┐    CSA access token     ┌────┴─────────┐      + your secret      ┌─────────┐
    │          │        ╔═╗              │              │        ╔═╗              │         │
    │   User   ├────────╣1╠────────────▶ │  Client App  ├────────╣4╠────────────▶ │  Plaid  │
    │ Browser  │        ╚═╝  ╔═╗         │    Server    │        ╚═╝  ╔═╗         │   API   │
    │          │ ◀───────────╣6╠─────────┤              │ ◀───────────╣5╠─────────┤         │
    └──────────┘             ╚═╝         └──────────────┘             ╚═╝         └─────────┘
                        Account data                             Account data

The `/token` (`https://connect.plaid.com/token`) endpoint expects a POST
request with three parameters: `connect_access_token`, `client_id`, and
`secret`. If the request succeeds (200 OK), the endpoint will return a
JSON response body with a `plaid_access_token` field.

__Include a request handler similar to the following in your back-end
application code:__

```javascript
var express = require('express');
var request = require('request');

var app = express();

app.post('/authenticate', function(req, res) {
  // POST to /token endpoint with a JSON body
  request({
    method: 'POST',
    uri: 'https://connect.plaid.com/token',
    headers: {'Content-Type': 'application/json'},
    body: JSON.stringify({
      connect_access_token: req.body.connect_access_token,
      client_id: process.env.PLAID_CLIENT_ID,
      secret: process.env.PLAID_SECRET,
    }),
  }, function(err, res) {
    if (err != null) {
      res.send('Oh no!');
    } else {
      // Use res.body.plaid_access_token to make a Plaid
      // API request to retrieve bank acccount data
      request({
        method: 'POST',
        uri: 'https://tartan.plaid.com/auth/get',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({
          access_token: res.body.plaid_access_token,
          client_id: process.env.PLAID_CLIENT_ID,
          secret: process.env.PLAID_SECRET,
        }),
      }, function(err, res) {
        if (err != null) {
          res.send('Oh no!');
        } else {
          res.send('Success!');
        }
      });
    }
  });
});
```

### Step 4: Test with sandbox credentials

The CSA module has a sandbox mode that works with the [Plaid API sandbox][2].
To enable the sandbox, set `data-key` to `test_key`. This lets you see the flow
for each individual institution Plaid supports, including the multi-factor
authentication process when applicable.

```html
<form id="some-id" method="POST" action="/authenticate"></form>

<script
  src="https://cdn.plaid.com/connect/stable/connect-initialize.js"
  data-client-name="Client Name"
  data-form-id="some-id"
  data-key="test_key"
  data-product="auth"
  data-env="tartan">
</script>
```

If you are having trouble using the module in sandbox mode, check the
developer console in your browser for error messages.

## Security

All data sent to Plaid is encrypted using a secure HTTPS connection with our
servers. While you can use the module on a non-HTTPS site (all data sent to
Plaid operates in an entirely different context and connection), we highly
recommend using HTTPS at all times.

More information about Plaid's security policies and practices can be found
on our [website][5].

## Browser support

:warning: __Currently only desktop browsers are supported.__

| Browser                                                                                                                                                                     | Supported?        |
| --------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------- |
| <img width="32" height="32" alt="Google Chrome" src="https://raw.githubusercontent.com/alrra/browser-logos/master/chrome/chrome_64x64.png" />                               | Fully supported   |
| <img width="32" height="32" alt="Firefox" src="https://raw.githubusercontent.com/alrra/browser-logos/master/firefox/firefox_64x64.png" />                                   | Fully supported   |
| <img width="32" height="32" alt="Safari" src="https://raw.githubusercontent.com/alrra/browser-logos/master/safari/safari_64x64.png" />                                      | Fully supported   |
| <img width="32" height="32" alt="Internet Explorer" src="https://raw.githubusercontent.com/alrra/browser-logos/master/internet-explorer/internet-explorer_64x64.png" /> 10  | Fully supported   |
| <img width="32" height="32" alt="Internet Explorer" src="https://raw.githubusercontent.com/alrra/browser-logos/master/internet-explorer/internet-explorer_64x64.png" /> 9   | Not yet supported |
| <img width="32" height="32" alt="Internet Explorer" src="https://raw.githubusercontent.com/alrra/browser-logos/master/internet-explorer/internet-explorer_64x64.png" /> 8   | Not supported     |

## Expansion

In the near term, we'll be rolling out support for Internet Explorer 9 and
full support for the mobile web. In future iterations, the CSA team plans to
release native modules for both iOS and Android, as well as vanilla unstyled
versions for clients who would like to make CSA their own.

We will also release the ability to more fully control the CSA experience by
allowing for custom initializers (via an exposed namespace in the browser)
and custom callbacks once a user has linked their account.

## Support

For most matters, [open an issue][6].

If you would rather keep the request private, please contact
<support@plaid.com>.

:warning: Do **not** include your `client_id` or `secret` in any issue or
support request. :)


[1]: http://plaid.github.io/project-csa
[2]: https://plaid.com/docs#sandbox
[3]: http://plaid.github.io/project-csa/live.html
[4]: https://plaid.com/account/
[5]: https://plaid.com/security
[6]: https://github.com/plaid/project-csa/issues/new
