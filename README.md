# Vindicia Api

A wrapper for making calls to Vindicia's CashBox SOAP API.

## Installation

Add this line to your application's Gemfile:

    gem 'vindicia-api'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install vindicia-api

## Usage

Add something like the following to your environments or in an initializer:

```ruby
Vindicia.configure do |config|
  config.api_version = '3.6'
  config.login = 'your_login'
  config.password = 'your_password' 
  config.endpoint = 'https://soap.prodtest.sj.vindicia.com/soap.pl'
  config.namespace = 'http://soap.vindicia.com'
end
```

You will want to modify the example above with which API version you are targeting, your login credentials, and the Vindicia endpoint you will be using.

Current supported API versions are '3.5' and '3.6'.

Available Vindicia endpoints are:
* Development: "https://soap.prodtest.sj.vindicia.com/soap.pl"
* Staging: "https://soap.staging.sj.vindicia.com"
* Production: "https://soap.vindicia.com/soap.pl"

After the Vindicia API has been configured, all Vindicia classes for the respective API version will be available under the Vindicia::* namespace.

Parameters are passed as hashes, for example:

```ruby
Vindicia::AutoBill.fetch_by_account(:account => { :merchantAccountId => id }
```

* Note that parameters must be specified in the same order as documented in Vindicia's developer documentation.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
