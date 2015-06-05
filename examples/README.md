# Link Examples

Check out our code samples and community-contributed resources to kickstart your Plaid Link integration!

## Client Libraries

Link provides a drop-in HTML snippet for the client-side integration but does requires a server-side handler to coordinate exchanging a Link `public_token` for a Plaid `access_token` via the [`/exchange_token` endpoint][10].

The `/exchange_token` endpoint is integrated into each of our client libraries. Check out some examples:

- [plaid-node][6]
- [plaid-go][7]
- [plaid-ruby][8]
- [plaid-python][9]
- [plaid-java][12]

## Sum App

We built [Sum][1] to demonstrate a sample Link client and server-side integration using our [client libraries](#client-libraries). Check out the source code in the language of your choice:
- [node.js][3]
- [go][4]
- [ruby][11]
- python (coming soon!)

Each implementation has a complete README with instructions for running the app locally!

## Community Resources

- [Ember component][5], by [@jasonkriss](https://github.com/jasonkriss)

[1]: https://link-demo.plaid.com
[2]: https://plaid.com/docs/#resources
[3]: https://github.com/plaid/link/tree/master/examples/node
[4]: https://github.com/plaid/link/tree/master/examples/go
[5]: https://github.com/jasonkriss/ember-plaid
[6]: https://github.com/plaid/plaid-node#examples
[7]: https://github.com/plaid/plaid-go#exchange-a-plaid-link-public_token-for-an-access_token
[8]: https://github.com/plaid/plaid-ruby#exchanging-a-link-public_token-for-a-plaid-access_token
[9]: https://github.com/plaid/plaid-python#exchange
[10]: https://github.com/plaid/link#exchange_token-endpoint
[11]: https://github.com/plaid/link/tree/master/examples/ruby
[12]: https://github.com/plaid/plaid-java#exchange-a-plaid-link-public_token-for-an-api-access_token
