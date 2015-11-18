module NfgRestClient
  class Donation < Base

    verbose! # comment this out or set to false to turn off verbose reporting
    self.base_url base_nfg_service_url
    

    def initialize(attrs={})
      # convert all keys to camelcase with leading lowercase character
      self.token = self.class.token
      attrs.deep_transform_keys!{ |key| key.to_s.camelcase(:lower) }
      super
    end

    validates :donationLineItems, presence: true
    validates :totalAmount, presence: true
    validates :tipAmount, presence: true
    validates :partnerTransactionId, presence: true
    validates :payment, presence: true

    validates :donationLineItems do |object, field_name, donation_line_items|
      next if donation_line_items.nil? # should be caught by the presence validator
      unless donation_line_items.is_a?(Array)
        object._errors[field_name] << "must be an array"
        next
      end

      if donation_line_items.empty?
        object._errors[field_name] << "must contain at least one record"
        next
      end

      donation_line_items.each_with_index do |donation_line_item, index|
        dli = NfgRestClient::DonationLineItem.new(donation_line_item)
        if !dli.valid?
          object._errors[field_name] << "record #{ index } returned the following errors "
        end
      end


    end

    post :create, '/donation'

    private

  end
end