//
//  ViewController.swift
//  LinkDemo-Swift
//
//  Copyright © 2017 Plaid Technologies, Inc. All rights reserved.
//

import UIKit

// <!-- SMARTDOWN_IMPORT_LINKKIT -->
import LinkKit
// <!-- SMARTDOWN_IMPORT_LINKKIT -->

class ViewController: UIViewController {

    @IBOutlet var button: UIButton!
    @IBOutlet var label: UILabel!
    @IBOutlet var buttonContainerView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.didReceiveNotification(_:)), name: NSNotification.Name(rawValue: "PLDPlaidLinkSetupFinished"), object: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        button.isEnabled = false
        let linkKitBundle  = Bundle(for: PLKPlaidLinkViewController.self)
        let linkKitVersion = linkKitBundle.object(forInfoDictionaryKey: "CFBundleShortVersionString")!
        let linkKitBuild   = linkKitBundle.object(forInfoDictionaryKey: kCFBundleVersionKey as String)!
        let linkKitName    = linkKitBundle.object(forInfoDictionaryKey: kCFBundleNameKey as String)!
        label.text         = "Swift — \(linkKitName) \(linkKitVersion)+\(linkKitBuild)"

        let shadowColor = UIColor(colorLiteralRed: 3/255.0, green: 49/255.0, blue: 86/255.0, alpha: 0.1)
        buttonContainerView.layer.shadowColor   = shadowColor.cgColor
        buttonContainerView.layer.shadowOffset  = CGSize(width: 0, height: -1)
        buttonContainerView.layer.shadowRadius  = 2
        buttonContainerView.layer.shadowOpacity = 1
    }

    func didReceiveNotification(_ notification: NSNotification) {
        if notification.name.rawValue == "PLDPlaidLinkSetupFinished" {
            NotificationCenter.default.removeObserver(self, name: notification.name, object: nil)
            button.isEnabled = true
        }
    }

    @IBAction func didTapButton(_ sender: Any?) {
#if USE_CUSTOM_CONFIG
        presentPlaidLinkWithCustomConfiguration()
#else
        presentPlaidLinkWithSharedConfiguration()
#endif
    }

    func handleSuccessWithToken(_ publicToken: String, metadata: [String : Any]?) {
        presentAlertViewWithTitle("Success", message: "token: \(publicToken)\nmetadata: \(metadata ?? [:])")
    }

    func handleError(_ error: Error, metadata: [String : Any]?) {
        presentAlertViewWithTitle("Failure", message: "error: \(error.localizedDescription)\nmetadata: \(metadata ?? [:])")
    }
    
    func handleExitWithMetadata(_ metadata: [String : Any]?) {
        presentAlertViewWithTitle("Exit", message: "metadata: \(metadata ?? [:])")
    }
    
    func presentAlertViewWithTitle(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    // MARK: Plaid Link setup with shared configuration from Info.plist
    func presentPlaidLinkWithSharedConfiguration() {
        // <!-- SMARTDOWN_PRESENT_SHARED -->
        // With shared configuration from Info.plist
        let linkViewDelegate = self
        let linkViewController = PLKPlaidLinkViewController(delegate: linkViewDelegate)
        if (UI_USER_INTERFACE_IDIOM() == .pad) {
            linkViewController.modalPresentationStyle = .formSheet;
        }
        present(linkViewController, animated: true)
        // <!-- SMARTDOWN_PRESENT_SHARED -->
    }

    // MARK: Plaid Link setup with custom configuration
    func presentPlaidLinkWithCustomConfiguration() {
        // <!-- SMARTDOWN_PRESENT_CUSTOM -->
        // With custom configuration
        let linkConfiguration = PLKConfiguration(key: "<#YOUR_PLAID_PUBLIC_KEY#>", env: .sandbox, product: .auth)
        linkConfiguration.clientName = "Link Demo"
        let linkViewDelegate = self
        let linkViewController = PLKPlaidLinkViewController(configuration: linkConfiguration, delegate: linkViewDelegate)
        if (UI_USER_INTERFACE_IDIOM() == .pad) {
            linkViewController.modalPresentationStyle = .formSheet;
        }
        present(linkViewController, animated: true)
        // <!-- SMARTDOWN_PRESENT_CUSTOM -->
    }

    // MARK: Start Plaid Link with an institution pre-selected
    func presentPlaidLinkWithCustomInitializer() {
        // <!-- SMARTDOWN_CUSTOM_INITIALIZER -->
        let linkViewDelegate = self
        let linkViewController = PLKPlaidLinkViewController(institution: "<#INSTITUTION_ID#>", delegate: linkViewDelegate)
        if (UI_USER_INTERFACE_IDIOM() == .pad) {
            linkViewController.modalPresentationStyle = .formSheet;
        }
        present(linkViewController, animated: true)
        // <!-- SMARTDOWN_CUSTOM_INITIALIZER -->
    }

    // MARK: Start Plaid Link in update mode
    func presentPlaidLinkInUpdateMode() {
        // <!-- SMARTDOWN_UPDATE_MODE -->
        let linkViewDelegate = self
        let linkViewController = PLKPlaidLinkViewController(publicToken: "<#GENERATED_PUBLIC_TOKEN#>", delegate: linkViewDelegate)
        if (UI_USER_INTERFACE_IDIOM() == .pad) {
            linkViewController.modalPresentationStyle = .formSheet;
        }
        present(linkViewController, animated: true)
        // <!-- SMARTDOWN_UPDATE_MODE -->
    }
}

// MARK: - PLKPlaidLinkViewDelegate Protocol
// <!-- SMARTDOWN_PROTOCOL -->
extension ViewController : PLKPlaidLinkViewDelegate
// <!-- SMARTDOWN_PROTOCOL -->
{

// <!-- SMARTDOWN_DELEGATE_SUCCESS -->
    func linkViewController(_ linkViewController: PLKPlaidLinkViewController, didSucceedWithPublicToken publicToken: String, metadata: [String : Any]?) {
        dismiss(animated: true) {
            // Handle success, e.g. by storing publicToken with your service
            NSLog("Successfully linked account!\npublicToken: \(publicToken)\nmetadata: \(metadata ?? [:])")
            self.handleSuccessWithToken(publicToken, metadata: metadata)
        }
    }
// <!-- SMARTDOWN_DELEGATE_SUCCESS -->

// <!-- SMARTDOWN_DELEGATE_EXIT -->
    func linkViewController(_ linkViewController: PLKPlaidLinkViewController, didExitWithError error: Error?, metadata: [String : Any]?) {
        dismiss(animated: true) {
            if let error = error {
                NSLog("Failed to link account due to: \(error.localizedDescription)\nmetadata: \(metadata ?? [:])")
                self.handleError(error, metadata: metadata)
            }
            else {
                NSLog("Plaid link exited with metadata: \(metadata ?? [:])")
                self.handleExitWithMetadata(metadata)
            }
        }
    }
// <!-- SMARTDOWN_DELEGATE_EXIT -->
}
