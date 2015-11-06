module NfgRestClient
  class CreditCardDonation < BaseTransaction
    validates :donationLineItems, presence: true

    post :create, 'donation'
  end
end