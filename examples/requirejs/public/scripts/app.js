'use strict';

// Require "Plaid" to load the Link script
require(['Plaid'], function(Plaid) {

  // The Plaid handler is now available view the RequireJS
  var sandboxHandler = Plaid.create({
    clientName: 'SUM',
    env: 'tartan', // change this variable to 'production' for production use
    product: 'auth',
    key: 'test_key', // add you own public_key here
    onSuccess: function(token, metadata) {
      console.log('account_id is', metadata.account_id);
      window.location = '/accounts.html?public_token=' + token;
    },
    onLoad: function() {
      console.log('Plaid Link loaded');
    }
    onExit: function(error, metadata) {
      // if the user encountered a Plaid error, this will not be null
      if (error != null) {
       console.log('error code: '    + error.code);
       console.log('error message: ' + error.message);
      }

      // log information about the selected institution – note: may be null
      console.log('institution name: ' + metadata.institution.name);
      console.log('institution type: ' + metadata.institution.type);

      console.log('link_request_id: '      + metadata.link_request_id);
      console.log('plaid_api_request_id: ' + metadata.plaid_api_request_id);
      console.log('status: '               + metadata.status);
    }
  });

  // Open the "Institution Select" view using the sandbox Link handler.
  document.getElementById('sandboxLinkButton').onclick = function() {
    sandboxHandler.open();
  };
});
