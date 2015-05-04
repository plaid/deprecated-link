'use strict';

var envvar = require('envvar');
var express = require('express');
var plaid = require('plaid');

var APP_PORT = envvar.number('APP_PORT');

var PLAID_CLIENT_ID = envvar.string('PLAID_CLIENT_ID');
var PLAID_SECRET = envvar.string('PLAID_SECRET');

var plaidClient =
  new plaid.Client(PLAID_CLIENT_ID, PLAID_SECRET, plaid.environments.tartan);

// Configure Express
var app = express();
app.use(express.static('public'));

// AJAX endpoint that first exchanges a public_token from the Project CSA
// module for a Plaid access token and then uses that access_token to
// retrieve account data and balances for a user.
//
// Input: a public_token
// Output: an error or an array of accounts
app.get('/accounts', function(req, res, next) {
  var public_token = req.query.public_token;

  plaidClient.exchangeToken(public_token, function(err, tokenResponse) {
    if (err != null) {
      res.json({error: 'Unable to exchange public_token'});
    } else {
      // The exchange was successful - this access_token can now be used to
      // safely pull account and routing numbers or transaction data for the
      // user from the Plaid API using your private client_id and secret.
      var access_token = tokenResponse.access_token;

      plaidClient.getAuthUser(access_token, function(err, authResponse) {
        if (err != null) {
          res.json({error: 'Unable to pull accounts from the Plaid API'});
        } else {
          // Return a JSON body containing the user's accounts, which
          // includes names, balances, and account and routing numbers.
          res.json({accounts: authResponse.accounts});
        }
      });
    }
  });
});

var server = app.listen(APP_PORT, function () {
  console.log('project-csa-demo server listening on port ' + String(APP_PORT));
});
