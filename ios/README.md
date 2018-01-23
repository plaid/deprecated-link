# Plaid Link for iOS

📚 Detailed instructions on how to integrate with Plaid Link for iOS can be found in our main documentation at [plaid.com/docs/link/ios][link-ios-docs].

📱 This repository contains sample applications in [Objective-C](LinkDemo-ObjC), [Swift4](LinkDemo-Swift4), [Swift3](LinkDemo-Swift3), and [Swift 2](LinkDemo-Swift2) (requires Xcode 7) that demonstrate integration and use of Plaid Link for iOS.

## About the LinkDemo Xcode projects

ℹ️  In order to compile the source code that uses the [custom configuration](https://plaid.com/docs/link/ios#configure_custom) add `-DUSE_CUSTOM_CONFIG` to `OTHER_SWIFT_FLAGS` in the LinkDemo-Swift build settings and to `OTHER_CFLAGS` in the LinkDemo-ObjC build settings.

![Use Custom Config](/ios/docs/images/use_custom_config.jpg)

🤖 Throughout the source code there are HTML-like comments such as <code>&lt;!-- SMARTDOWN_PRESENT_CUSTOM --&gt;</code>, they are used to update the code examples in the [documentation][docs] from the sample applicationsʼ code ensuring that the examples are up-to-date and working as intended.


[link-ios-docs]: https://plaid.com/docs/link/ios
