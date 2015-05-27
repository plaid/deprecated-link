#!/usr/bin/env ruby

require 'json'
require 'plaid'
require 'sinatra'

set :port, ENV['APP_PORT'] || 8000

# Initialize the Plaid client with your client_id and secret
Plaid.config do |p|
  p.customer_id = ENV['PLAID_CLIENT_ID']
  p.secret = ENV['PLAID_SECRET']
  p.environment_location = 'https://tartan.plaid.com'
end

#
get '/' do
  send_file File.join(settings.public_folder, 'index.html')
end

# AJAX endpoint that first exchanges a public_token from the Plaid Link
# module for a Plaid access token. That access_token is then used to
# retrieve account and balance data for a user using plaid-ruby.
get '/accounts' do
  # Pull the public_token from the querystring
  public_token = params[:public_token]

  # Exchange the Link public_token for a Plaid API access token
  exchange_token_response = Plaid.exchange_token(public_token)

  # Initialize a Plaid user
  user = Plaid.set_user(exchange_token_response.access_token, ['auth'])

  # Retrieve information about the user's accounts
  user.get('auth')

  # Transform each account object to a simple hash
  transformed_accounts = user.accounts.map do |account|
    {
      balance: {
        available: account.available_balance,
        current: account.current_balance
      },
      meta: account.meta,
      type: account.type
    }
  end

  # Return the account data as a JSON response
  content_type :json
  { accounts: transformed_accounts }.to_json
end
