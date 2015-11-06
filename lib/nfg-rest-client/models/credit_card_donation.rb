module NfgRestClient
  class CreditCardDonation < TransactionBase
    validates :donationLineItems, presence: true

    post :create, 'donation'
  end
end