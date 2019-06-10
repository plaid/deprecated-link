type EventName =
  | 'OPEN'
  | 'EXIT'
  | 'TRANSITION_VIEW'
  | 'SEARCH_INSTITUTION'
  | 'SELECT_INSTITUTION'
  // | 'SUBMIT_CREDENTIALS' // Happens in webview, does this happen in Plaid Link?
  | 'ERROR'
  | 'HANDOFF'

export interface EventMeta {
  link_session_id: string
  request_id?: string

  status?: string
  exit_status?: string

  timestamp?: Date
  view_name?: string

  mfa_type?: string

  institution?: Institution
  institution_search_query?: string
  institution_name?: string
  institution_id?: string

  account_id?: null
  account?: Account
  accounts?: Account[]

  error_type?: string
  error_code?: string
  error_message?: string
}

export interface Account {
  id?: string
  type?: string
  mask?: string
  name?: string
  subtype?: string
}

export interface Institution {
  name: string
  institution_id: string
}

export interface PlaidConfiguration {
  key: string
  env: 'sandbox' | 'development' | 'production'
  product: string[]
  clientName?: string
  webhook?: string
  selectAccount?: boolean

  userLegalName?: string
  userEmailAddress?: string
  countryCodes?: string[]
  language?: string
  publicToken?: string
  institution?: string

  onSuccess: (publicToken: string, meta: EventMeta) => void
  onExit: (error: any, meta: EventMeta) => void
  onEvent?: (eventName: EventName, meta: EventMeta) => void
}

interface PlaidLink {
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
  create: (config: PlaidConfiguration) => this

  /**
   * Open Plaid Link.
   *
   * Calling `open()` will present the Plaid Link user interface implemented by the native `PLKPlaidLinkViewController`
   */
  open: () => void
  version: string
}

declare const PlaidLink: PlaidLink

export default PlaidLink

/** TODO: Better mapping of eventName to metadata */
// export type PlaidEvent =
//   | {
//       eventName: 'EXIT'
//       metadata: { link_session_id: string }
//     }
//   | {
//       eventName: 'TRANSITION_VIEW'
//       metadata: { link_session_id: string }
//     }
//   | {
//       eventName: 'OPEN'
//       metadata: { link_session_id: string }
//     }
//   | {
//       metadata: { public_token: string; link_session_id: string }
//     }
//   | {
//       eventName: 'SEARCH_INSTITUTION'
//       metadata: { institution_search_query: string; link_session_id: string }
//     }
//   | {
//       eventName: 'SELECT_INSTITUTION'
//       metadata: {
//         institution_id: string
//         institution_name: string
//         link_session_id: string
//       }
//     }
//   | {
//       eventName: 'SUBMIT_CREDENTIALS'
//       metadata: {
//         institution_id: string
//         institution_name: string
//         link_session_id: string
//       }
//     }
//   | {
//       eventName: 'ERROR'
//       metadata: {
//         error_code: string // 'INVALID_CREDENTIALS'
//         error_message: string // 'the provided credentials were not correct'
//         error_type: string // 'ITEM_ERROR'
//         link_session_id: string
//       }
//     }
