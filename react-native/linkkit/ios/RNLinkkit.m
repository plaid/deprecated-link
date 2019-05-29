//
//  RNLinkKit.m
//  RNLinkKit
//
//  Copyright © 2018 Plaid Inc. All rights reserved.
//

#import <React/RCTConvert.h>

#import <LinkKit/LinkKit.h>

#import "RNLinkkit.h"

static NSString* const kRLinkKitConfigPublicKeyKey = @"key";
static NSString* const kRLinkKitConfigEnvKey = @"env";
static NSString* const kRLinkKitConfigProductKey = @"product";
static NSString* const kRLinkKitConfigClientNameKey = @"clientName";
static NSString* const kRLinkKitConfigWebhookKey = @"webhook";
static NSString* const kRLinkKitConfigPublicTokenKey = @"publicToken";
static NSString* const kRLinkKitConfigSelectAccountKey = @"selectAccount";
static NSString* const kRLinkKitConfigUserLegalNameKey = @"userLegalName";
static NSString* const kRLinkKitConfigUserEmailAddressKey = @"userEmailAddress";
static NSString* const kRLinkKitConfigCountryCodesKey = @"countryCodes";
static NSString* const kRLinkKitConfigLanguageKey = @"language";
static NSString* const kRLinkKitConfigInstitutionKey = @"institution";
static NSString* const kRLinkKitConfigLongtailAuthKey = @"longtailAuth";
static NSString* const kRLinkKitConfigApiVersionKey = @"apiVersion";

static NSString* const kRLinkKitOnSuccessEvent = @"onSuccess";
static NSString* const kRLinkKitOnExitEvent = @"onExit";
static NSString* const kRLinkKitOnEventEvent = @"onEvent";
static NSString* const kRLinkKitEventTokenKey = @"publicToken";
static NSString* const kRLinkKitEventErrorKey = @"error";
static NSString* const kRLinkKitEventNameKey = @"event";
static NSString* const kRLinkKitEventMetadataKey = @"metadata";
static NSString* const kRLinkKitVersionConstant = @"version";


@interface RNLinkkitDelegate : NSObject <PLKPlaidLinkViewDelegate>
@property (copy) void(^onSuccess)(NSString* publicToken, NSDictionary<NSString*,id>*metadata);
@property (copy) void(^onExit)(NSError* error, NSDictionary<NSString*,id>*metadata);
@property (copy) void(^onEvent)(NSString* event, NSDictionary<NSString*,id>*metadata);
@end

@interface RNLinkkit()
@property PLKPlaidLinkViewController* linkViewController;
@property RNLinkkitDelegate* linkViewDelegate;
@end

@implementation RNLinkkit

RCT_EXPORT_MODULE();

+ (BOOL)requiresMainQueueSetup {
    return YES;
}

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

- (NSArray<NSString *> *)supportedEvents {
    return @[kRLinkKitOnSuccessEvent, kRLinkKitOnExitEvent, kRLinkKitOnEventEvent];
}

