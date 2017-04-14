# CHANGELOG

<!-- http://keepachangelog.com -->

## 2017-04-14 — LinkKit 1.0.4
### Added
- [`LICENSE`](LICENSE)

### Changed
- Call exit handler `linkViewController:didExitWithError:metadata:` instead of success handler `linkViewController:didSucceedWithPublicToken:metadata` when exiting update mode from the credentials view([#148](https://github.com/plaid/link/issues/148)).
- Correct header documentation regarding pre-selecting an institution; `initWithInstitution:delegate:` and `initWithInstitution:configuration:delegate` ([#154](https://github.com/plaid/link/issues/154)).
- Show alphanumeric keyboard for PIN entry when in development mode.
- Improve wording of `NSInvalidArgumentException` which is thrown when an `env` incompatible with the `apiVersion` is configured (see [README.md](README.md#environment--api-version-compatibility) for details).


## 2017-03-31 — LinkKit 1.0.3
### Added
- Institution `huntington`

### Changed
- Fix issue with credentials authentication when an institution requires a PIN
- Use default api version when none specified
- Fix compiler warnings in LinkDemo-Swift project


## 2017-03-17 — LinkKit 1.0.2
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


## 2017-03-10 — LinkKit 1.0.1
### Changed
- Development mode information


## 2017-03-09 — LinkKit 1.0.0
### Added
- LinkKit.framework
- Xcode demo projects ([LinkDemo-ObjC](LinkDemo-ObjC), [LinkDemo-Swift](LinkDemo-Swift), [LinkDemo-Swift2](LinkDemo-Swift2))
