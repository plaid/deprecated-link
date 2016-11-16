//
//  ViewController.h
//  PlaidLinkWebviewExample
//
//  Copyright (c) 2016 Plaid Technologies, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LinkViewController : UIViewController<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webview;
@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;

- (IBAction)exitButton:(id)sender;

// Example Plaid Link helper methods
-(NSMutableDictionary*)dictionaryFromLinkUrl:(NSURL*)linkURL;
-(NSURL*)generateLinkInitializationURLWithOptions:(NSDictionary*)options;


@end
