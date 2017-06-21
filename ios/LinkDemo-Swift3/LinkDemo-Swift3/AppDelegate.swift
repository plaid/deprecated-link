//
//  AppDelegate.swift
//  LinkDemo-Swift3
//
//  Copyright © 2017 Plaid Technologies, Inc. All rights reserved.
//

import UIKit

import LinkKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func applicationDidFinishLaunching(_ application: UIApplication) {
        #if USE_CUSTOM_CONFIG
            setupPlaidWithCustomConfiguration()
        #else
            setupPlaidLinkWithSharedConfiguration()
        #endif
    }

    // MARK: Plaid Link setup with shared configuration from Info.plist
    func setupPlaidLinkWithSharedConfiguration() {
        // With shared configuration from Info.plist
        PLKPlaidLink.setup { (success, error) in
            if (success) {
                // Handle success here, e.g. by posting a notification
                NSLog("Plaid Link setup was successful")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PLDPlaidLinkSetupFinished"), object: self)
            }
            else {
                NSLog("Unable to setup Plaid Link due to: \(String(describing: error?.localizedDescription))")
            }
        }
    }


    // MARK: Plaid Link setup with custom configuration
    func setupPlaidWithCustomConfiguration() {
        // With custom configuration
        let linkConfiguration = PLKConfiguration(key: "<#YOUR_PLAID_PUBLIC_KEY#>", env: .development, product: .auth)
        linkConfiguration.clientName = "Link Demo"
        PLKPlaidLink.setup(with: linkConfiguration) { (success, error) in
            if (success) {
                // Handle success here, e.g. by posting a notification
                NSLog("Plaid Link setup was successful")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PLDPlaidLinkSetupFinished"), object: self)
            }
            else {
                NSLog("Unable to setup Plaid Link due to: \(String(describing: error?.localizedDescription))")
            }
        }
    }
}
