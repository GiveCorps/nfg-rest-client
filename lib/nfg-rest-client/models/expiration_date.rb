module NfgRestClient
  class ExpirationDate < Flexirest::Base
    validates :month, presence: true, numericality: { minimum: 1, maximum: 12 }
    validates :year, presence: true, numericality: { minimum: Time.now.year, maximum: (Time.now.year + 20) }
  end
end