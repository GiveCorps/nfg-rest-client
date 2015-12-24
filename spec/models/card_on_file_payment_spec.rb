require 'spec_helper'

describe NfgRestClient::CardOnFilePayment do
  include NfgRestClient::SpecAttributes
  let(:credit_card_payment) { NfgRestClient::CardOnFilePayment.new(attributes) }
  let(:attributes) { card_on_file_payment }
  it { validate_presence_of credit_card_payment, :source }
  it { validate_presence_of credit_card_payment, :donor }
  it { validate_presence_of credit_card_payment, :cardOnFileId }
  it { validate_inclusion_of credit_card_payment, :source, { in: %w{CardOnFile}}}

end