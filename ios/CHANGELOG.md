# CHANGELOG

## 2019-03-15 — LinkKit 1.1.17
### Added
- Add new optional configuration property `countryCodes` to limit selectable institutions and institution search results to institutions available in the given countries

### Changed
- Fix issue with automated microdeposits, which were only enabled when the configured product was `auth`
- Fix issue where institutions were displayed on the institutionSelect- and institutionSearchPane that did not support the configured products
- Allow opt-in of account linking via microdeposits by configuring `userLegalName` and `userEmailAddress`; before public keys enabled for the latest auth features were required to provide `userLegalName` and `userEmailAddress`



## 2019-02-27 — LinkKit 1.1.16
### Changed
- Fix issue with account verification via manual microdeposits
- Fix issue with multiple institution logos displayed when blurring views with sensitive information once the app switcher is activated



## 2019-02-05 — LinkKit 1.1.15
### Added
- Add support for the latest [Auth features](https://blog.plaid.com/new-auth). Read the [blog post](https://blog.plaid.com/new-auth), and reach out to integrations@plaid.com to enable your account and begin testing
- Add haptic feedback for selection changes and validation errors
- Add account number confirmation step when asking the end-user to enter their account and routing number
- Add retry for account routing number entry

### Changed
- Improve account routing number messaging on validation errors
- Improve VoiceOver support
- Fix unknown account subtype in metadata in the `PLKPlaidLinkViewDelegate` calls ([#294](https://github.com/plaid/link/issues/294))
- Fix multiple account selection indicator
- Fix grammar and spelling mistakes in header comments

### Known issues
The following issues currently exist in LinkKit and will be addressed with the next release planned for the end of February 2019
- When verifying an account via manual microdeposits Plaid Link for iOS stalls after confirming the account number



## 2018-12-17 — LinkKit 1.1.14
### Changed
- Fix access for optional `webhook` and `clientName` configuration properties ([#284](https://github.com/plaid/link/issues/284))
- Improve compatibility with iOS 8



## 2018-10-30 — LinkKit 1.1.13
### Changed
- Improve VoiceOver accessibility by focussing on primary element when views appear, setting more specific accessibility labels, hints, and traits for existing elements, and hiding irrelevant elements.
- Improve handling of blur effect on application suspend / resume when other modal view controllers as for the Reset password flow are presented / dismissed.
- Include all available accounts metadata in the `linkViewController:didSucceedWithPublicToken:metadata` delegate calls ([#239](https://github.com/plaid/link/issues/239))



## 2018-09-17 — LinkKit 1.1.12
### Added
- Add support for iOS 12 security code auto-fill

### Changed
- Fix issue where customizing the copy of button on the consent pane did not update the copy of the text below accordingly
- The metadata in the `linkViewController:didHandleEvent:metadata` callback method now includes data of the selected institution in every event if present
- Allow the `dismissViewControllerAnimated:completion:` to be called on the `PLKPlaidLinkViewController` object (addresses [#254](https://github.com/plaid/link/issues/254)). Yet we recommend calling `dismissViewControllerAnimated:completion:` on the object that presented the `PLKPlaidLinkViewController` or on the `presentingViewController` property of the `linkViewController` object passed to the `PLKPlaidLinkViewDelegate` methods.

### Known issues
The following issues currently exist in LinkKit and will be addressed with the next release planned for the middle of October 2018.
- If the Reset password button on the credentials pane is tapped at the same time that the application goes into the background, the blur effect, which hides sensitive information from views, is not removed once the application becomes active again.



## 2018-08-15 — LinkKit 1.1.11
### Added
- Add support for customization of the headline, submit button, and highlight color on the initial consentPane
- Add support for alphanumeric MFA codes
- Add support for react native
- Remove sensitive information from views before moving to the background

### Changed
- Fix issue where the `Restart` action on the result pane exited the flow instead of going back to the institution select pane. (addresses [#256](https://github.com/plaid/link/issues/256)).
- Fix issue where LinkKit can crash during device based mfa (addresses [#252](https://github.com/plaid/link/issues/252)).
- Improve animation of blur effect during application suspend / resume

### Known issues
The following issues currently exist in LinkKit and will be addressed with the next release planned for the middle of September 2018.
- When customizing the copy of button on the consent pane the copy of the text below is not updated accordingly



## 2018-07-02 — LinkKit 1.1.10
### Added
- Plaid Link for iOS now asks end users for their consent to Plaid's privacy policy

### Changed
- Fix issue that could crash LinkKit in sandbox mode when viewing the development mode information
- Fix issue where the last active pane instead of the institution select pane would be shown when the same instance of `PLKPlaidLinkViewController` was re-used
- Present institution website after "Unlock account" is tapped on the result pane for a locked item

### Known issues
The following issues currently exist in LinkKit 1.1.10 and older and are fixed in LinkKit [1.1.11](https://github.com/plaid/link/releases/ios%2F1.1.11)
- LinkKit can crash during device based mfa. For further details see [#252](https://github.com/plaid/link/issues/252).



## 2018-05-17 — LinkKit 1.1.9
### Changed
- Improve compatability with iOS 8
- Fix issue where the search pane would be shown instead of the institution select pane when going back from the credentials pane
- Visual user interface modification to create more similarity between Plaid Link for [web](https://plaid.com/docs/quickstart/) and iOS



## 2018-04-16 — LinkKit 1.1.8
### Changed
- Fix issue with credentials validation that requires a PIN code when using a third-party password manager
- Fix status bar style for applications that disable view controller-based status bar appearance
- All delegate methods of the `PLKPlaidLinkViewDelegate` protocol are now called on the main thread
- Visual user interface modification to create more similarity between Plaid Link for [web](https://plaid.com/docs/quickstart/) and iOS
- Move the third-party password manager button from the username field to the password field

### Removed
- Remove back bar button item on credential pane when retrying credentials using custom initializer flow



## 2018-03-20 — LinkKit 1.1.7
### Added
- Add customizable exit button below search results (addresses [#228](https://github.com/plaid/link/issues/228)).
- For the select account flow the account mask, type, and subtype are now returned in the metadata of the `linkViewController:didSucceedWithPublicToken:metadata` handler.

### Changed
- Deprecate `kPLKMetadataInstitutionType` constant in favor of `kPLKMetadataType` and `kPLKMetadataInstitution_Type` in favor of `kPLKAPIv1MetadataInstitutionType`

### Removed
- Remove the Success view when Select Accout is enabled in the Plaid Dashboard, to match the behaviour in Link Web



## 2018-03-01 — LinkKit 1.1.6
### Added
- Add warning log message when third-party password manager support is not setup properly

### Changed
- Values for `PLKPLAIDLINK_DIAGNOSTICS` log level to accommodate for newly added warning log level
- Fix sandbox only crash when submitting credentials after having viewed the development mode info view ([#234](https://github.com/plaid/link/issues/234))
- Fix crash when customized institution select pane contained certain institutions ([#235](https://github.com/plaid/link/issues/235))



## 2018-02-15 — LinkKit 1.1.5
### Added
- Improve error handling when initializing LinkKit
- When retrying a login the previously entered username will remain in the username input field.

### Changed
- Fix bug where password manager action sheet could be invoked even though password manager button in credential field was invisible
- Visual user interface modification to create more similarity between Plaid Link for [web](https://plaid.com/docs/quickstart/) and iOS.

### Known issues
The following issues currently exist in LinkKit and will be addressed with the next release planned for beginning of March 2018.
- LinkKit can crash when the Institution Select pane has been customized with certain longtail institutions with long names. Unfortunately this is a production issue and we recommend removing these institutions from the customized Institution Select pane until the next version of LinkKit has been integrated in your application. For further details see [`plaid/link#235`](https://github.com/plaid/link/issues/235)
- LinkKit crashes when using custom initializers and navigating back from the development mode info pane to the credentials pane and then submitting credentials. This is a sandbox / development only related issue and cannot occur in production context where the development mode info page is not available. For further details see [`plaid/link#234`](https://github.com/plaid/link/issues/234)



## 2018-01-11 — LinkKit 1.1.4
### Added
- Add support for password managers to allow users to use application extensions provided by password manager applications to fill in the account credentials. Please note that the application integrating LinkKit must add `org-appextension-feature-password-management` to `LSApplicationQueriesSchemes` in its `Info.plist`

### Changed
- Visual user interface modification to create more similarity between Plaid Link for [web](https://plaid.com/docs/quickstart/) and iOS.
- Fix issue that prevented bank accounts to be successfully linked when using non-sandbox keys in the Tartan environment with the legacy API.



## 2017-12-11 — LinkKit 1.1.3
### Added
- Allow customization of "top" institutions if the corresponding option is enabled in the [Dashboard](https://dashboard.plaid.com/link/institution-select)

### Changed
- Add consistency to visual appearance of buttons in highlighted state



## 2017-11-02 — LinkKit 1.1.2
### Changed
- Fix single account pre-selection, where `didExitWithError:metadata:` was called instead of `didSucceedWithPublicToken:metadata:` when the pre-selected was not tapped despite of already being selected
- Add support for alphanumeric mfa codes
- Deprecate `selectAccount` parameter on `PLKConfiguration` in favour of the Select Account view customization available from the Dashboard https://dashboard.plaid.com/link/account-select or the `kPLKCustomizationEnabledKey` customization for `kPLKAccountSelectPaneKey` when using `PLKConfiguration.customizeWithDictionary:`. The `selectAccount` parameter will be removed in a future release.



## 2017-10-23 — LinkKit 1.1.1
### Changed
- Fix Apple review rejections of applications using Plaid Link iOS due to LinkKit.framework containing GCC and LLVM Instrumentation (see [Technical Q&A QA1964](https://developer.apple.com/library/content/qa/qa1964/_index.html)).
- Fix view controller animation transition when the `backBarButtonItem` was tapped.



## 2017-10-02 — LinkKit 1.1.0
### Added
- Add support for iPhone X
- Allow selecting multiple accounts if the corresponding option is enabled in the [Dashboard](https://dashboard.plaid.com/)
- Add `kPLKMetadataAccountsKey` to `metadata` returned in the `PLKPlaidLinkViewDelegate` methods
- Add `kPLKMetadataLinkSessionIdKey` to `metadata` returned in the `PLKPlaidLinkViewDelegate` methods
- Add APIv2 error codes to the `NSError.userInfo` passed to the `linkViewController:didExitWithError:metadata:` `PLKPlaidLinkViewDelegate` method ([#208](https://github.com/plaid/link/issues/208))
- Extend `PLKPlaidLinkViewDelegate` protocol with `linkViewController:didHandleEvent:metadata`, see https://www.plaid.com/docs/api/#onevent-callback for details.

### Changed
- Automatically select an account if there is only one available
- Replace `kPLKMetadataRequestIdKey` with `kPLKMetadataLinkRequestIdKey` in `metadata` returned in the `PLKPlaidLinkViewDelegate` methods when using APIv1

### Removed
- Remove right `×` exit button from navigation bar on connected pane and select account pane



## 2017-09-04 — LinkKit 1.0.10
### Changed
- Fix issue where an empty select account pane was shown instead of an error message stating that no eligible ACH accounts were available



## 2017-08-25 — LinkKit 1.0.9
### Changed
- Improve search results when using APIv1



## 2017-08-18 — LinkKit 1.0.8
### Added
- Add support for three or more MFA selection options
- Tapping on sample credentials in the development mode view copies them to the pasteboard

### Changed
- Immediately notify users when attempting to patch an item without any errors
- Correctly pass errors to the `PLKPlaidLinkViewDelegate` after recaptcha validation ([#191](https://github.com/plaid/link/issues/191))
- Enable scrolling for long questions on MFA view.
- Correctly set `metadata.status` to `kPLKStatusInstitutionNotFound` when the user tapped the exit button shown when the institution search yielded no results ([#190](https://github.com/plaid/link/issues/190))
- Use application name as set in Info.plist (`kCFBundleNameKey`) when `clientName` is not configured [#189](https://github.com/plaid/link/issues/189))
- Correctly set returned institution metadata to `null` when Link exits from institution selection [#185](https://github.com/plaid/link/issues/185#issuecomment-319513872))
- Improve animation when dismissing `PLKPlaidLinkViewController` with a subview being the `firstResponder`
- Improve accessibility on back button
- Prefix method names on UIKit and Foundation categories with `plk_` to prevent method name clashes ([#195](https://github.com/plaid/link/issues/195))



## 2017-07-26 — LinkKit 1.0.7
### Changed
- Fix interactive area of exit button ([#185](https://github.com/plaid/link/issues/185))
- Fix issue where the logo for certain institutions was not shown in the search results



## 2017-07-11 — LinkKit 1.0.6
### Added
- Add [copy customization](https://blog.plaid.com/link-copy-customization/) which allows to change the text of certain user interface elements in the Link flow
- Add exit button when searching for an institution yielded no results so people can directly exit out of Link iOS
- Add time-out message when searching for an institution takes too long

### Changed
- Fix issue with configured webhook when using APIv2



## 2017-06-12 — LinkKit 1.0.5
### Added
- Add phone MFA type

### Changed
- Fix APIv1 select account flow in which users were incorrectly asked to select their account ([#169](https://github.com/plaid/link/issues/169))
- Gracefully handle Link internal issues that previously could lead to crashes ([#169](https://github.com/plaid/link/issues/169))
- Return `institution_id` in metadata when using APIv2 ([#172](https://github.com/plaid/link/issues/172))
- Show institution name in title bar ([#173](https://github.com/plaid/link/issues/173))
- Improve iOS 9 compatibility ([#169](https://github.com/plaid/link/issues/169))
- Show placeholders in the select account view when additional account information is unavailable
- Return to the institution select view when an instituion's mfa method is not supported
- Improve positioning of institution logo



## 2017-04-14 — LinkKit 1.0.4
### Added
- [`LICENSE`](LICENSE)

### Changed
- Call exit handler `linkViewController:didExitWithError:metadata:` instead of success handler `linkViewController:didSucceedWithPublicToken:metadata` when exiting update mode from the credentials view ([#148](https://github.com/plaid/link/issues/148)).
- Correct header documentation regarding pre-selecting an institution; `initWithInstitution:delegate:` and `initWithInstitution:configuration:delegate` ([#154](https://github.com/plaid/link/issues/154)).
- Show alphanumeric keyboard for PIN entry when in development mode.
- Improve wording of `NSInvalidArgumentException` which is thrown when an `env` incompatible with the `apiVersion` is configured (see [README.md](README.md#environment--api-version-compatibility) for details).



## 2017-03-31 — LinkKit 1.0.3
### Added
- Institution `huntington`

### Changed
- Fix issue with credentials authentication when an institution requires a PIN
- Use default api version when none specified
- Fix compiler warnings in LinkDemo-Swift project



## 2017-03-17 — LinkKit 1.0.2
### Added
- Institutions `citizens` and `regions`
- Sandbox environment for APIv2
- Tartan environment for APIv1
- CHANGELOG.md

### Changed
- Update documentation regarding environments (see [README.md](README.md#environment--api-version-compatibility) for details)
- Update development mode information regarding selections MFA
- `LINK_ENV` build settings in Xcode demo projects
- Redesign demo application welcome view
- User interface font size

### Removed
- Testing environment for APIv1 and APIv2
- Development environment for APIv1 (NOTE: configuring the `Development` environment for `APIv1` will result in an exception)



## 2017-03-10 — LinkKit 1.0.1
### Changed
- Development mode information



## 2017-03-09 — LinkKit 1.0.0
### Added
- LinkKit.framework
- Xcode demo projects ([LinkDemo-ObjC](LinkDemo-ObjC), [LinkDemo-Swift](LinkDemo-Swift), [LinkDemo-Swift2](LinkDemo-Swift2))



