//
//  ViewController.m
//  LinkDemo-ObjC
//
//  Copyright © 2017 Plaid Technologies, Inc. All rights reserved.
//

// <!-- SMARTDOWN_IMPORT_LINKKIT -->
#import <LinkKit/LinkKit.h>
// <!-- SMARTDOWN_IMPORT_LINKKIT -->

#import "ViewController.h"

    
// <!-- SMARTDOWN_PROTOCOL -->
@interface ViewController (PLKPlaidLinkViewDelegate) <PLKPlaidLinkViewDelegate>
@end
// <!-- SMARTDOWN_PROTOCOL -->

@interface ViewController ()
@property IBOutlet UIButton* button;
@property IBOutlet UILabel* label;
@property IBOutlet UIView* buttonContainerView;
@end

@implementation ViewController

- (void)awakeFromNib {
    [super awakeFromNib];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveNotification:)
                                                 name:@"PLDPlaidLinkSetupFinished"
                                               object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.button.enabled = NO;

    NSBundle* linkKitBundle = [NSBundle bundleForClass:[PLKPlaidLinkViewController class]];
    NSString* linkName      = [linkKitBundle objectForInfoDictionaryKey:(NSString*)kCFBundleNameKey];
    self.label.text         = [NSString stringWithFormat:@"Objective-C — %@ %s+%.0f"
                                 , linkName, LinkKitVersionString, LinkKitVersionNumber];

    UIColor* shadowColor = [UIColor colorWithRed:3/255.0 green:49/255.0 blue:86/255.0 alpha:0.1];
    self.buttonContainerView.layer.shadowColor   = [shadowColor CGColor];
    self.buttonContainerView.layer.shadowOffset  = CGSizeMake(0, -1);
    self.buttonContainerView.layer.shadowRadius  = 2;
    self.buttonContainerView.layer.shadowOpacity = 1;
}

- (void)didReceiveNotification:(NSNotification*)notification {
    if ([@"PLDPlaidLinkSetupFinished" isEqualToString:notification.name]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:notification.name
                                                      object:self];
        self.button.enabled = YES;
    }
}

- (IBAction)didTapButton:(id)sender {
#if USE_CUSTOM_CONFIG
    [self presentPlaidLinkWithCustomConfiguration];
    // [self presentPlaidLinkWithCopyCustomization];
#else
    [self presentPlaidLinkWithSharedConfiguration];
#endif
}

- (void)handleSuccessWithToken:(NSString*)publicToken metadata:(NSDictionary<NSString*,id>*)metadata {
    NSString* message = [NSString stringWithFormat:@"token: %@\nmetadata: %@", publicToken, metadata];
    [self presentAlertViewWithTitle:@"Success" message:message];
}

- (void)handleError:(NSError*)error metadata:(NSDictionary<NSString*,id>*)metadata {
    NSString* message = [NSString stringWithFormat:@"error: %@\nmetadata: %@", [error localizedDescription], metadata];
    [self presentAlertViewWithTitle:@"Failure" message:message];
}

- (void)handleExitWithMetadata:(NSDictionary<NSString*,id>*)metadata {
    NSString* message = [NSString stringWithFormat:@"metadata: %@", metadata];
    [self presentAlertViewWithTitle:@"Exit" message:message];
}

- (void)presentAlertViewWithTitle:(NSString*)title message:(NSString*)message {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                            style:UIAlertActionStyleDefault
                                                          handler:nil];

    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark Start Plaid Link with shared configuration from Info.plist
- (void)presentPlaidLinkWithSharedConfiguration {

    // <!-- SMARTDOWN_PRESENT_SHARED -->
    // With shared configuration from Info.plist
    id<PLKPlaidLinkViewDelegate> linkViewDelegate  = self;
    PLKPlaidLinkViewController* linkViewController = [[PLKPlaidLinkViewController alloc] initWithDelegate:linkViewDelegate];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        linkViewController.modalPresentationStyle = UIModalPresentationFormSheet;
    }
    [self presentViewController:linkViewController animated:YES completion:nil];
    // <!-- SMARTDOWN_PRESENT_SHARED -->
    
}

#pragma mark Start Plaid Link with custom instance configuration
- (void)presentPlaidLinkWithCustomConfiguration {

    // <!-- SMARTDOWN_PRESENT_CUSTOM -->
    // With custom configuration
    PLKConfiguration* linkConfiguration;
    @try {
        linkConfiguration = [[PLKConfiguration alloc] initWithKey:@"<#YOUR_PLAID_PUBLIC_KEY#>" env:PLKEnvironmentSandbox product:PLKProductAuth];
        linkConfiguration.clientName = @"Link Demo";
        id<PLKPlaidLinkViewDelegate> linkViewDelegate  = self;
        PLKPlaidLinkViewController* linkViewController = [[PLKPlaidLinkViewController alloc] initWithConfiguration:linkConfiguration delegate:linkViewDelegate];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            linkViewController.modalPresentationStyle = UIModalPresentationFormSheet;
        }
        [self presentViewController:linkViewController animated:YES completion:nil];
    } @catch (NSException *exception) {
        NSLog(@"Invalid configuration: %@", exception);
    }
    // <!-- SMARTDOWN_PRESENT_CUSTOM -->

}

