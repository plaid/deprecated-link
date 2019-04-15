//
//  PLKPlaidLinkViewController.h
//  LinkKit
//
//  Copyright © 2016 Plaid Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PLKConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

/// The corresponding value contains the identifier for the account.
PLK_EXTERN NSString* const kPLKMetadataIdKey;

/// The corresponding value contains the name of the account or institution.
PLK_EXTERN NSString* const kPLKMetadataNameKey;

/// The corresponding value contains the masked account number.
PLK_EXTERN NSString* const kPLKMetadataMaskKey;

/// The corresponding value contains the type of the account or institution.
PLK_EXTERN NSString* const kPLKMetadataTypeKey;

/// The corresponding value contains the subtype of the account.
PLK_EXTERN NSString* const kPLKMetadataSubtypeKey;

/// The corresponding value contains a NSDictionary with an account's name, identifier, mask, type, and subtype.
PLK_EXTERN NSString* const kPLKMetadataAccountKey;

/// The corresponding value contains an NSArray with multiple NSDictionary for the selected accounts; the keys in the NSDictionary are the same as with the kPLKMetadataAccountKey.
PLK_EXTERN NSString* const kPLKMetadataAccountsKey;

/// The corresponding value contains the identifier for the account.
PLK_EXTERN NSString* const kPLKMetadataAccountIdKey;

/// The corresponding value contains the verification status of the account when using micro-deposit based verification.
PLK_EXTERN NSString* const kPLKMetadataAccountVerificationStatusKey;

/// The value indicates that the account is pending manual verification via micro-deposits.
PLK_EXTERN NSString* const kPLKMetadataAccountVerificationStatusPendingManualVerification;

/// The value indicates that the account is pending automatic verification via micro-deposits.
PLK_EXTERN NSString* const kPLKMetadataAccountVerificationStatusPendingAutomaticVerification;

/// The value indicates that the account has been verified using manual verification via micro-deposits.
PLK_EXTERN NSString* const kPLKMetadataAccountVerificationStatusManuallyVerified;

/// The value indicates that the account has been verified using automatic verification via micro-deposits.
PLK_EXTERN NSString* const kPLKMetadataAccountVerificationStatusAutomaticallyVerified;

/// The corresponding value contains a NSDictionary with the name and identifier of the institution.
PLK_EXTERN NSString* const kPLKMetadataInstitutionKey;

/// The corresponding value contains the identifier for the institution.
PLK_EXTERN NSString* const kPLKMetadataInstitutionIdKey;

/// The corresponding value contains the name of the institution.
PLK_EXTERN NSString* const kPLKMetadataInstitutionNameKey;

/// The corresponding value contains the institution type when using the legacy API.
PLK_EXTERN NSString* const kPLKAPIv1MetadataInstitutionTypeKey DEPRECATED_MSG_ATTRIBUTE("the legacy API is no longer supported. Use APIv2 and kPLKMetadataStatusKey instead");

/// The corresponding value contains the institution type.
PLK_EXTERN NSString* const kPLKMetadataInstitution_TypeKey DEPRECATED_MSG_ATTRIBUTE("use kPLKAPIv1MetadataInstitutionTypeKey instead.");

/// The corresponding value contains the institution type.
PLK_EXTERN NSString* const kPLKMetadataInstitutionTypeKey DEPRECATED_MSG_ATTRIBUTE("use kPLKMetadataTypeKey instead.");

/// The corresponding value indicates the point at which the user exited the Link flow.
PLK_EXTERN NSString* const kPLKMetadataStatusKey;

/// The corresponding value contains a unique APIv2 request ID, which can be shared with Plaid Support to expedite investigation.
PLK_EXTERN NSString* const kPLKMetadataRequestIdKey;

/// The corresponding value contains a unique Link legacy API request ID, which can be shared with Plaid Support to expedite investigation.
PLK_EXTERN NSString* const kPLKMetadataLinkRequestIdKey  DEPRECATED_MSG_ATTRIBUTE("the legacy API is no longer supported. Use APIv2 and kPLKMetadataRequestIdKey instead");

/// The corresponding value contains a unique Plaid legacy API request ID, which can be shared with Plaid Support to expedite investigation.
PLK_EXTERN NSString* const kPLKMetadataPlaidApiRequestIdKey  DEPRECATED_MSG_ATTRIBUTE("the legacy API is no longer supported. Use APIv2 and kPLKMetadataRequestIdKey instead");

