# React Native for Plaid Link (iOS)

⚛︎📱 This repository contains sample code that demonstrate integration and use of Plaid Link using React Native.
Currently only iOS supported.

## Prerequisites

To follow the steps in this example the following software is needed

* [Xcode](https://developer.apple.com/xcode/)
* [yarn](https://yarnpkg.com/) (to install yarn on macOS we suggest using nvm: `brew install nvm; nvm install 8; nvm use 8; npm -g install yarn`)

## Using React Native for Plaid Link

* Clone the [Plaid Link](https://github.com/plaid/link) repository
* Register the `react-native-plaid-link` component with yarn:
	`(cd link/react-native/linkkit; yarn link)`
* Link the newly registered `react-native-plaid-link` component with your react-native project and install the needed dependencies:
	`(cd $PATH_TO_YOUR_REACT_NATIVE_PROJECT;yarn link react-native-plaid-link; yarn install)`
* In your `App.js` import Plaid Link using:
	`import PlaidLink from 'react-native-plaid-link';`
* Create a `linkHandler` object (we recommend doing so in `componentDidMount()`) and replace any of the placeholder `<#VARIABLE#>`s in the example below according to your setup (for details see the [Plaid Link documentation](https://plaid.com/docs/quickstart/#client-side-link-configuration)):
```js
    this.linkHandler = PlaidLink.create({
      key: '<#PUBLIC_KEY#>',
      env: '<#ENVIRONMENT#>',
      product: ['<#PRODUCT#>'],
      clientName: '<#CLIENT NAME#>',
      onSuccess: this.onSuccess,
      onExit: this.onExit,
      onEvent: this.onEvent,
    });
```
* Next, when you would like to show the Plaid Link flow call `open()` on the `linkHandler`, e.g. `this.linkHandler.open();` which will modally present Plaid Link and guide the user through the process of linking their account with your application through Plaid
* Once the user has completed, exited, or errored out of the flow the appropriate callback method is invoked
* A detailed working example can be found in [`react-native/demo/lib/App.js`](/tree/master/react-native/demo/lib/App.js)

## When using Xcode:
1. Under "Libraries", make sure RNLinkkit.xcodeproject is included (you can find this in /link/react-native/linkkit/ios/ which is the Plaid Link repository you cloned from Plaid's GitHub at https://github.com/plaid/link)
2. If it's not already there n your main project's  "General" settings tab, make sure LinkKit.framework (found in the Plaid Link repo you cloned at /link/ios/ ) is included in both "Embedded Binaries" and "Linked Frameworks and Libraries" by dragging and dropping it in.
3. On your main project's "Build Phases" tab, make sure LinkKit.framework is included in "Link Binaries with Libraries" and "Embed Frameworks"

## About the linkdemo_reactnative Xcode project

ℹ️  In order build and run the `linkdemo_reactnative` iOS demo application the `react-native-plaid-link` component must be registered and linked to the Xcode project as mentioned above, e.g.:
	`(cd link/react-native/demo; yarn link react-native-plaid-link; yarn install)`
	
	