RCT_EXPORT_METHOD(_create:(NSDictionary*)configuration) {
    // Configuration
    NSString *key = [RCTConvert NSString:configuration[kRLinkKitConfigPublicKeyKey]];
    NSString *env = [RCTConvert NSString:configuration[kRLinkKitConfigEnvKey]];
    NSArray<NSString*> *products = [RCTConvert NSStringArray:configuration[kRLinkKitConfigProductKey]];
    NSString *clientName = [RCTConvert NSString:configuration[kRLinkKitConfigClientNameKey]];
    NSString *webhook = [RCTConvert NSString:configuration[kRLinkKitConfigWebhookKey]];
    NSString *publicToken = [RCTConvert NSString:configuration[kRLinkKitConfigPublicTokenKey]];
    NSString *userLegalName = [RCTConvert NSString:configuration[kRLinkKitConfigUserLegalNameKey]];
    NSString *userEmailAddress = [RCTConvert NSString:configuration[kRLinkKitConfigUserEmailAddressKey]];
    NSArray<NSString*> *countryCodes = [RCTConvert NSStringArray:configuration[kRLinkKitConfigCountryCodesKey]];
    NSString *language = [RCTConvert NSString:configuration[kRLinkKitConfigLanguageKey]];
    BOOL selectAccount = [RCTConvert BOOL:configuration[kRLinkKitConfigSelectAccountKey]];

    NSString *institution = [RCTConvert NSString:configuration[kRLinkKitConfigInstitutionKey]];
    BOOL longtailAuth = [RCTConvert BOOL:configuration[kRLinkKitConfigLongtailAuthKey]];
    NSString *version = [RCTConvert NSString:configuration[kRLinkKitConfigApiVersionKey]];

    UIViewController *controller = RCTPresentedViewController();

    PLKEnvironment environment = PLKEnvironmentFromString(env);
    PLKProduct product = PLKProductFromArray(products);
    PLKAPIVersion apiVersion = (version) ? PLKAPIVersionFromString(version) : kPLKAPIVersionDefault;
    PLKConfiguration* linkConfiguration = [[PLKConfiguration alloc] initWithKey:key
                                                                            env:environment
                                                                        product:product
                                                                  selectAccount:selectAccount
                                                                   longtailAuth:longtailAuth
                                                                     apiVersion:apiVersion];
    if ([clientName length] > 0) {
        linkConfiguration.clientName = clientName;
    }
    if ([webhook length] > 0) {
        linkConfiguration.webhook = [NSURL URLWithString:webhook];
    }
    if ([userLegalName length] > 0) {
        linkConfiguration.userLegalName = userLegalName;
    }
    if ([userEmailAddress length] > 0) {
        linkConfiguration.userEmailAddress = userEmailAddress;
    }
    if ([countryCodes count] > 0) {
        linkConfiguration.countryCodes = countryCodes;
    }
    if ([language length] > 0) {
        linkConfiguration.language = language;
    }

    // Link Delegate
    __weak typeof(self) weakSelf = self;
    self.linkViewDelegate = [[RNLinkkitDelegate alloc] init];
    self.linkViewDelegate.onSuccess = ^(NSString* publicToken, NSDictionary<NSString*,id>*metadata) {
        [controller dismissViewControllerAnimated:YES completion:nil];
        [weakSelf sendEventWithName:kRLinkKitOnSuccessEvent body:@{kRLinkKitEventTokenKey: publicToken, kRLinkKitEventMetadataKey: metadata}];
    };
    self.linkViewDelegate.onExit = ^(NSError* error, NSDictionary<NSString*,id>*metadata) {
        [controller dismissViewControllerAnimated:YES completion:nil];
        [weakSelf sendEventWithName:kRLinkKitOnExitEvent body:@{kRLinkKitEventErrorKey: RCTNullIfNil(error.localizedFailureReason), kRLinkKitEventMetadataKey: metadata}];
    };
    self.linkViewDelegate.onEvent = ^(NSString* event, NSDictionary<NSString*,id>*metadata) {
        [weakSelf sendEventWithName:kRLinkKitOnEventEvent body:@{kRLinkKitEventNameKey: event, kRLinkKitEventMetadataKey: metadata}];
    };

    // Link ViewController
    if ([publicToken length] > 0) {
        self.linkViewController = [[PLKPlaidLinkViewController alloc] initWithPublicToken:publicToken
                                                                            configuration:linkConfiguration
                                                                                 delegate:self.linkViewDelegate];
    }
    else if ([institution length] > 0) {
        self.linkViewController = [[PLKPlaidLinkViewController alloc] initWithInstitution:institution
                                                                       configuration:linkConfiguration
                                                                            delegate:self.linkViewDelegate];
    }
    else {
        self.linkViewController = [[PLKPlaidLinkViewController alloc] initWithConfiguration:linkConfiguration
                                                                              delegate:self.linkViewDelegate];
    }
}

RCT_EXPORT_METHOD(_open) {
    if (self.linkViewController) {
        [RCTPresentedViewController() presentViewController:self.linkViewController animated:YES completion:nil];
    }
}

- (NSDictionary *)constantsToExport {
    return @{
             kRLinkKitVersionConstant: [NSString stringWithFormat:@"%s+%.0f", LinkKitVersionString, LinkKitVersionNumber],
             };
}

@end

#pragma mark - PLKPlaidLinkViewDelegate
@implementation RNLinkkitDelegate

- (void)linkViewController:(PLKPlaidLinkViewController*)linkViewController
 didSucceedWithPublicToken:(NSString*)publicToken
                  metadata:(NSDictionary<NSString*,id>*)metadata {
    if (self.onSuccess) {
        self.onSuccess(publicToken, metadata);
    }
}

- (void)linkViewController:(PLKPlaidLinkViewController*)linkViewController
          didExitWithError:(NSError*)error
                  metadata:(NSDictionary<NSString*,id>*)metadata {
    if (self.onExit) {
        self.onExit(error, metadata);
    }
}

- (void)linkViewController:(PLKPlaidLinkViewController*)linkViewController
            didHandleEvent:(NSString*)event
                  metadata:(NSDictionary<NSString*,id>*)metadata {
    if (self.onEvent) {
        self.onEvent(event, metadata);
    }
}

@end
  
