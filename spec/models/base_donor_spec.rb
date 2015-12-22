require 'spec_helper'

describe NfgRestClient::BaseDonor do
  let(:donor) { NfgRestClient::BaseDonor.new(attributes) }
  let(:attributes) { donor_params }

  it { validate_presence_of donor, :firstName }
  it { validate_presence_of donor, :lastName }
  it { validate_presence_of donor, :token }
  it { validate_presence_of donor, :email }
end

def donor_params
  {
    "token" => "802f365c-ed3d-4c80-8700-374aee6ac62c",
    "firstName" => "Francis",
    "lastName" => "Carter",
    "email" => "FrancisGCarter@teleworm.us",
  }
end