/// The corresponding value represents a unique and omnipresent identifier for all actions and events throughout a user's session in Link.
PLK_EXTERN NSString* const kPLKMetadataLinkSessionIdKey;

/// The corresponding value is the error type that the user encountered. See online documentation for details https://www.plaid.com/docs/api/#errors.
PLK_EXTERN NSString* const kPLKMetadataErrorTypeKey;

/// The corresponding value is the error code that the user encountered. See online documentation for details https://www.plaid.com/docs/api/#errors.
PLK_EXTERN NSString* const kPLKMetadataErrorCodeKey;

/// The corresponding value is the error message that the user encountered. See online documentation for details https://www.plaid.com/docs/api/#errors.
PLK_EXTERN NSString* const kPLKMetadataErrorMessageKey;

/// The corresponding value is the query used to search for institutions.
PLK_EXTERN NSString* const kPLKMetadataInstitutionSearchQueryKey;

/// The corresponding value indicates the type of MFA the user has encountered.
PLK_EXTERN NSString* const kPLKMetadataMFATypeKey;

/// The corresponding value is the name of the view on TRANSITION_VIEW events.
PLK_EXTERN NSString* const kPLKMetadataViewNameKey;

/// The corresponding value is a ISO 8601 formatted string representing the time when the event occurred.
PLK_EXTERN NSString* const kPLKMetadataTimestampKey;

/// The corresponding value indicates the point at which the user exited the Link flow.
PLK_EXTERN NSString* const kPLKMetadataExitStatusKey;


/// The corresponding value is a broad categorization of the error.
PLK_EXTERN NSString* const kPLKErrorTypeKey;

/// The corresponding value represents a particular error code.
PLK_EXTERN NSString* const kPLKErrorCodeKey;

/// The corresponding value is a developer-friendly representation of the error code.
PLK_EXTERN NSString* const kPLKErrorMessageKey;

/// The corresponding value is a user-friendly representation of the error code or [NSNull null] if the error is not related to user action.
PLK_EXTERN NSString* const kPLKDisplayMessageKey;


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

 Note: The methods of this protocol are dispatched to the main queue.
 */
@protocol PLKPlaidLinkViewDelegate <NSObject>

/**
 The method is called when a user has successfully onboarded their account.

 Note: The method is dispatched to the main queue.

 @param linkViewController A Plaid Link view controller object informing the delegate about the
                           successful authentication.
 @param publicToken A NSString to send to your app server or use for update mode.
 @param metadata A NSDictionary object containing information about the institution that the
                 user selected and the account if selectAccount was configured.
 */
- (void)linkViewController:(PLKPlaidLinkViewController*)linkViewController
 didSucceedWithPublicToken:(NSString*)publicToken
                  metadata:(NSDictionary<NSString*,id>* _Nullable)metadata;

/**
 The delegate method is called when a user has specifically exited the Link flow
 or an error occurred.

 Note: The method is dispatched to the main queue.

 @param linkViewController A Plaid Link view controller object informing the delegate that the
                           Link flow was exited
 @param error If an error occurred, contains an NSError object that describes the problem, nil otherwise.
              The error's userInfo contains entries according to https://plaid.com/docs/api/#errors unless the legacy API is used.
 @param metadata A NSDictionary object containing information about the institution that the
                 user selected and the most recent API request IDs.
                 Storing this information can be helpful for support.
 */
- (void)linkViewController:(PLKPlaidLinkViewController*)linkViewController
          didExitWithError:(NSError* _Nullable)error
                  metadata:(NSDictionary<NSString*,id>* _Nullable)metadata;

@optional
/**
 The delegate method is called when certain events in the Link flow have occurred.
 For details about the events see the onEvent documentation:
 https://plaid.com/docs/api/#onevent-callback

 Note: The method is dispatched to the main queue.

 @param linkViewController A Plaid Link view controller object informing the delegate a certain
                           event in the Link flow has occurred.
 @param event A NSString indicating the type of Link flow event that occurred.
 @param metadata A NSDictionary object containing information about the event.
 */
- (void)linkViewController:(PLKPlaidLinkViewController*)linkViewController
            didHandleEvent:(NSString*)event
                  metadata:(NSDictionary<NSString*,id>* _Nullable)metadata;
@end

NS_ASSUME_NONNULL_END
