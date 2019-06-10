# React Native for Plaid Link (iOS)

⚛︎📱 This repository contains sample code that demonstrates integration and use of Plaid Link using React Native.
Currently only iOS is supported.

:warning: Note that this is the React Native bridge for Link officially supported by Plaid, but is very different
from the module with a similar name available on [npmjs](https://www.npmjs.com/package/react-native-plaid-link);
we strongly recommend favoring this React Native bridge.

## Prerequisites

To complete the steps in this example the following software is needed:

* [Xcode](https://developer.apple.com/xcode/)
* [yarn](https://yarnpkg.com/) (we recomment using nvm to install yarn on macOS: `brew install nvm; nvm install 8; nvm use 8; npm -g install yarn`)

## Using React Native for Plaid Link

* Clone the [Plaid Link](https://github.com/plaid/link) repository
* Add this `react-native-plaid-linkkit` component to your react-native project and install the necessary dependencies:
```sh
  % cd $PATH_TO_YOUR_REACT_NATIVE_PROJECT
  % yarn add file:$PATH_TO_YOUR_CLONE_OF_THIS_REPO/react-native/linkkit
  % yarn install
  % react-native link react-native-plaid-linkkit
```
* Integrate the native Plaid Link for iOS SDK (LinkKit.framework) into the iOS part of your react-native project, see the [documentation](https://plaid.com/docs/link/ios/) for details.
* In your `App.js` import Plaid Link using:
	`import PlaidLink from 'react-native-plaid-linkkit';`
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

## About the linkdemo_reactnative Xcode project

ℹ️  In order build and run the `linkdemo_reactnative` iOS demo application the `react-native-plaid-linkkit` component must be registered and linked to the Xcode project as mentioned above, e.g.:
```sh
  % cd link/react-native/demo
  % yarn add file:../linkkit
  % yarn install
  % react-native link react-native-plaid-linkkit
```
