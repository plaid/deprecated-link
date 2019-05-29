/**
 * Sample App Using React Native Plaid Link
 * https://github.com/plaid/link/tree/master/react-native/demo
 * @flow
 */

import React, { Component } from 'react';
import {
  Alert,
  Platform,
  SafeAreaView,
  StatusBar,
  StyleSheet,
  Text,
  TouchableOpacity,
  View
} from 'react-native';
import PlaidLink from 'react-native-plaid-link';

const title = Platform.select({
  ios: 'Plaid Link\nSDK Example',
  android: 'Work in Progress',
});

const info = Platform.select({
  ios: 'React Native — LinkKit ' + PlaidLink.version,
  android: '',
});

type Props = {};
export default class App extends Component<Props> {
  constructor(props) {
    super(props);
    this.onSuccess = this.onSuccess.bind(this);
    this.onExit = this.onExit.bind(this);
    this.onEvent = this.onEvent.bind(this);
    this.presentAlertViewWithTitle = this.presentAlertViewWithTitle.bind(this);
  }

  componentDidMount() {
    this.linkHandler = PlaidLink.create({
      // Replace any of the following <#VARIABLE#>s according to your setup,
      // for details see https://plaid.com/docs/quickstart/#client-side-link-configuration
      key: '<#PUBLIC_KEY#>',
      env: '<#ENVIRONMENT#>',
      product: ['<#PRODUCT#>'],
      clientName: '<#CLIENT NAME#>',
      //userLegalName: '<#USER_LEGAL_NAME#>',
      //userEmailAddress: '<#USER_EMAIL_ADDRESS#>',
      //countryCodes: ['<#COUNTRY_CODE#>'],
      //language: '<#LANGUAGE#>',
      //publicToken: '<#PUBLIC_TOKEN#>,
      //selectAccount': true,
      onSuccess: this.onSuccess,
      onExit: this.onExit,
      onEvent: this.onEvent,
    });
  }

  onSuccess(publicToken: string, metadata: Object) {
    this.presentAlertViewWithTitle('Success', 'token: '+publicToken+'\nmetadata: '+JSON.stringify(metadata))
  }

  onExit(error: Error, metadata: Object) {
    this.presentAlertViewWithTitle('Exit', 'error: '+error+'\nmetadata: '+JSON.stringify(metadata))
  }

  onEvent(name: string, metadata: Object) {
    console.log('Event name:', name, 'metadata:', metadata);
  }

  presentAlertViewWithTitle(title: string, message: string) {
    Alert.alert(title, message, [{text: 'OK'}], {cancelable: false})
  }

  render() {
    return (
      <SafeAreaView style={styles.container}>
        <StatusBar barStyle='dark-content'/>
        <Text style={styles.welcome}>
          WELCOME
        </Text>
        <Text style={styles.title}>
          {title}
        </Text>
        <Text style={styles.info}>
          {info}
        </Text>
        <View style={styles.buttonContainer}>
          <TouchableOpacity
            onPress={()=>this.linkHandler.open()}
            style={styles.button}
          >
            <Text style={styles.open}>Open Plaid Link</Text>
        </TouchableOpacity>
        </View>
      </SafeAreaView>
    );
  }
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#f7f9fb',
  },
  welcome: {
    marginTop: 36,
    marginLeft: 32,
    fontSize: 12,
    fontWeight: '300',
    textAlign: 'left',
    margin: 10,
    color: '#02B1F8',
  },
  title: {
    marginTop: 20,
    marginLeft: 32,
    fontSize: 26,
    lineHeight: 34,
    fontWeight: '400',
    textAlign: 'left',
    color: '#111111',
    margin: 10,
  },
  info: {
    fontSize: 12,
    marginLeft: 32,
    marginTop: 7,
    color: '#97b0c3',
    flex: 1,
  },
  buttonContainer: {
    shadowColor: '#033144',
    shadowRadius: 2,
    shadowOpacity: 0.1,
    shadowOffset: { width: 0, height: -1 },
    paddingTop: 28,
    paddingBottom: 54,
    flexDirection: 'column',
    backgroundColor: '#ffffff',
    // Make buttonContainer extend
    // all the way to the bottom edge on iPhone X
    marginBottom: -30,
    height: 168,
  },
  button: {
    backgroundColor: '#02B1F8',
    marginTop: 12,
    marginLeft: 32,
    marginRight: 32,
    borderRadius: 6,
  },
  open: {
    color: '#ffffff',
    fontSize: 17,
    fontWeight: '600',
    textAlign: 'center',
    margin: 15,
  },
});
