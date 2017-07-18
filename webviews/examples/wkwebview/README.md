# Plaid Link - WKWebView

A simple example of Link inside of an WkWebView.

## How to run the example

First, you'll need a Plaid `public_key`. Head on over
to [our documentation][quickstart] if you don't have one already.

Inside `LinkViewController.swift`, look for `[PLAID_PUBLIC_KEY]` and replace it
with your own.

Run the project. By default it is set up to run inside our `sandbox`
environment, meaning that instead of connecting actual bank accounts you can use
a set of [fake credentials][sandbox-docs] in order to test different types of
behavior.

[quickstart]: https://plaid.com/docs/quickstart/
[sandbox-docs]: https://plaid.com/docs/api/#sandbox
