//
//  LinkViewController.swift
//  wkwebview
//
//  Copyright (c) 2016 Plaid Technologies, Inc. All rights reserved.
//

import UIKit
import WebKit

class LinkViewController: UIViewController, WKNavigationDelegate {
    
    
    var webView: WKWebView!
    
    override func loadView() {
        createWebview()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // load the link url
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
    
    // parseQueryParams :: parse query parameters into a Dictionary
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
                 decidePolicyForNavigationAction navigationAction: WKNavigationAction,
                 decisionHandler: ((WKNavigationActionPolicy) -> Void)) {
        
        let linkScheme = "plaidlink"
        let actionScheme = navigationAction.request.url?.scheme
        let actionType = navigationAction.request.url?.host
        let queryParams = parseQueryParams(fromURL: navigationAction.request.url!)
        
        if (actionScheme == linkScheme) {
            switch actionType {
                
            case "connected"?:
                // Close the webview
                self.dismiss(animated: true, completion: nil)
                
                // Parse data passed from Link into a dictionary
                // This includes the public_token as well as account and institution metadata
                print("Public Token: \(queryParams["public_token"])")
                print("Account ID: \(queryParams["account_id"])")
                print("Institution type: \(queryParams["institution_type"])")
                print("Institution name: \(queryParams["institution_name"])")
                break
            case "exit"?:
                // Close the webview
                self.dismiss(animated: true, completion: nil)
                
                // Parse data passed from Link into a dictionary
                // This includes information about where the user was in the Link flow
                // any errors that occurred, and request IDs
                print("URL: \(navigationAction.request.url?.absoluteString)")
                // Output data from Link
                print("User status in flow: \(queryParams["status"])")
                // The requet ID keys may or may not exist depending on when the user exited
                // the Link flow.
                print("Link request ID: \(queryParams["link_request_id"])")
                print("Plaid API request ID: \(queryParams["link_request_id"])")
                break
                
            default:
                print("Link action detected: \(actionType)")
                break
            }
            
            decisionHandler(.cancel)
        } else if (navigationAction.navigationType == WKNavigationType.linkActivated &&
            (actionScheme == "http" || actionScheme == "https")) {
            // Handle http:// and https:// links inside of Plaid Link,
            // and open them in a new Safari page. This is necessary for links
            // such as "forgot-password" and "locked-account"
            UIApplication.shared.openURL(navigationAction.request.url!)
            decisionHandler(.cancel)
        } else {
            print("Unrecognized URL scheme detected that is neither HTTP, HTTPS, or related to Plaid Link: \(navigationAction.request.url?.absoluteString)")
            decisionHandler(.allow)
        }
    }
}
