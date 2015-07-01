//
//  ViewController.h
//  Plaid Link UIWebView
//
//  Created by Paolo Bernasconi.
//  Copyright (c) 2015 Plaid LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LinkViewController : UIViewController<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webview;
@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;

- (IBAction)exitButton:(id)sender;

@end
