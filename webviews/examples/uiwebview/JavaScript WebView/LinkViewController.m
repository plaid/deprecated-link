//
//  ViewController.m
//  PlaidLinkWebviewExample
//
//  Copyright (c) 2016 Plaid Technologies, Inc. All rights reserved.
//

#import "LinkViewController.h"

@implementation LinkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _webview.delegate = self;

    // Build a dictionary with the Link configuration options
    // See the Link docs (https://plaid.com/docs/link) for full documentation.
    NSDictionary* linkInitializationOptions = [[NSMutableDictionary alloc] init];
    [linkInitializationOptions setValue:@"[PLAID_PUBLIC_KEY]" forKey:@"key"];
    [linkInitializationOptions setValue:@"auth" forKey:@"product"];
    [linkInitializationOptions setValue:@"sandbox" forKey:@"env"];
    [linkInitializationOptions setValue:@"true" forKey:@"selectAccount"];
    [linkInitializationOptions setValue:@"Test App" forKey:@"clientName"];
    [linkInitializationOptions setValue:@"https://requestb.in" forKey:@"webhook"];
    [linkInitializationOptions setValue:@"https://cdn.plaid.com/link/v2/stable/link.html" forKey:@"baseUrl"];

    // Generate the Link initialization URL based off of the configuration settings
    NSURL* linkInitializationUrl = [self generateLinkInitializationURLWithOptions:linkInitializationOptions];

    // Load the Link initialization URL in the webview.
    // Link will start automatically
    [_webview loadRequest:[NSURLRequest requestWithURL:linkInitializationUrl]];
}

// Helper method to generate the Link initialization URL given a dictionary of Link initialization keys and values
// The Webview should be loaded wtuh the URL returned by this function.
-(NSURL*)generateLinkInitializationURLWithOptions:(NSDictionary*)options {
    // http://stackoverflow.com/questions/718429/creating-url-query-parameters-from-nsdictionary-objects-in-objectivec
    NSURLComponents *components = [NSURLComponents componentsWithString:[options objectForKey:@"baseUrl"]];
    NSMutableArray *queryItems = [NSMutableArray array];
    [queryItems addObject:[NSURLQueryItem queryItemWithName:@"isWebview" value:@"true"]];
    for (NSString *key in options) {
        if (![key isEqualToString:@"baseUrl"]) {
            [queryItems addObject:[NSURLQueryItem queryItemWithName:key value:options[key]]];
        }
    }
    components.queryItems = queryItems;
    return [components URL];
};

// Helper method to generate a dictionary based on a Plaid Link action URL
-(NSMutableDictionary*)dictionaryFromLinkUrl:(NSURL*)linkURL {
    NSURLComponents *components = [NSURLComponents componentsWithString:linkURL.absoluteString];
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    for(NSURLQueryItem *item in components.queryItems) {
        [dict setObject:item.value forKey:item.name];
    }
    return dict;
}


- (IBAction)exitButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIWebViewDelegate methods

// This delegate method is used to grab any links used to "talk back" to Objective-C code from the html/JavaScript
-(BOOL) webView:(UIWebView *)inWeb
        shouldStartLoadWithRequest:(NSURLRequest *)request
        navigationType:(UIWebViewNavigationType)type {

    // Handle actions dispatched on the Link scheme, "plaidlink"
    // The host dictates the action type (such as "connected" or "exit") and
    // the querystring includes data such as the public_token and institution metadata.
    NSString *linkScheme = @"plaidlink";
    NSString *actionScheme = request.URL.scheme;
    NSString *actionType = request.URL.host;

    if ([actionScheme isEqualToString:linkScheme]) {
        NSLog(@"PLaid Link detected: %@", request.URL.absoluteString);
        if ([actionType isEqualToString:@"connected"]) {
            // Close the UIWebView
            [self dismissViewControllerAnimated:YES completion:nil];

            // Parse data passed from Link into a dictionary
            // This includes the public_token as well as account and institution metadata
            NSDictionary* linkData = [self dictionaryFromLinkUrl:request.URL];
            // Output data from Link
            NSLog(@"Public Token: %@", [linkData objectForKey:@"public_token"]);
            NSLog(@"Account ID: %@", [linkData objectForKey:@"account_id"]);
            NSLog(@"Institution type: %@", [linkData objectForKey:@"institution_type"]);
            NSLog(@"Institution name: %@", [linkData objectForKey:@"institution_name"]);
        } else if ([actionType isEqualToString:@"exit"]) {
            // Close the UIWebView
            [self dismissViewControllerAnimated:YES completion:nil];

            // Parse data passed from Link into a dictionary
            // This includes information about where the user was in the Link flow,
            // any errors that occurred, and request IDs
            NSLog(@"URL: %@", request.URL.absoluteString);
            NSDictionary* linkData = [self dictionaryFromLinkUrl:request.URL];
            // Output data from Link
            NSLog(@"User status in flow: %@", [linkData objectForKey:@"status"]);
            // The requet ID keys may or may not exist depending on when the user exited
            // the Link flow.
            NSLog(@"Link request ID: %@", [linkData objectForKey:@"link_request_id"]);
            NSLog(@"Plaid API request ID: %@", [linkData objectForKey:@"plaid_api_request_id"]);
        } else {
            NSLog(@"Link action detected: %@", actionType);
        }
        // Do not load these requests
        return NO;
    } else if (UIWebViewNavigationTypeLinkClicked == type &&
               ([actionScheme isEqualToString:@"http"] ||
                [actionScheme isEqualToString:@"https"])) {
        // Handle http:// and https:// links inside of Plaid Link,
        // and open them in a new Safari page. This is necessary for links
        // such as "forgot-password" and "locked-account"
        [[UIApplication sharedApplication] openURL:[request URL]];
        return NO;
    } else {
        NSLog(@"Unrecognized URL scheme detected that is neither HTTP, HTTPS, or related to Plaid Link: %@", request.URL.absoluteString);
        return YES;
    }
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
