#NfgRestClient
The NfgRestClient gem is a wrapper for NetworkForGood's restful donation API. Using the Flexirest gem (https://github.com/andyjeffries/flexirest), the NfgRestClient makes it simple to consume the donation API for both retrieving information and creating donations and donors.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'nfg-rest-client'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install nfg-rest-client

## Usage

### Obtaining a partner account at NetworkforGood

### Generate the configuration initializer

To generate the configuration initializer, run

```ruby
  rails g nfg_rest_client:install
```

This will generate an config/initializers/nfg_rest_client.rb file containing the following:

```ruby
# Set your NetworkForGood authorization credentials here

# Do not include your credentials in your repository. You should
# place them in env variables (or similar) and refer to those
# variables here. Your sandbox and production credentials will be different.
NfgRestClient::Base.password = "nfg-password"
NfgRestClient::Base.userid =  "nfg-userid"
NfgRestClient::Base.source = "nfg-source"

# Please refer to the Readme doc for instructions on obtaining
# a sandbox and production token (they will be different)
NfgRestClient::Base.token = "your nfg token"


# When using the gem in a production environment
# it is expected that all requests will be against
# the NFG production servers. In all other environments
# the gem will use the sandbox servers
if Rails.env == "Production"
  NfgRestClient::Base.use_sandbox = false
end
```

### Generating an access token

#### Using the AccessToken model
Using the AccessToken model in this gem. To generate a production access token you would need to have this gem installed and configured
in your production code before generating the token using the code below from your production server's console

```ruby
at = NfgRestClient::AccessToken.new
at.create
at.token

If token is blank, look at
at.status
at.message
```
#### Using Curl
Using a curl statement. You should run this both for the sandbox from any development machine with whitelisted IP addresses,
and your production server(s) that have also been whitelisted

For the sandbox
```
curl --include \
     --request POST \
     --header "Content-Type: application/json" \
     --data-binary "{
    \"source\": \"YOUR_SOURCE\",
    \"userid\": \"YOUR USERID\",
    \"password\": \"YOUR_PASSWORD\",
    \"scope\": \"donation donation-reporting\"
}" \
'https://api-sandbox.networkforgood.org/access/rest/token'
```

For production
```
curl --include \
     --request POST \
     --header "Content-Type: application/json" \
     --data-binary "{
    \"source\": \"YOUR_SOURCE\",
    \"userid\": \"YOUR USERID\",
    \"password\": \"YOUR_PASSWORD\",
    \"scope\": \"donation donation-reporting\"
}" \
'https://api.networkforgood.org/access/rest/token'
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/nfg-rest-client. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

