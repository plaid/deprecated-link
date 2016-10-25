Link Mobile Beta
---

![mobile-web-beta](https://cloud.githubusercontent.com/assets/1716394/19668683/4b6e5b82-9a0e-11e6-89ad-e362f34e0e31.jpg)

Plaid Link has been refactored and redesigned from the ground up to perform better
on mobile browsers, and iOS and Android Webviews. We're still a few weeks out
from release, but wanted to share a beta release to gather feedback and
identify remaining bugs.

The current beta release is located in the `/beta` directory.

- When integrating Link on the web, use `https://cdn.plaid.com/link/beta/link-initialize.js`
- When integrating Link within a WebView, use `https://cdn.plaid.com/link/beta/link.html`

Stay tuned for updates to the [`CHANGELOG.md`](CHANGELOG.md) throughout the
development of the beta candidate.

> **NOTE** - please open any beta issues inside of the [Issues section of this
repository](https://github.com/plaid/link/issues/).

## Integrating

The Link JavaScript web integration (desktop and mobile) has not changed. See
the [docs][link-docs] for more.

On a mobile device, though, Link will now open in a new tab rather than
presenting a modal on the host page. All Link functionality is still supported,
including custom initializers, longtail, and update mode.

If integrating Link within a WebView, though, you will need to update your
integration. WebViews now open the Link directly, rather than via an embedded
iFrame. Communication is standardized too for WebViews, employing the common
[URI scheme protocol][scheme-protocol] with query parameters to pass data
between your native app and the WebView. Below is an example response from a
connected Link account.

```
// scheme   :// action  ? query-params
   plaidlink://connected?public_token=test,wells,connected&account_id=abc123
```

Because Link is now initialized directly, configuration options, such as `key`
and `env`, are passed via the querystring. Below is an an example of this URL:

```
link.html?product=auth&key=test_key&env=tartan&clientName=ClientName&longtail=true&isWebview=true&isMobile=true
```

## Known issues

- (Web) Opening Link, exiting and re-opening is currently broken

## Examples

Find examples of a mobile Link integration within an iOS and Android WebView
below. The sample integrations include example code to initialize Link and
receive data from Link (analogous to `onSuccess` and `onExit`).

- [iOS UIWebView](uiwebview)
- iOS WKWebView (coming soon)
- [Android WebView](android)

[link-docs]: https://plaid.com/docs/quickstart
[scheme-protocol]: https://en.wikipedia.org/wiki/Uniform_Resource_Identifier
