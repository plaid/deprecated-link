export type PlaidMessage =
  | {
      action: 'plaid_link-undefined::event'
      eventName: 'EXIT'
      metadata: { link_session_id: string }
    }
  | {
      action: 'plaid_link-undefined::event'
      eventName: 'TRANSITION_VIEW'
      metadata: { link_session_id: string }
    }
  | {
      action: 'plaid_link-undefined::event'
      eventName: 'OPEN'
      metadata: { link_session_id: string }
    }
  | {
      action: 'plaid_link-undefined::connected'
      metadata: { public_token: string; link_session_id: string }
    }
  | {
      action: 'plaid_link-undefined::event'
      eventName: 'SEARCH_INSTITUTION'
      metadata: { institution_search_query: string; link_session_id: string }
    }
  | {
      action: 'plaid_link-undefined::event'
      eventName: 'SELECT_INSTITUTION'
      metadata: {
        institution_id: string
        institution_name: string
        link_session_id: string
      }
    }
  | {
      action: 'plaid_link-undefined::event'
      eventName: 'SUBMIT_CREDENTIALS'
      metadata: {
        institution_id: string
        institution_name: string
        link_session_id: string
      }
    }
  | {
      action: 'plaid_link-undefined::event'
      eventName: 'ERROR'
      metadata: {
        error_code: string // 'INVALID_CREDENTIALS'
        error_message: string // 'the provided credentials were not correct'
        error_type: string // 'ITEM_ERROR'
        link_session_id: string
      }
    }

/**
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
export interface PlaidConfiguration {
  key: string
  env: 'sandbox' | 'development' | 'production'
  product: string[]
  clientName?: string
  webhook?: string
  selectAccount?: boolean

  publicToken?: string
  institution?: string

  onSuccess: (publicToken: string, meta: any) => void
  onExit: (error: any, meta: any) => void
  onEvent?: (data: PlaidMessage, meta: any) => void
}

declare const PlaidLink: {
  /** Technically returns `this` but donno how to type that for now... */
  create: (config: PlaidConfiguration) => void
  open: () => void
  version: string
}

export default PlaidLink
