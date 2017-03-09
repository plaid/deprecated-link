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
    /// For development use.
    PLKEnvironmentDevelopment = 0,

    /// For testing use.
    PLKEnvironmentTesting,

    /// For production use only. @remark Requests are billed.
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

/// A Plaid public_key that can be used for testing when using PLKEnvironmentDevelopment or PLKEnvironmentTesting.
PLK_EXTERN NSString* const kPLKTestKey;

/// A Plaid public_key that can be used for testing longtail when using PLKEnvironmentDevelopment or PLKEnvironmentTesting.
PLK_EXTERN NSString* const kPLKTestKeyLongtailAuth;


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
 @param selectAccount When set to YES prompts the user to select an individual account once they've authenticated.
 @param longtailAuth Enables support for longtailAuth institutions when set to YES.
 @param apiVersion Selects the Plaid API version to use.
 @return A PLKConfiguration object initialized with the given arguments.
 @throws NSInvalidArgumentException
 */
- (instancetype)initWithKey:(NSString*)key
                        env:(PLKEnvironment)env
                    product:(PLKProduct)product
              selectAccount:(BOOL)selectAccount
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
@end

NS_ASSUME_NONNULL_END
