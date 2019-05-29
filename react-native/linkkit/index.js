/**
 * Copyright (c) 2018, Plaid Inc.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *
 * @providesModule PlaidLink
 * @flow
 * @format
 */

'use strict';

import { NativeModules, NativeEventEmitter } from 'react-native';

const { RNLinkkit } = NativeModules;

const PlaidLink = {
  /**
   * Create Plaid Link.
   *
   * The `configuration` object must contain one or more of:
   *
   * - `key` (string)                    - the Plaid public_key (required)
   * - `env` (string)                    - the Plaid environment (required)
   * - `product` (array of strings)      - a list of Plaid products (required)
   * - `clientName` (string)             - the name to display on info panes (recommended)
   * - `webhook` (string)                - webhook to receive transaction and error updates
   * - `selectAccount` (boolean)         - enables the select account flow when set to true
   *
   * - `userLegalName` (string)          - the legal name of the end-user, necessary for microdeposit support
   * - `userEmailAddress` (string)       - the email address of the end-user, necessary for microdeposit support
   * - `countryCodes` (array of strings) - a list of ISO 3166-1 alpha-2 country codes, used to select institutions available in the given countries
   * - `language` (string)               - Plaid-supported language to localize Link. English ('en') will be used by default. For details consult https://plaid.com/docs/#parameter-reference.
   * - `publicToken` (string)            - the public_token to invoke update mode (see https://plaid.com/docs/quickstart/#use-link-to-resolve-error)
   * - `institution` (string)            - institution identifier for which to invoke the custom initializer flow
   *
   * The are deprecated configuration options for the legacy API
   * - `longtailAuth` (boolean) - enable longtail auth institutions
   * - `apiVersion` (string)    - the Plaid API version to use
   *
   * - `onSuccess` (function) - takes two parameters: the created public_token and the associated metadata.
   * - `onExit` (function)    - takes two parameters: error and the associated metadata.
   * - `onEvent` (function)   - takes two parameters: the event name and the associated metadata.
   */
  create(
    configuration: {|
      +key: string,
      +env: string,
      +product: Array<string>,
      +clientName?: ?string,
      +webhook?: ?string,
      +selectAccount?: ?boolean,

      +userLegalName?: ?string,    // specify for microdeposit support
      +userEmailAddress?: ?string, // specify for microdeposit support
      +countryCodes: Array<string>,
      +language: ?string,
      +publicToken?: ?string,      // specify for patch flow
      +institutionId?: ?string,    // specify for custom initializer

      +longtailAuth?: ?boolean, // enable only if you are absolutely sure you are entitled for and need longtailAuth
      +apiVersion?: ?string,    // specify only if you are absolutely sure you need to use the legacy API

      +onSuccess: (publicToken: string, metadata: Object) => void,
      +onExit: (error: any, metadata: Object) => void,
      +onEvent: ?(event: string, metadata: Object) => void,
    |},
  ) {
    if (typeof configuration.onSuccess !== 'function') {
      throw new Error('Must provide an onSuccess callback');
    }
    if (typeof configuration.onExit !== 'function') {
      throw new Error('Must provide an onExit callback');
    }
    if (configuration.webhook && configuration.webhook.length > 0 && !configuration.webhook.startsWith('http')) {
      throw new Error('webhook parameter must be a valid HTTP(S) URL');
    }

    RNLinkkit._create(configuration);
    var emitter = new NativeEventEmitter(RNLinkkit);

    emitter.addListener("onSuccess", payload => {
      configuration.onSuccess(payload.publicToken, payload.metadata);
    });

    emitter.addListener("onExit", payload => {
      configuration.onExit(payload.error, payload.metadata);
    });

    if (configuration.onEvent) {
      emitter.addListener("onEvent", payload => {
        configuration.onEvent(payload.event, payload.metadata);
      });
    }
    return this;
  },

  /**
   * Open Plaid Link.
   *
   * Calling `open()` will present the Plaid Link user interface implemented by the native `PLKPlaidLinkViewController`
   */
  open() {
    RNLinkkit._open();
  },

  version: RNLinkkit.version,
};

export default PlaidLink;
