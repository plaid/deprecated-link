//
//  PLKPlaidLinkViewController.h
//  LinkKit
//
//  Copyright © 2016 Plaid Technologies, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PLKConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

/// The corresponding value contains the identifier for the account
PLK_EXTERN NSString* const kPLKMetadataIdKey;

/// The corresponding value contains the name of the account or institution.
PLK_EXTERN NSString* const kPLKMetadataNameKey;

/// The corresponding value contains the name of the account or institution.
PLK_EXTERN NSString* const kPLKMetadataAccountKey;

/// The corresponding value contains a NSDictionary with the accounts name and identifier.
PLK_EXTERN NSString* const kPLKMetadataAccountIdKey;

/// The corresponding value contains a NSDictionary with institution type and identifier.
PLK_EXTERN NSString* const kPLKMetadataInstitutionKey;

/// The corresponding value contains the institution type
PLK_EXTERN NSString* const kPLKMetadataInstitutionTypeKey;

/// The corresponding value indicates the point at which the user exited the Link flow.
PLK_EXTERN NSString* const kPLKMetadataStatusKey;

/// The corresponding value contains
PLK_EXTERN NSString* const kPLKMetadataRequestIdKey;

/// The corresponding value contains
PLK_EXTERN NSString* const kPLKMetadataPlaidApiRequestIdKey;

@protocol PLKPlaidLinkViewDelegate;

/**
 The PLKPlaidLinkViewController class implements a specialized view controller
 that manages the Plaid Link experience.
 */
@interface PLKPlaidLinkViewController : UINavigationController

/**
 The object that acts as the delegate of the Plaid Link view controller.
 
 The delegate must adopt the PLKPlaidLinkViewDelegate protocol. The delegate is not retained.
 */
@property (weak) id<PLKPlaidLinkViewDelegate> linkViewDelegate;

PLK_EMPTY_INIT_UNAVAILABLE;

/**
 Initializes and returns a newly created Plaid Link view controller using the shared configuration from Info.plist

 @param delegate A delegate object that wishes to receive messages from the inquiry object.
                 Delegate methods are listed under PLKPlaidLinkViewDelegate.
 @return The initialized Plaid Link view controller object or throws an exception if there was a problem initializing the object.
 */
- (instancetype)initWithDelegate:(id<PLKPlaidLinkViewDelegate>)delegate;


/**
 Initializes and returns a newly created Plaid Link view controller using the given custom configuration

 @param configuration A custom configuration object to use.
 @param delegate A delegate object that wishes to receive messages from the inquiry object.
                   Delegate methods are listed under PLKPlaidLinkViewDelegate.
 @return The initialized Plaid Link view controller object or throws an exception if there was a problem initializing the object.
 */
- (instancetype)initWithConfiguration:(PLKConfiguration*)configuration
                             delegate:(id<PLKPlaidLinkViewDelegate>)delegate;


/**
 Initializes and returns a newly created Plaid Link view controller with an institution pre-selected using
 the shared configuration.

 This will cause Link to open directly to the authentication step for the institution.

 @param identifier The Plaid identifier for a financial institution.
 @param delegate A delegate object that wishes to receive messages from the inquiry object.
                 Delegate methods are listed under PLKPlaidLinkViewDelegate.
 @return The initialized Plaid Link view controller object or throws an exception if there was a problem initializing the object.
 */
- (instancetype)initWithInstitution:(NSString*)identifier
                           delegate:(id<PLKPlaidLinkViewDelegate>)delegate;


/**
 Initializes and returns a newly created Plaid Link view controller with an institution pre-selected using
 the given custom configuration.

 This will cause Link to open directly to the authentication step for the institution.

 @param identifier The Plaid identifier for a financial institution.
 @param configuration A custom configuration object to use.
 @param delegate A delegate object that wishes to receive messages from the inquiry object.
                 Delegate methods are listed under PLKPlaidLinkViewDelegate.
 @return The initialized Plaid Link view controller object or throws an exception if there was a problem initializing the object.
 */
- (instancetype)initWithInstitution:(NSString*)identifier
                      configuration:(PLKConfiguration*)configuration
                           delegate:(id<PLKPlaidLinkViewDelegate>)delegate;


/**
 Initializes and returns a newly created Plaid Link view controller in update mode using
 the shared configuration.

 When a user changes their username, password, or MFA credentials with a financial institution
 or is locked out of their account, they must update their credentials with Plaid as well.
 Link's update mode makes this process secure and painless.
 To use update mode, initialize Link with the publicToken for the user you wish to update.

 This will cause Link to open directly to the authentication step for that user's institution.

 @param publicToken An existing user's public token to launch Link in update mode.
 @param delegate A delegate object that wishes to receive messages from the inquiry object.
                 Delegate methods are listed under PLKPlaidLinkViewDelegate.
 @return The initialized Plaid Link view controller object or throws an exception if there was a problem initializing the object.
 */
- (instancetype)initWithPublicToken:(NSString*)publicToken
                           delegate:(id<PLKPlaidLinkViewDelegate>)delegate;


/**
 Initializes and returns a newly created Plaid Link view controller in update mode using
 the given custom configuration.

 When a user changes their username, password, or MFA credentials with a financial institution
 or is locked out of their account, they must update their credentials with Plaid as well.
 Link's update mode makes this process secure and painless.
 To use update mode, initialize Link with the publicToken for the user you wish to update.

 This will cause Link to open directly to the authentication step for that user's institution.

 @param publicToken An existing user's public token to launch Link in update mode.
 @param configuration A custom configuration object to use.
 @param delegate A delegate object that wishes to receive messages from the inquiry object.
                 Delegate methods are listed under PLKPlaidLinkViewDelegate.
 @return The initialized Plaid Link view controller object or throws an exception if there was a problem initializing the object.
 */
- (instancetype)initWithPublicToken:(NSString*)publicToken
                      configuration:(PLKConfiguration*)configuration
                           delegate:(id<PLKPlaidLinkViewDelegate>)delegate;


@end

/**
 The delegate of a PLKPlaidLinkViewController object must adopt the PLKPlaidLinkViewDelegate
 protocol.
 */
@protocol PLKPlaidLinkViewDelegate <NSObject>

/**
 The method is called when a user has successfully onboarded their account.

 @param linkViewController A Plaid Link view controller object informing the delegate about the
                           successful authentication.
 @param publicToken The publicToken
 @param metadata A NSDictionary object containing information about the institution that the
                 user selected and the account if selectAccount was configured.
 */
- (void)linkViewController:(PLKPlaidLinkViewController*)linkViewController
 didSucceedWithPublicToken:(NSString*)publicToken
                  metadata:(NSDictionary<NSString*,id>* _Nullable)metadata;

/**
 The delegate method is called when a user has specifically exited the Link flow
 or an error occurred.

 @param linkViewController A Plaid Link view controller object informing the delegate that the
                           Link flow was exited
 @param error If an error occurred, contains an NSError object that describes the problem, nil otherwise.
 @param metadata A NSDictionary object containing information about the institution that the
                 user selected and the most recent API request IDs.
                 Storing this information can be helpful for support.
 */
- (void)linkViewController:(PLKPlaidLinkViewController*)linkViewController
          didExitWithError:(NSError* _Nullable)error
                  metadata:(NSDictionary<NSString*,id>* _Nullable)metadata;
@end

NS_ASSUME_NONNULL_END
