//
//  PLKConstants.h
//  LinkKit
//
//  Copyright © 2016 Plaid Technologies, Inc. All rights reserved.
//

#ifndef PLKConstants_h
#define PLKConstants_h

#import <Foundation/Foundation.h>

#define PLK_EXTERN FOUNDATION_EXTERN
#define PLK_NOT_DESIGNATED_INITIALIZER __attribute__((unavailable("Not the designated initializer")))
#define PLK_EMPTY_INIT_UNAVAILABLE \
    +(instancetype)new PLK_NOT_DESIGNATED_INITIALIZER; \
    -(instancetype)init PLK_NOT_DESIGNATED_INITIALIZER;

/**
 Options for specifying the Plaid products to use.
 
 For details about the products visit https://plaid.com/products/.
 */
typedef NS_OPTIONS(NSInteger, PLKProduct) {
    /// Verify accounts for payments without micro-deposits.
    PLKProductAuth         = 1 << 0,

    /// Validate income and verify employer info more accurately.
    PLKProductIncome       = 1 << 1,

    /// Account and transaction data to better serve users.
    PLKProductConnect      = 1 << 2,
    /// APIv2 equivalent of PLKProductConnect.
    PLKProductTransactions = 1 << 2,

    /// Verify user identities with bank account data to reduce fraud.
    PLKProductInfo         = 1 << 3,
    /// APIv2 equivalent of PLKProductInfo
    PLKProductIdentity     = 1 << 3,

    /// For internal use only.
    PLKProductLongtailAuth = 1 << 4
};


/// User completed the Link flow.
PLK_EXTERN NSString* const kPLKStatusConnected;

/// User was prompted to answer security question(s).
PLK_EXTERN NSString* const kPLKStatusRequiresQuestions;

/// User was prompted to answer multiple choice question(s)
PLK_EXTERN NSString* const kPLKStatusRequiresSelections;

/// User was prompted to provide a one time passcode.
PLK_EXTERN NSString* const kPLKStatusRequiresCode;

/// User was prompted to select a device at which to receive a one-time passcode.
PLK_EXTERN NSString* const kPLKStatusChooseDevice;

/// User was prompted to provide credentials for the selected financial institution or has not yet selected a financial institution.
PLK_EXTERN NSString* const kPLKStatusRequiresCredentials;

/// User was prompted to verify they are human via reCAPTCHA.
PLK_EXTERN NSString* const kPLKStatusRequiresRecaptcha;

#endif /* PLKConstants_h */
