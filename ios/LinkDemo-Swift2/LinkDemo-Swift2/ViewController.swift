//
//  ViewController.swift
//  LinkDemo-Swift2
//
//  Copyright © 2017 Plaid Technologies, Inc. All rights reserved.
//

import UIKit

import LinkKit

class ViewController: UIViewController {

    @IBOutlet var button: UIButton!
    @IBOutlet var label: UILabel!
    @IBOutlet var buttonContainerView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.didReceiveNotification(_:)), name: "PLDPlaidLinkSetupFinished", object: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        button.enabled = false
        let linkKitBundle  = NSBundle(forClass: PLKPlaidLinkViewController.self)
        let linkKitVersion = linkKitBundle.objectForInfoDictionaryKey("CFBundleShortVersionString")!
        let linkKitBuild   = linkKitBundle.objectForInfoDictionaryKey(kCFBundleVersionKey as String)!
        let linkKitName    = linkKitBundle.objectForInfoDictionaryKey(kCFBundleNameKey as String)!
        label.text         = "Swift 2 — \(linkKitName): \(linkKitVersion)+\(linkKitBuild)"

        let shadowColor    = UIColor(colorLiteralRed: 3/255.0, green: 49/255.0, blue: 86/255.0, alpha: 0.1)
        buttonContainerView.layer.shadowColor   = shadowColor.CGColor
        buttonContainerView.layer.shadowOffset  = CGSize(width: 0, height: -1)
        buttonContainerView.layer.shadowRadius  = 2
        buttonContainerView.layer.shadowOpacity = 1

    }

    func didReceiveNotification(notification: NSNotification) {
        if notification.name == "PLDPlaidLinkSetupFinished" {
            NSNotificationCenter.defaultCenter().removeObserver(self, name: notification.name, object: nil)
            button.enabled = true
        }
    }

    @IBAction func didTapButtonWithSender(_: AnyObject?) {
#if USE_CUSTOM_CONFIG
            presentPlaidLinkWithCustomConfiguration()
#else
            presentPlaidLinkWithSharedConfiguration()
#endif
    }

    func handleSuccessWithToken(publicToken: String, metadata: [String : AnyObject]?) {
        presentAlertViewWithTitle("Success", message: "token: \(publicToken)\nmetadata: \(metadata)")
    }

    func handleError(error: NSError, metadata: [String : AnyObject]?) {
        presentAlertViewWithTitle("Failure", message: "error: \(error.localizedDescription)\nmetadata: \(metadata)")
    }

    func handleExitWithMetadata(metadata: [String : AnyObject]?) {
        presentAlertViewWithTitle("Exit", message: "metadata: \(metadata)")
    }

    func presentAlertViewWithTitle(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }

    // MARK: Plaid Link setup with shared configuration from Info.plist
    func presentPlaidLinkWithSharedConfiguration() {
        // With shared configuration from Info.plist
        let linkViewDelegate = self
        let linkViewController = PLKPlaidLinkViewController(delegate: linkViewDelegate)
        if (UI_USER_INTERFACE_IDIOM() == .Pad) {
            linkViewController.modalPresentationStyle = .FormSheet
        }
        presentViewController(linkViewController, animated: true, completion: nil)
    }

    // MARK: Plaid Link setup with custom configuration
    func presentPlaidLinkWithCustomConfiguration() {
        // With custom configuration
        let linkConfiguration = PLKConfiguration(key: "<#YOUR_PLAID_PUBLIC_KEY#>", env: .Sandbox, product: .Auth)
        linkConfiguration.clientName = "Link Demo"
        let linkViewDelegate = self
        let linkViewController = PLKPlaidLinkViewController(configuration: linkConfiguration, delegate: linkViewDelegate)
        if (UI_USER_INTERFACE_IDIOM() == .Pad) {
            linkViewController.modalPresentationStyle = .FormSheet
        }
        presentViewController(linkViewController, animated: true, completion: nil)
    }

    // MARK: Start Plaid Link with an institution pre-selected
    func presentPlaidLinkWithCustomInitializer() {
        let linkViewDelegate = self
        let linkViewController = PLKPlaidLinkViewController(institution: "<#INSTITUTION_ID#>", delegate: linkViewDelegate)
        if (UI_USER_INTERFACE_IDIOM() == .Pad) {
            linkViewController.modalPresentationStyle = .FormSheet;
        }
        presentViewController(linkViewController, animated: true, completion: nil)
    }

    // MARK: Start Plaid Link in update mode
    func presentPlaidLinkInUpdateMode() {
        let linkViewDelegate = self
        let linkViewController = PLKPlaidLinkViewController(publicToken: "<#GENERATED_PUBLIC_TOKEN#>", delegate: linkViewDelegate)
        if (UI_USER_INTERFACE_IDIOM() == .Pad) {
            linkViewController.modalPresentationStyle = .FormSheet
        }
        presentViewController(linkViewController, animated: true, completion: nil)
    }
}

// MARK: - PLKPlaidLinkViewDelegate Protocol
extension ViewController : PLKPlaidLinkViewDelegate
{
    func linkViewController(linkViewController: PLKPlaidLinkViewController, didSucceedWithPublicToken publicToken: String, metadata: [String : AnyObject]?) {
        dismissViewControllerAnimated(true) {
        // Handle success, e.g. by storing publicToken with your service
            NSLog("Successfully linked account!\npublicToken: \(publicToken)\nmetadata: \(metadata)")
            self.handleSuccessWithToken(publicToken, metadata: metadata)
        }
    }

    func linkViewController(linkViewController: PLKPlaidLinkViewController, didExitWithError error: NSError?, metadata: [String : AnyObject]?) {
        dismissViewControllerAnimated(true) {
            if let error = error {
                NSLog("Failed to link account due to: \(error.localizedDescription)\nmetadata: \(metadata)")
                self.handleError(error, metadata: metadata)
            }
            else {
                NSLog("Plaid link exited with metadata: \(metadata)")
                self.handleExitWithMetadata(metadata)
            }
        }
    }
}

