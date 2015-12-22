module NfgRestClient::SpecAttributes

  def changes_to_attributes
    {}
  end

  def donation_line_items
    [
      full_donation_line_item_attributes,
      non_optional_donation_line_item_attributes
    ]
  end

  def country
    "US"
  end

  def state
    "FL"
  end

  def security_code
    "123"
  end

  def add_or_deduct_1
    "Deduct"
  end

  def add_or_deduct_2
    "Deduct"
  end

  def total_amount
    "100.00"
  end

  def card_on_file_id
    1096597
  end

  def donation_attributes(items_to_be_merged = {}, style = 'underscore')
    (style == 'underscore' ? donation_attributes_hash : donation_attributes_hash.inject({}) { |memo, (k, v)| memo[k.camelcase(:lower)] = v; memo })
    .merge(style == 'underscore' ? items_to_be_merged : items_to_be_merged.inject({}) { |memo, (k, v)| memo[k.camelcase(:lower)] = v; memo })
  end

  def donation_attributes_hash(donation_credit_card_payment = donation_credit_card_payment_attributes)
    {
      "donation_line_items" => donation_line_items,
      "total_amount" => total_amount,
      "tip_amount" => 0.0,
      "partner_transaction_id" => "__unique_transaction_id__",
      "payment" => donation_credit_card_payment
    }
  end

  def full_donation_line_item_attributes
    {  "organizationId" => "590624430",
      "organizationIdType" => "Ein",
      "designation" => "Project A",
      "dedication" => "In honor of grandma",
      "donorPrivacy" => "ProvideAll",
      "amount" => "50.00",
      "feeAddOrDeduct" => add_or_deduct_1,
      "transactionType" => "Donation",
      "recurrence" => "NotRecurring"
    }
  end

  def non_optional_donation_line_item_attributes
    {  "organizationId" => "590624430",
      "organizationIdType" => "Ein",
      "designation" => "Project A",
      "amount" => "50.00",
      "feeAddOrDeduct" => add_or_deduct_2,
      "transactionType" => "Donation",
    }
  end

  def card_on_file_payment
    {
      "source" => "CardOnFile",
      "cardOnFileId" => card_on_file_id,
      "donor" => {
        "ip" => "50.121.129.54",
        "token" => "802f365c-ed3d-4c80-8700-374aee6ac62c"
        }
    }
  end

  def donation_credit_card_payment_attributes(donation_donor = donation_donor_attributes, donation_credit_card = donation_credit_card_attributes)
  {
    "source" => "CreditCard",
    "donor" => donation_donor_attributes,
    "creditCard" => donation_credit_card
  }
  end

  def card_on_file_attributes(card_on_file_donor = donation_donor_attributes, card_on_file_credit_card = donation_credit_card_attributes)
    {
      "donor" => card_on_file_donor,
      "credit_card" => card_on_file_credit_card
    }
  end

  def donation_donor_attributes(billing_address = donation_billing_address_attributes)
    {
    "ip" => "216.7.145.0",
    "token" => "802f365c-ed3d-4c80-8700-374aee6ac62c",
    "firstName" => "Francis",
    "lastName" => "Carter",
    "email" => "FrancisGCarter@teleworm.us",
    "phone" => "954-922-6971",
    "billingAddress" => billing_address
    }
  end

  def donation_credit_card_attributes
    {
    "nameOnCard" => "Francis G. Carter",
    "type" => "Visa",
    "number" => "4111111111111111",
    "expiration" => {
      "month" => 11,
      "year" => 2019
      },
    "securityCode" => security_code
    }
  end

  def donation_billing_address_attributes
    {
    "street1" => "3731 Pointe Lane",
    "city" => "Hollywood",
    "state" => state,
    "postalCode" => "33020",
    "country" => country
    }
  end
end