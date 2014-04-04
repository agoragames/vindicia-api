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
  config.api_version = '4.2'
  config.login = 'your_login'
  config.password = 'your_password'
  config.endpoint = 'https://soap.prodtest.sj.vindicia.com/soap.pl'
  config.namespace = 'http://soap.vindicia.com'
end
```

You will want to modify the example above with which API version you are targeting, your login credentials, and the Vindicia endpoint you will be using.

Current supported API versions are [ '3.5', '3.6', '3.7', '3.8', '3.9', '4.0', '4.1', '4.2' ].

For a fuller understanding of the supported versions, classes, and methods, see
Vindicia::API_CLASSES.  For instance, the list of versions may be introspected
via the following:
Vindicia::API_CLASSES.keys

Likewise, the list of classes and their methods may be introspected via the following:
Vindicia::API_CLASSES[version_number]

Available Vindicia endpoints are:

* Development: "https://soap.prodtest.sj.vindicia.com/soap.pl"
* Staging: "https://soap.staging.sj.vindicia.com"
* Production: "https://soap.vindicia.com/soap.pl"

After the Vindicia API has been configured, all Vindicia classes for the respective API version will be available under the `Vindicia::*` namespace.

Parameters are passed as hashes, for example:

```ruby
auto_bill_response = Vindicia::AutoBill.fetch_by_account(:account => { :merchantAccountId => id })
auto_bill = auto_bill_response.to_class
if auto_bill.nil?
  raise "Error fetching AutoBill by Account for merchantAccountId: '#{id}', fault: '#{auto_bill_response.soap_fault}', error: #{auto_bill_response.http_error}"
end
```

* Note that parameters must be specified in the same order as documented in Vindicia's developer documentation.

## Hacks

* WebSession class is supported in a hacky manner, as it uses 'initialize' as
an API call which is a ruby reserved word.  An underscore is hence prepended to
avoid the issue, so WebSession._initialize can be used to create a WebSession.
* Savon 1 required jumping the same hoops repetitively to extract the class, so
.to_class was extended to Savon::SOAP::Response .

## Contributing to vindicia-api

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2011-2014 Agora Games. See LICENSE.txt for further details.
