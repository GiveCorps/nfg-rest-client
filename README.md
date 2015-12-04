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

Please thoroughly review the docs at http://docs.networkforgoodapi.apiary.io/#introduction/working-with-network-for-good for detailed information on obtaining partner credentials for Network For Good, working with the API, and PCI-compliance requirements and recommendations.

The apiary documentation also includes detailed information about the api, along with additional endpoints that may not yet have been implemented in this ruby wrapper.

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

### Creating a Donation

There are two methods for using the API to create donations. You can do so with credit card information, or with a previously saved card on file.

#### Using credit card information.

To create a donation using credit card information, perform the following:

````ruby
donation = NfgRestClient.donation.new(donation_params)
if !donation.valid?
  # handle invalid donation params
  flash[:error] = donation.full_error_messages
else
  donation.create
  if donation.successful?
    # perform successful donation operations
  else
    # perform unsuccessful donation operations
  end
end
````

The create method will also call valid?, so you can skip the separate step

Donation params can be in the form of a hash (for more information, see http://docs.networkforgoodapi.apiary.io/#reference/donation/credit-card-donations/make-a-credit-card-or-card-on-file-donation):
````ruby
{
  "donationLineItems" => [{
      "organizationId" => "590624430",
      "organizationIdType" => "Ein",
      "designation" => "Project A",
      "dedication" => "In honor of grandma",
      "donorPrivacy" => "ProvideAll",
      "amount" => "12.00",
      "feeAddOrDeduct" => "Deduct",
      "transactionType" => "Donation",
      "recurrence" => "NotRecurring"
  },
  {
      "organizationId" => "510126000486",
      "organizationIdType" => "NcesSchoolId",
      "designation" => "Gym",
      "donorPrivacy" => "ProvideNameAndEmailOnly",
      "amount" => "47.00",
      "feeAddOrDeduct" => "Add",
      "transactionType" => "Donation"
  }],
  "totalAmount" => 60.41,
  "tipAmount" => 0,
  "partnerTransactionId" => "1bf1c16c-fdb7-4579-abab-738dbbe852ed",
  "payment" => {
      "source" => "CreditCard",
      "storeCardOnFile" => "true",
      "donor" => {
          "ip" => "216.7.145.0",
          "token" => "802f365c-ed3d-4c80-8700-374aee6ac62c",
          "firstName" => "Francis",
         "lastName" => "Carter",
         "email" => "FrancisGCarter@teleworm.us",
         "phone" => "954-922-6971",
         "billingAddress" => {
           "street1" => "3731 Pointe Lane",
           "city" => "Hollywood",
           "state" => "FL",
           "postalCode" => "33020",
           "country" => "US"
         }
       },
       "creditCard" => {
         "nameOnCard" => "Francis G. Carter",
         "type" => "Visa",
         "number" => "4111111111111111",
         "expiration" => {
           "month" => 11,
           "year" => 2019
         },
         "securityCode" => "123"
       }

  }
}
````
The keys in the hash can be underscored ("credit_card") or camel cased ("creditCard" with the first character lower cased). Once the object is initialized, all attributes will use the camel case format.

You can also build the donation object from individual objects or any mixture of hash key/values and NfgRestClient objects:

````ruby
donation_line_item = NfgRestClient::DonationLineItem.new(donation_line_item_params)
credit_card = NfgRestClient::CreditCard.new(credit_card_params)
donor = NfgRestClient::CreditCardDonor.new(donor_params)
credit_card_payment = NfgRestClient::CreditCardPayment.new("donor" => donor, "credit_card" => credit_card)
donation = NfgRestClient::Donation.new(
  {
    "donation_line_items" => [donation_line_item],
    "total_amount" => 60.41, #in dollars with 2 decimal cents
    "tip_amount" => 0,
    "partner_transaction_id" => "your_systems_order_number",
    "payment" => credit_card_payment
  }
)
donation.create
if donation.successful?
  # handle successful donation
  order.charge_id = donation.chargeId
else
  # handle unsuccessful donation
  flash[:errors] = donation.response_error_details
end
````

Each of the individual components have their own validations. So you can verify that the credit card information has non-invalid parameters before building your donation object

i.e.
````ruby
credit_card = NfgRestClient::CreditCard.new(credit_card_params)
credit_card.valid?
````

#### Using a Card On File

To use a card on file, you must first create one at NFG. There are two ways to do this.
1. When sending a credit card donation, you can set the payment's storeCardOnFile to true:
````ruby
credit_card_payment = NfgRestClient::CreditCardPayment.new(credit_card_payment_params)
credit_card_payment.storeCardOnFile = true
# use credit_card_payment in a donation
````
The results will include a cardOnFileId, (donation.cardOnFile) which you would need to store to use later.

2. By sending a separate CardOnFile create request:
````ruby
card_on_file = NfgRestClient::CardOnFile.new(card_on_file_params)
if !card_on_file.valid?
  # handle invalid card_on_file params
  flash[:error] = card_on_file.full_error_messages
else
  card_on_file.create
  if card_on_file.successful?
    # perform successful card_on_file operations
    donor.card_on_file_id = card_on_file.cardOnFileId
  else
    # perform unsuccessful card_on_file operations
  end
end
````

The card on file params (for more information, see http://docs.networkforgoodapi.apiary.io/#reference/donor/card-on-file-operations/store-a-credit-card-on-file):
````ruby
{
  "donor" => {
      "ip" => "216.7.145.0",
      "token" => "802f365c-ed3d-4c80-8700-374aee6ac62c",
      "first_name" => "Francis",
     "last_name" => "Carter",
     "email" => "FrancisGCarter@teleworm.us",
     "phone" => "954-922-6971",
     "billing_address" => {
       "street1" => "3731 Pointe Lane",
       "city" => "Hollywood",
       "state" => "FL",
       "postal_code" => "33020",
       "country" => "US"
     }
   },
   "creditCard" => {
     "nameOnCard" => "Francis G. Carter",
     "type" => "Visa",
     "number" => "4111111111111111",
     "expiration" => {
       "month" => 11,
       "year" => 2019
     },
     "securityCode" => "123"
   }
}
````

As with the other params, the hash can have underscored or camel cased keys, or a mixture of them.

###

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/nfg-rest-client. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

