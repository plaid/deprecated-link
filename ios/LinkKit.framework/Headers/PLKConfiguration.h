//
//  PLKConfiguration.h
//  LinkKit
//
//  Copyright © 2016 Plaid Technologies, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PLKConstants.h"

NS_ASSUME_NONNULL_BEGIN

/**
 The Plaid API environment selects the Plaid servers with which LinkKit communicates.
 */
typedef NS_ENUM(NSInteger, PLKEnvironment) {
    /// For APIv2 development use.
    PLKEnvironmentDevelopment = 0,
 
    /// For APIv2 testing use.
    PLKEnvironmentSandbox,

    /// For APIv1 testing use.
    PLKEnvironmentTartan,
   
    /// For production use only (APIv1 and APIv2). @remark Requests are billed.
    PLKEnvironmentProduction,
};

/**
 The Plaid API version
 */
typedef NS_ENUM(NSInteger, PLKAPIVersion) {
    PLKAPIv1 = 0,
    PLKAPIv2,
    /// The latest version of the Plaid API; currently PLKAPIv2. *Note:* This may change with future releases.
    PLKAPILatest,
};
/// The default API version to use. *Note:* This may change with future releases
static PLKAPIVersion kPLKAPIVersionDefault = PLKAPIv2;

/// A Plaid public_key that can be used for testing when using PLKEnvironmentTartan.
PLK_EXTERN NSString* const kPLKTestKey;

/// A Plaid public_key that can be used for testing longtail when using PLKEnvironmentTartan.
PLK_EXTERN NSString* const kPLKTestKeyLongtailAuth;

// Keys customizing panes, see customizeWithDictionary:
/// This pane is shown at the end of an successful update flow.
PLK_EXTERN NSString* const kPLKConnectedPaneKey;

/// This pane is shown at the end of an successful update flow.
PLK_EXTERN NSString* const kPLKReconnectedPaneKey;

/// This pane is shown at the end of an successful update flow.
PLK_EXTERN NSString* const kPLKInstitutionSelectPaneKey;

/// This pane is shown at the end of an successful update flow.
PLK_EXTERN NSString* const kPLKInstitutionSearchPaneKey;

// Keys customizing UI elements in panes, see customizeWithDictionary:
/// The text shown as the navigation bar title.
PLK_EXTERN NSString* const kPLKCustomizationTitleKey;

/// The text shown upon successful (re)connection of an account.
PLK_EXTERN NSString* const kPLKCustomizationMessageKey;

/// The text shown on the submit button.
PLK_EXTERN NSString* const kPLKCustomizationSubmitButtonKey;

/// The text shown on the button on the bottom of the institution select view to show the institution search.
PLK_EXTERN NSString* const kPLKCustomizationSearchButtonKey;

/// The text shown when the institution search is activated.
PLK_EXTERN NSString* const kPLKCustomizationInitialMessageKey;

/// The text shown for empty search results.
PLK_EXTERN NSString* const kPLKCustomizationNoResultsMessageKey;

/// The text shown on the exit button for empty search results.
PLK_EXTERN NSString* const kPLKCustomizationExitButtonKey;


/**
 The PLKConfiguration class defines properties used when interacting with the Plaid API.
 */
@interface PLKConfiguration : NSObject

#pragma mark Required configuration properties
/// The public_key associated with your account. Available from https://dashboard.plaid.com/account/keys.
@property (readonly) NSString* key;

/// The Plaid API environment on which to create user accounts.
@property (readonly) PLKEnvironment env;

/**
 The Plaid requested products.

 @see PLKProduct
 */
@property (readonly) PLKProduct product;

/// Displayed once a user has successfully linked their account.
@property (copy,nonatomic) NSString* clientName;

#pragma mark Optional configuration properties
/**
 The webhook to receive notifications once a user's transactions have been processed and are ready for use.
 For details consult https://plaid.com/docs/api/#webhook.
 */
@property (copy,nonatomic) NSURL* webhook;

/// Whether support for longtailAuth institutions should be enabled.
@property (readonly) BOOL longtailAuth;

/// Whether the user should select a specific account to link
@property (readonly) BOOL selectAccount;

/// The Plaid API version to use.
@property (readonly) PLKAPIVersion apiVersion;


/**
 The singleton instance of the PLKConfiguration class initialized with the values
 from the PLKPlaidLinkConfiguration entry in the applications Info.plist.

 @return Returns the shared instance of the PLKConfiguration class
         or throws an exception if the provided values are invalid.
 @throws NSInvalidArgumentException
 */
+ (instancetype)sharedConfiguration;

PLK_EMPTY_INIT_UNAVAILABLE;

/**
 This is the designated initializer for this class,
 it initializes a PLKConfiguration object with the provided arguments.

 @param key The public_key associated with your account. Available from https://dashboard.plaid.com/account/keys.
 @param env The Plaid API environment on which to create user accounts
 @param product The Plaid products you wish to use.
 @param selectAccount The selectAccount parameter controls whether or not your Link integration uses the Select Account view.
                      This parameter will be removed in a future release, since it has been deprecated in favor of
                      the Select Account view customization available from the Dashboard https://dashboard.plaid.com/link/account-select.
 @param longtailAuth Enables support for longtailAuth institutions when set to YES.
 @param apiVersion Selects the Plaid API version to use.
 @return A PLKConfiguration object initialized with the given arguments.
 @throws NSInvalidArgumentException
 */
- (instancetype)initWithKey:(NSString*)key
                        env:(PLKEnvironment)env
                    product:(PLKProduct)product
              selectAccount:(BOOL)selectAccount // DEPRECATED
               longtailAuth:(BOOL)longtailAuth
                 apiVersion:(PLKAPIVersion)apiVersion NS_DESIGNATED_INITIALIZER;

/**
 Initializes a PLKConfiguration object with the provided arguments.

 @param key The public_key associated with your account. Available from https://dashboard.plaid.com/account/keys.
 @param env The Plaid API environment on which to create user accounts
 @param product The Plaid products you wish to use.
 @return A PLKConfiguration object initialized with the given arguments.
 @throws NSInvalidArgumentException
 */
- (instancetype)initWithKey:(NSString*)key
                        env:(PLKEnvironment)env
                    product:(PLKProduct)product;

/**
 Change the text of certain user interface elements.
 
 @param customizations The desired customizations, for details which elements can be customized
 on which panes please refer to the online documentation available at:
 https://github.com/plaid/link/blob/master/ios/README.md#customization
 */
- (void)customizeWithDictionary:(NSDictionary<NSString*,NSDictionary<NSString*,id>*>*)customizations;
@end

NS_ASSUME_NONNULL_END
