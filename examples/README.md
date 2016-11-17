# Link Examples

Check out our code samples and community-contributed resources to kickstart your
Plaid Link integration!

## Client Libraries

Link provides a drop-in HTML snippet for the client-side integration but does
requires a server-side handler to coordinate exchanging a Link `public_token`
for a Plaid `access_token` via the [`/exchange_token` endpoint][exchange-token].

The `/exchange_token` endpoint is integrated into each of our client libraries.
Check out some examples:

- [plaid-node][plaid-node]
- [plaid-go][plaid-go]
- [plaid-ruby][plaid-ruby]
- [plaid-python][plaid-python]
- [plaid-java][plaid-java]

## Sum App

We built [Sum][link-demo] to demonstrate a sample Link client and server-side
integration using our [client libraries](#client-libraries). Check out the
source code in the language of your choice:

- [node.js](node)
- [go](go)
- [ruby](ruby)
- [requirejs](requirejs)
- python (coming soon!)

Each implementation has a complete README with instructions for running the app locally!

## WebViews

![mobile-web-beta](https://plaid.com/images/docs/link-docs-image-2.jpg)

WebViews open Link directly, rather than via an embedded iFrame.
Communication is standardized too for WebViews, employing the common
[URI scheme protocol][scheme-protocol] with query parameters to pass data
between your native app and the WebView. See the sample apps below for an
example integration, and checkout the [WebView docs][link-docs-webview] for more
information:

- [iOS WKWebView in Swift](wkwebview)
- [iOS UIWebView in Objective C](uiwebview)
- [Android WebView](android)

## Community Resources

- [Ember component][ember-plaid], by [@jasonkriss](https://github.com/jasonkriss)
- [Example Angular/Ionic app][plaid-link-ionic-example], by [@pbernasconi](https://github.com/pbernasconi)
- [Angular component][angular-plaid-link], by [@csbarnes](https://github.com/csbarnes)
- [React component][react-plaid-link], by [@pbernasconi](https://github.com/pbernasconi)

[angular-plaid-link]: https://github.com/csbarnes/angular-plaid-link
[ember-plaid]: https://github.com/jasonkriss/ember-plaid
[exchange-token]: https://github.com/plaid/link#exchange_token-endpoint
[link-demo]: https://demo.plaid.com
[link-docs-webview]: https://plaid.com/docs/quickstart#webview-integration
[plaid-go]: https://github.com/plaid/plaid-go#exchange-a-plaid-link-public_token-for-an-access_token
[plaid-java]: https://github.com/plaid/plaid-java#exchange-a-plaid-link-public_token-for-an-api-access_token
[plaid-link-ionic-example]: https://github.com/pbernasconi/plaid-link-ionic-example
[plaid-node]: https://github.com/plaid/plaid-node#examples
[plaid-python]: https://github.com/plaid/plaid-python#exchange
[plaid-ruby]: https://github.com/plaid/plaid-ruby#exchanging-a-link-public_token-for-a-plaid-access_token
[react-plaid-link]: https://github.com/pbernasconi/react-plaid-link
[scheme-protocol]: https://en.wikipedia.org/wiki/Uniform_Resource_Identifier
