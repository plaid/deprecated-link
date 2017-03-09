# Link WebView examples

![mobile-web-beta](https://plaid.com/images/docs/link-docs-image-2.jpg)

WebViews open Link directly, rather than via an embedded iFrame.
Communication is standardized too for WebViews, employing the common
[URI scheme protocol][scheme-protocol] with query parameters to pass data
between your native app and the WebView. See the sample apps below for an
example integration, and checkout the [WebView docs][link-docs-webview] for more
information:

- [iOS WKWebView in Swift](examples/wkwebview)
- [iOS UIWebView in Objective C](examples/uiwebview)
- [Android WebView](examples/android)

[link-docs-webview]: https://plaid.com/docs/api#webview-integration
[scheme-protocol]: https://en.wikipedia.org/wiki/Uniform_Resource_Identifier
