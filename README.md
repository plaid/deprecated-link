# Project

"Project" is a yet-to-be-named project for integrating with the Plaid API
more easily than was previously possible.

In addition to your `CLIENT_ID` and `SECRET` you'll need your `PUBLIC_KEY`
which is available from the [Plaid dashboard][1].

You'll include `PUBLIC_KEY` as a `data-` attribute in your HTML file. The
`CLIENT_ID` and `SECRET` are kept private on your server. When a user submits
her bank account credentials they'll be sent to Plaid along with your
`PUBLIC_KEY`. If this succeeds, Plaid will return a public access token which
will then be posted to your server at an endpoint you specify. You'll then send
this along with your private `CLIENT_ID` and `SECRET` to the Plaid API to
connect the user's account.

### Browser support

:warning: __Currently only desktop browsers are supported.__

| Browser                                                                                                                                                                     | Supported?        |
| --------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------- |
| <img width="32" height="32" alt="Google Chrome" src="https://raw.githubusercontent.com/alrra/browser-logos/master/chrome/chrome_64x64.png" />                               | Fully supported   |
| <img width="32" height="32" alt="Firefox" src="https://raw.githubusercontent.com/alrra/browser-logos/master/firefox/firefox_64x64.png" />                                   | Fully supported   |
| <img width="32" height="32" alt="Safari" src="https://raw.githubusercontent.com/alrra/browser-logos/master/safari/safari_64x64.png" />                                      | Fully supported   |
| <img width="32" height="32" alt="Internet Explorer" src="https://raw.githubusercontent.com/alrra/browser-logos/master/internet-explorer/internet-explorer_64x64.png" /> 10  | Fully supported   |
| <img width="32" height="32" alt="Internet Explorer" src="https://raw.githubusercontent.com/alrra/browser-logos/master/internet-explorer/internet-explorer_64x64.png" /> 9   | Not yet supported |
| <img width="32" height="32" alt="Internet Explorer" src="https://raw.githubusercontent.com/alrra/browser-logos/master/internet-explorer/internet-explorer_64x64.png" /> 8   | Not supported     |

### Client-side script

Include the following markup in your site or web application:

```html
<form id="some-id" method="POST" action="/authenticate"></form>

<script
  src="https://cdn.plaid.com/connect/0.0.21/connect-initialize.js"
  data-client-name="Client Name"
  data-form-id="some-id"
  data-key="your-public-key"
  data-product="auth"
  data-use-sandbox="false">
```

Replace `"/authenticate"` with the endpoint on your server which would handle
receiving the public access token and exchanging it for a Plaid access token,
giving you access to a user's accounts (and transactions if applicable).

Set the values of the `data-` attributes appropriately. All attributes except
`data-use-sandbox` are required.

### Server-side code

Include a request handler similar to the following in your back-end application
code:

```javascript
var express = require('express');
var request = require('request');

var app = express();

app.post('/authenticate', function(req, res) {
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
      request({
        method: 'POST',
        uri: 'https://api.plaid.com/auth/get',
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


[1]: https://plaid.com/account/
