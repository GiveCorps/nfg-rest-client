require "spec_helper"

shared_examples_for "a donation object" do

  it "should be valid if all of the keys are present and have appropriate values" do
    donation.valid?
    expect(donation).to be_valid
  end

  context 'when donationLineItems is not an array' do
    let(:changes_to_attributes) { { "donation_line_items" => "bad_data"} }
    it "should not be valid" do
      expect(donation.valid?).to be_falsy
      expect(donation.errors[:donationLineItems]).to be_present
    end
  end

  context 'when donationLineItems is an empty array' do
    let(:changes_to_attributes) { { "donation_line_items" => []} }
    it "should not be valid" do
      expect(donation.valid?).to be_falsy
      expect(donation.errors[:donationLineItems]).to be_present
    end
  end

  context 'when donationLineItems contain an invalid value' do
    let(:changes_to_attributes) { { "donation_line_items" => [{  "organizationId" => "590624430",
          "organizationIdType" => "Ein",
          "designation" => "Project A",
          "dedication" => "In honor of grandma",
          "donorPrivacy" => "NOT A VALID DonorPrivacy Value",
          "amount" => "12.00",
          "feeAddOrDeduct" => "Deduct",
          "transactionType" => "Donation",
          "recurrence" => "NotRecurring"
        }]} }

    it "should not be valid" do
      expect(donation.valid?).to be_falsy
      expect(donation.errors[:donationLineItems]).to be_present
    end
  end
end

describe NfgRestClient::Donation do
  include NfgRestClient::SpecAttributes
  let(:donation) { NfgRestClient::Donation.new(donation_attributes(changes_to_attributes,  "underscore")) }
  let(:changes_to_attributes) { {} }
  let(:state) { "FL" }
  subject { donation }

  it { validate_presence_of donation, :donationLineItems }
  it { validate_presence_of donation, :totalAmount }
  it { validate_presence_of donation, :tipAmount }
  it { validate_presence_of donation, :partnerTransactionId }
  it { validate_presence_of donation, :payment }

  context "when provided an hash with underscore separated keys" do
  let(:donation) { NfgRestClient::Donation.new(attributes) }
  let(:attributes) { donation_attributes(changes_to_attributes,  "underscore") }

    it_should_behave_like "a donation object"
  end

  context "when provided an hash with camelcase and leading lowercase keys" do
    let(:donation) { NfgRestClient::Donation.new(attributes) }
    let(:attributes) { donation_attributes(changes_to_attributes,  "camelcase") }

    it_should_behave_like "a donation object"
  end

  context "when providing NfgRestClient models as hash elements" do
    let(:donation) { NfgRestClient::Donation.new(attributes) }
    let(:donation_line_item_1) { NfgRestClient::DonationLineItem.new(full_donation_line_item_attributes) }
    let(:donation_line_item_2) { NfgRestClient::DonationLineItem.new(non_optional_donation_line_item_attributes) }
    let(:credit_card_payment) { NfgRestClient::CreditCardPayment.new(donation_credit_card_payment_attributes(donor, credit_card)) }
    let(:donor) { NfgRestClient::CreditCardDonor.new(donation_donor_attributes(donor_address)) }
    let(:donor_address) { NfgRestClient::BillingAddress.new(donation_billing_address_attributes) }
    let(:credit_card) { NfgRestClient::CreditCard.new(donation_credit_card_attributes) }
    let(:donation_line_items) { [
      donation_line_item_1,
      donation_line_item_2
      ] }

    let(:attributes) { donation_attributes_hash(credit_card_payment) }
    context "and all of the required values are present and valid" do
      it "should be valid" do
        expect(donation).to be_valid
      end
    end

    context "when an attribute within one of the models is invalid" do
      let(:state) { "JJ" }
      it "should not be valid" do
        expect(donation).not_to be_valid
      end
    end
  end

  describe "sub model instantiation" do
    describe "donation line items" do
      it "should instantiate a donation_line_item object for each item in the donation_line_items array " do
        dli = NfgRestClient::DonationLineItem.new
        dli.expects(:valid?).twice.returns(true)
        NfgRestClient::DonationLineItem.expects(:new).times(donation_attributes_hash["donation_line_items"].count).returns(dli)
        donation.valid?
      end
    end

    describe "CreditCardPayment" do
      context "when the payment method is a credit card" do
        it "should instantiate a credit card payment record" do
          cc = NfgRestClient::CreditCardPayment.new
          cc.expects(:valid?).returns(true)
          NfgRestClient::CreditCardPayment.expects(:new).once.returns(cc)
          donation.valid?
        end
      end

      context "when the payment method is a card on file" do
        let(:changes_to_attributes) { { "payment" => card_on_file_payment } }

        it "should instantiate a card on file payment record" do
          cc = NfgRestClient::CardOnFilePayment.new
          cc.expects(:valid?).returns(true)
          NfgRestClient::CardOnFilePayment.expects(:new).once.returns(cc)
          donation.valid?
        end
      end
    end
  end

end