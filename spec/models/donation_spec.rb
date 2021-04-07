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


  context "when donation items' feeAddOrDeduct are 'Deduct' " do
    context "and the donation total equals the sum of all of the donation items amounts" do
      it "should be valid" do
        expect(subject.send(:calculated_total)).to eq(total_amount.to_f)
        expect(donation.valid?).to be_truthy
      end
    end

    # 2021-04-07 We've removed this validation as the floating point math was returning
    # strange results.
    # context "and the donation total does not equal the sum of all of the donation item amounts" do
    #   let(:total_amount) { "200.00" }
    #   it "should not be valid" do
    #     expect(subject.send(:calculated_total)).not_to eq(total_amount.to_f)
    #     expect(donation.valid?).to be_falsey
    #   end
    # end
  end

  context "when at least one of the donation items' feeAddOrDeduct are 'Add' " do
    let(:add_or_deduct_1) { "Add" }
    let(:add_or_deduct_fee_amount) { "0.75" }
    let(:total_amount) { "100.75" }
    let(:attributes) { donation_attributes("add_or_deduct_fee_amount" => add_or_deduct_fee_amount) }

    context "and the donation total equals the sum of all of the donation items amounts plus the addOrDeductFeeAmount" do
      it "should be valid" do
        expect(subject.send(:calculated_total)).to eq(total_amount.to_f)
        expect(donation.valid?).to be_truthy
      end
    end

    # context "and the donation total does not equal the sum of all of the donation item amounts" do
    #   let(:total_amount) { "200.00" }
    #   it "should not be valid" do
    #     expect(subject.send(:calculated_total)).not_to eq(total_amount.to_f)
    #     expect(donation.valid?).to be_falsey
    #   end
    # end

    context "when the add_or_deduct_fee_amount is 0.6 and the donation line item total is 19.89" do
      let(:attributes) { donation_attributes("add_or_deduct_fee_amount" => "0.60", "donation_line_items" => [full_donation_line_item_attributes.merge("amount" => "19.89")]) }
      # in very specific circumstances, like when the total value of the donation is 19.89 and the total add fee is 0.60, when
      # setting the strings to floats, and adding them together we get odd values, like 20.4900000002. We need to floor the values
      # to ensure that we can properly compare them. This spec was to ensure that that floor worked.
      context 'and the donation total equals the sum of all of the donation item amounts plus the addOrDeductFeeAmount' do
        let(:total_amount) { "20.49" }

        it 'is valid' do
          expect(donation.valid?).to be_truthy
        end
      end
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

  describe "#prepare_request" do
    it "should return a formatted request" do
      expect(donation.prepare_request(:create).class).to eq(Flexirest::Request)
    end
  end

end