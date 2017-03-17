//
//  AppDelegate.swift
//  LinkDemo-Swift2
//
//  Copyright © 2017 Plaid Technologies, Inc. All rights reserved.
//

import UIKit

import LinkKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func applicationDidFinishLaunching(application: UIApplication) {
        #if USE_CUSTOM_CONFIG
            setupPlaidWithCustomConfiguration()
        #else
            setupPlaidLinkWithSharedConfiguration()
        #endif
    }

    // MARK: Plaid Link setup with shared configuration from Info.plist
    func setupPlaidLinkWithSharedConfiguration() {
        // With shared configuration from Info.plist
        PLKPlaidLink.setupWithSharedConfiguration { (success, error) in
            if (success) {
                // Handle success here, e.g. by posting a notification
                NSLog("Plaid Link setup was successful")
                NSNotificationCenter.defaultCenter().postNotificationName("PLDPlaidLinkSetupFinished", object: self)
            }
            else {
                NSLog("Unable to setup Plaid Link due to: \(error?.localizedDescription)")
            }
        }
    }


    // MARK: Plaid Link setup with custom configuration
    func setupPlaidWithCustomConfiguration() {
        // With custom configuration
        let linkConfiguration = PLKConfiguration(key: "<#YOUR_PLAID_PUBLIC_KEY#>", env: .Development, product: .Auth)
        linkConfiguration.clientName = "Link Demo"
        PLKPlaidLink.setupWithConfiguration(linkConfiguration) { (success, error) in
            if (success) {
                // Handle success here, e.g. by posting a notification
                NSLog("Plaid Link setup was successful")
                NSNotificationCenter.defaultCenter().postNotificationName("PLDPlaidLinkSetupFinished", object: self)
            }
            else {
                NSLog("Unable to setup Plaid Link due to: \(error?.localizedDescription)")
            }
        }
    }
}
