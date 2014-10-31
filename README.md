# vindicia-api

A wrapper for making calls to Vindicia's CashBox SOAP API.

## Installation

Add this line to your application's `Gemfile`:

```ruby
gem 'vindicia-api'
```

And then execute:

```
$ bundle install
```

Or install it yourself as:

```
$ gem install vindicia-api
```

## Usage

Add something like the following to your environments or in an initializer:

```ruby
Vindicia.configure do |config|
  config.api_version = '3.6'
  config.login     = 'your_login'
  config.password  = 'your_password'
  config.endpoint  = 'https://soap.prodtest.sj.vindicia.com/soap.pl'
  config.namespace = 'http://soap.vindicia.com'

  # By default, Savon logs each SOAP request and response to $stdout.
  config.general_log = true    # config.log = false for disable logging

  # SSL Config options
  # Warning DO NOT USE ssl_verify_mode :none for Production systems!
  config.ssl_version     = :TLSv1               # [:TLSv1, :SSLv2, :SSLv3]
  config.ssl_verify_mode = :peer                # :none, :peer, :fail_if_no_peer_cert, :client_once
  config.cert_file       = '<path-to-file>'     # Your Certficate File
  config.ca_cert_file    = '<path-to-ca-file>'  # Eg. http://curl.haxx.se/ca/cacert.pem
  config.key_file        = '<path-to-key-file>' # Your Certificate Key file
  config.key_pwd         = '<password>'         # Certificate Key Password


  # In a Rails application you might want Savon to use the Rails logger.
  # config.logger = Rails.logger
  config.logger = Rails.logger

  # The default log level used by Savon is :debug.
  config.log_level = :debug  # :info

  # Filter those details just for the sake of security
  config.log_filter = [:password, :login]

  # The XML logged by Savon can be formatted for debugging purposes.
  # Unfortunately, this feature comes with a performance and is not
  # recommended for production environments.
  # config.pretty_print_xml = true
  config.pretty_print_xml = true

end
```

You will want to modify the example above with which API version you are targeting, your login credentials, and the Vindicia endpoint you will be using.

Current supported API versions are '3.5', '3.6', '4.0'

Available Vindicia endpoints are:

* Development: "https://soap.prodtest.sj.vindicia.com/soap.pl"
* Staging: "https://soap.staging.sj.vindicia.com"
* Production: "https://soap.vindicia.com/soap.pl"

After the Vindicia API has been configured, all Vindicia classes for the respective API version will be available under the `Vindicia::*` namespace.

Parameters are passed as hashes, for example:

```ruby
Vindicia::AutoBill.fetch_by_account(:account => { :merchantAccountId => id }
```

* Note that parameters must be specified in the same order as documented in Vindicia's developer documentation.

## Notes

* Because the WebSession class uses 'initialize' as an API call which is a ruby reserved word, we have re-routed
  this request so that is called using "WebSession.init()" in the Ruby app instead. This call will instantiate
  a web session with Vindicia.

## Contributing to vindicia-api

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2011-2013 Agora Games. See LICENSE.txt for further details.
