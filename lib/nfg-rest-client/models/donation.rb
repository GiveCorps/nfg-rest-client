module NfgRestClient
  class Donation < BaseTransaction

    verbose! # comment this out or set to false to turn off verbose reporting
    self.base_url base_nfg_service_url


    def initialize(attrs={})
      # convert all keys to camelcase with leading lowercase character
      attrs.deep_transform_keys!{ |key| key.to_s.camelcase(:lower) }
      super
      # self.donationLineItems = [{"wow" => "this"}]
      self.donationLineItems = instantiate_donation_line_items(self.donationLineItems)
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

      donation_line_items.each_with_index do |donation_line_item_hash, index|
        donation_line_item = NfgRestClient::DonationLineItem.new(donation_line_item_hash)
        if !donation_line_item.valid?
          object._errors[field_name] << "record #{ index } returned the following errors #{ donation_line_item.full_error_messages }"
        end
      end
    end

    post :create, '/donation'

    private

    def instantiate_donation_line_items(donation_line_items)
      return unless donation_line_items
      donation_line_items.map do |donation_line_item_hash|
        NfgRestClient::DonationLineItem.new(donation_line_item_hash)
      end
    end
  end
end