'use strict';

// Require "Plaid" to load the Link script
require(['Plaid'], function(Plaid) {

  // The Plaid handler is now available view the RequireJS
  var sandboxHandler = Plaid.create({
   clientName: 'SUM',
   env: 'tartan', // change this variable to 'production' for production use
   product: 'auth',
   key: 'test_key', // add you own public_key here
   onSuccess: function(token) {
     window.location = '/accounts.html?public_token=' + token;
   }
  });

  // Open the "Institution Select" view using the sandbox Link handler.
  document.getElementById('sandboxLinkButton').onclick = function() {
   sandboxHandler.open();
  };
});
