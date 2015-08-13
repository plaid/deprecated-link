//
//  ViewController.m
//  Plaid Link UIWebView
//
//  Created by Paolo Bernasconi.
//  Copyright (c) 2015 Plaid LLC. All rights reserved.
//

#import "LinkViewController.h"

@implementation LinkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_webview setDelegate: self];
    
    NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    if ([htmlFile length]) {
        
        // Get the contents of the html file
        NSError *error = NULL;
        NSString *html = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:&error];
        if ([html length]) {
            
            // Define the string to inject into the html file - this can be anything you like including
            // JavaScript code, html, css, etc. - anything that the client can handle
            NSString *stringToInject = @"Click OK then watch the NSLog output for whatever follows the abc:// URL in the html file.";
            
            // Inject the string by replacing our placeholder. You can use anything you like as a placeholder
            // here including a comment such as <!-- put stuff here -->, etc. I happen to be setting a JavaScript
            // variable in this case but you could just as easily fill in the contents of a <div>, etc.
            html = [html stringByReplacingOccurrencesOfString:@"%inject%" withString:stringToInject];
            
            // Get the base URL of the file in question, in case the page loads any other assets, etc.
            NSURL *baseURL = [NSURL fileURLWithPath:htmlFile];
            
            // Load the html into the web view
            [_webview loadHTMLString:html baseURL:baseURL];
            
        } // handle error here
    } // handle error here
}


- (IBAction)exitButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIWebViewDelegate methods

// This delegate method is used to grab any links used to "talk back" to Objective-C code from the html/JavaScript
-(BOOL) webView:(UIWebView *)inWeb
        shouldStartLoadWithRequest:(NSURLRequest *)request
        navigationType:(UIWebViewNavigationType)type {
    
    // these need to match the values defined in your JavaScript
    NSString *linkScheme = @"linkApp";
    NSString *actionScheme = request.URL.scheme;
    NSString *actionType = request.URL.host;
    
    if ([actionScheme isEqualToString:linkScheme]) {
        NSLog(@"%@", request.URL.scheme);
    }
    
    // look at the actionType and do whatever you want here
    if ([actionType isEqualToString:@"handlePublicToken"]) {
        NSLog(@"public_token: %@", request.URL.fragment); // send this public_token to your server, where you can exchange it with for an access_token
        [self dismissViewControllerAnimated:true completion:^(){}]; // close the WebView modal
    } else if ([actionType isEqualToString:@"closeLinkModal"]) {
        NSLog(@"closeLinkModal");
    } else if ([actionType isEqualToString:@"handleOnLoad"]) {
        NSLog(@"handleOnLoad");
    } else if ([actionType isEqualToString:@"handleOnExit"]) {
        NSLog(@"handleOnExit");
    }
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    // handle webViewDidStartLoad
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    // handle webViewDidFinishLoad
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
