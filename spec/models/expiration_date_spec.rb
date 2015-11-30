require 'spec_helper'

describe NfgRestClient::ExpirationDate do
  let(:expiration_date) { NfgRestClient::ExpirationDate.new(attributes) }
  let(:attributes) { expiration_date_params }

  it { validate_presence_of expiration_date, :month }
  it { validate_presence_of expiration_date, :year }
  it { validate_numericality_of expiration_date, :month, minumum: 1, maximimum: 12 }
  it { validate_numericality_of expiration_date, :year, minimum: Time.now.year, maximimum: (Time.now.year + 20) }

end

def expiration_date_params
  {
    "month" => "11",
    "year" => "2019"
  }
end