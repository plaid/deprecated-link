# CHANGELOG

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