#pragma mark Start Plaid Link with custom instance configuration including client-side customizations
- (void)presentPlaidLinkWithCopyCustomization {
    PLKConfiguration* linkConfiguration;
    @try {
        linkConfiguration = [[PLKConfiguration alloc] initWithKey:@"<#YOUR_PLAID_PUBLIC_KEY#>" env:PLKEnvironmentSandbox product:PLKProductAuth];

        /*
         NOTE: The preferred method to customize LinkKit is to use the customization feature
         in the dashboard (https://dashboard.plaid.com/link).
         In the rare case where customization is necessary from within your application directly
         and you prefer to initialize link directly using instance configuration an example
         is given below.
         For further details which elements can be customized on which panes please refer to the online documentation available at:
         https://github.com/plaid/link/blob/master/ios/README.md#customization
         */
        // <!-- SMARTDOWN_CUSTOMIZATION -->
        [linkConfiguration customizeWithDictionary:@{
                                                     kPLKConnectedPaneKey: @{
                                                             kPLKCustomizationTitleKey: @"Sign-up successful",
                                                             kPLKCustomizationMessageKey: @"You successfully linked your account with <CLIENT>",
                                                             kPLKCustomizationSubmitButtonKey: @"Continue"
                                                             },
                                                     
                                                     kPLKReconnectedPaneKey: @{
                                                             kPLKCustomizationTitleKey: @"Update successful",
                                                             kPLKCustomizationMessageKey: @"You successfully updated your account credentials <CLIENT>",
                                                             kPLKCustomizationSubmitButtonKey: @"Continue"
                                                             },
                                                     
                                                     kPLKInstitutionSelectPaneKey: @{
                                                             kPLKCustomizationTitleKey: @"Choose your bank",
                                                             kPLKCustomizationSearchButtonKey: @"Search for your bank"
                                                             },
                                                     
                                                     kPLKInstitutionSearchPaneKey: @{
                                                             kPLKCustomizationExitButtonKey: @"Quit",
                                                             kPLKCustomizationInitialMessageKey: @"Find your bank or credit union",
                                                             kPLKCustomizationNoResultsMessageKey: @"Unfortunately the institution you searched for could not be found"
                                                             },
                                                     }];
        // <!-- SMARTDOWN_CUSTOMIZATION -->

        linkConfiguration.clientName = @"Link Demo";
        id<PLKPlaidLinkViewDelegate> linkViewDelegate  = self;
        PLKPlaidLinkViewController* linkViewController = [[PLKPlaidLinkViewController alloc] initWithConfiguration:linkConfiguration delegate:linkViewDelegate];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            linkViewController.modalPresentationStyle = UIModalPresentationFormSheet;
        }
        [self presentViewController:linkViewController animated:YES completion:nil];
    } @catch (NSException *exception) {
        NSLog(@"Invalid configuration: %@", exception);
    }
}

#pragma mark Start Plaid Link with an institution pre-selected
- (void)presentPlaidLinkWithCustomInitializer {

    // <!-- SMARTDOWN_CUSTOM_INITIALIZER -->
    id<PLKPlaidLinkViewDelegate> linkViewDelegate  = self;
    PLKPlaidLinkViewController* linkViewController = [[PLKPlaidLinkViewController alloc] initWithInstitution:@"<#INSTITUTION_ID#>" delegate:linkViewDelegate];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        linkViewController.modalPresentationStyle = UIModalPresentationFormSheet;
    }
    [self presentViewController:linkViewController animated:YES completion:nil];
    // <!-- SMARTDOWN_CUSTOM_INITIALIZER -->

}

#pragma mark Start Plaid Link in update mode
- (void)presentPlaidLinkInUpdateMode {

    // <!-- SMARTDOWN_UPDATE_MODE -->
    id<PLKPlaidLinkViewDelegate> linkViewDelegate  = self;
    PLKPlaidLinkViewController* linkViewController = [[PLKPlaidLinkViewController alloc] initWithPublicToken:@"<#GENERATED_PUBLIC_TOKEN#>" delegate:linkViewDelegate];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        linkViewController.modalPresentationStyle = UIModalPresentationFormSheet;
    }
    [self presentViewController:linkViewController animated:YES completion:nil];
    // <!-- SMARTDOWN_UPDATE_MODE -->

}

@end


@implementation ViewController (PLKPlaidLinkViewDelegate)

// <!-- SMARTDOWN_DELEGATE_SUCCESS -->
- (void)linkViewController:(PLKPlaidLinkViewController*)linkViewController
 didSucceedWithPublicToken:(NSString*)publicToken
                  metadata:(NSDictionary<NSString*,id>* _Nullable)metadata {
    [self dismissViewControllerAnimated:YES completion:^{
        // Handle success, e.g. by storing publicToken with your service
        NSLog(@"Successfully linked account!\npublicToken: %@\nmetadata: %@", publicToken, metadata);
        [self handleSuccessWithToken:publicToken metadata:metadata];
    }];
}
// <!-- SMARTDOWN_DELEGATE_SUCCESS -->

// <!-- SMARTDOWN_DELEGATE_EXIT -->
- (void)linkViewController:(PLKPlaidLinkViewController*)linkViewController
          didExitWithError:(NSError* _Nullable)error
                  metadata:(NSDictionary<NSString*,id>* _Nullable)metadata {
    [self dismissViewControllerAnimated:YES completion:^{
        if (error) {
            NSLog(@"Failed to link account due to: %@\nmetadata: %@", [error localizedDescription], metadata);
            [self handleError:error metadata:metadata];
        }
        else {
            NSLog(@"Plaid link exited with metadata: %@", metadata);
            [self handleExitWithMetadata:metadata];
        }
    }];
}
// <!-- SMARTDOWN_DELEGATE_EXIT -->

@end

