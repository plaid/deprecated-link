//
//  RNLinkKit.h
//  RNLinkKit
//
//  Copyright © 2018 Plaid Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#if __has_include("RCTBridgeModule.h")
#import "RCTEventEmitter.h"
#else
#import <React/RCTEventEmitter.h>
#endif

@interface RNLinkkit : RCTEventEmitter

@end
  
