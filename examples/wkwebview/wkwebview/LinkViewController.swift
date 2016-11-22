//
//  LinkViewController.swift
//  wkwebview
//
//  Copyright (c) 2016 Plaid Technologies, Inc. All rights reserved.
//

import UIKit
import WebKit

class LinkViewController: UIViewController, WKNavigationDelegate {
    
    /// URLs matching this scheme will be intercepted & handled by this view controller
    private static let linkScheme = "plaidlink"
    
    var webView: WKWebView!
    
    override func loadView() {
        createWebview()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadLinkModuleInWebview()
    }
    
    private func createWebview() {
        webView = WKWebView()
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = false
        view = webView
    }
    
    private func loadLinkModuleInWebview() {
        let linkUrl = generateLinkInitializationURL()
        let url = NSURL(string: linkUrl)
        let request = NSURLRequest(url:url! as URL)
        webView.load(request as URLRequest)
    }
    
    private func parseQueryParams(fromURL url: URL) -> Dictionary<String, String> {
        var paramsDictionary = [String: String]()
        let queryItems = NSURLComponents(string: (url.absoluteString))?.queryItems
        queryItems?.forEach { paramsDictionary[$0.name] = $0.value }
        return paramsDictionary
    }
    
    // generateLinkInitializationURL :: create the link.html url with query parameters
    private func generateLinkInitializationURL() -> String {
        let config = [
            "key": "test_key",
            "product": "connect",
            "longtail": "true",
            "selectAccount": "true",
            "env": "tartan",
            "clientName": "Test App",
            "webhook": "https://requestb.in",
            "isMobile": "true",
            "isWebview": "true"
        ]
        
        // Build a dictionary with the Link configuration options
        // See the Link docs (https://plaid.com/docs/link) for full documentation.
        let components = NSURLComponents()
        components.scheme = "https"
        components.host = "cdn.plaid.com"
        components.path = "/link/v2/stable/link.html"
        components.queryItems = config.map { (NSURLQueryItem(name: $0, value: $1) as URLQueryItem) }
        return components.string!
    }
    
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping ((WKNavigationActionPolicy) -> Void)) {
        
        guard let url = navigationAction.request.url else {
            assertionFailure("Expected navigationAction to have non-nil URL")
            decisionHandler(.allow)
            return
        }
        
        if matchesLinkScheme(url) {
            interceptPlaidLinkURL(url: url)
            decisionHandler(.cancel)
        }
        else if shouldOpenInSafari(navigationAction: navigationAction) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            decisionHandler(.cancel)
        }
        else {
            print("Unrecognized URL scheme detected that is neither HTTP, HTTPS, or related to Plaid Link: \(navigationAction.request.url?.absoluteString)");
            decisionHandler(.allow)
        }
    }
    
    private func interceptPlaidLinkURL(url: URL) {
        let params = parseQueryParams(fromURL: url)
        let actionType = url.host
        
        switch actionType {
        case "connected"?:
            handleUserLinkedAccount(withParameters: params)
        case "exit"?:
            handleUserCancelledLink(atURL: url, withParameters: params)
        default:
            print("Link action detected: \(actionType)")
        }
    }
    
    private func handleUserLinkedAccount(withParameters params: [String: String]) {
        // Close the webview
        dismiss(animated: true, completion: nil)
        
        // You should store & process this data, usually by alerting a helper or delegate
        print("Public Token: \(params["public_token"])")
        print("Account ID: \(params["account_id"])")
        print("Institution type: \(params["institution_type"])")
        print("Institution name: \(params["institution_name"])")
    }
    
    private func handleUserCancelledLink(atURL url: URL, withParameters params: [String: String]) {
        // Close the webview
        dismiss(animated: true, completion: nil)
        
        // Available information includes information about where the user was in the Link flow
        // any errors that occurred, and request IDs
        print("URL: \(url.absoluteString)")
        // Output data from Link
        print("User status in flow: \(params["status"])");
        // The requet ID keys may or may not exist depending on when the user exited
        // the Link flow.
        print("Link request ID: \(params["link_request_id"])");
        print("Plaid API request ID: \(params["link_request_id"])");
    }
    
    private func matchesLinkScheme(_ url: URL) -> Bool {
        return url.scheme == LinkViewController.linkScheme
    }
    
    // Handle http:// and https:// links inside of Plaid Link
    // by opening them in a new Safari page. This is necessary for links
    // such as "forgot-password" and "locked-account"
    private func shouldOpenInSafari(navigationAction: WKNavigationAction) -> Bool {
        guard let scheme = navigationAction.request.url?.scheme else {
            return false
        }
        return navigationAction.navigationType == WKNavigationType.linkActivated &&
            (scheme == "http" || scheme == "https")
    }
}
