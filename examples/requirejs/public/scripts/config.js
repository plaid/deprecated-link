'use strict';

// configure RequireJS to load the link-initialize script
// *NOTE: the '*.js' extension is ommittedg
requirejs.config({
  paths: {
    'Plaid': 'https://cdn.plaid.com/link/v2/stable/link-initialize'
  },
  // Plaid Link doesn't current support AMD
  // therefore we must create a shim to expose the global handler
  shim: {
    'Plaid': {
      exports: 'window.Plaid'
    }
  }
});
