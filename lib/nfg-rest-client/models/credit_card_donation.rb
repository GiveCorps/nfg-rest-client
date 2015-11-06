module NfgRestClient
  class CreditCardDonation < NfgRestClient::TransactionBase
    validates :donationLineItems, presence: true

    post :create 'donation'
  end
end