module NfgRestClient
  class Donation < BaseTransaction

    verbose! # comment this out or set to false to turn off verbose reporting

    REQUIRED_ATTRIBUTES = %w{ donation_line_items total_amount tip_amount partner_transaction_id payment}

    def initialize(attrs={})
      attrs.deep_transform_keys!{ |key| key.to_s.camelcase(:lower) }
      # self.class.required_attributes.each do |required_attr|
      #   raise NoMethodError.new("The attributes must include #{required_attr} or #{required_attr.camelcase(:lower)}") unless attrs[required_attr.camelcase(:lower)].present?
      # end
      super
    end

    def self.required_attributes
      REQUIRED_ATTRIBUTES
    end

    validates :donationLineItems, presence: true
    validates :total_amount, presence: true
    validates :tip_amount, presence: true
    validates :partner_transaction_id, presence: true
    validates :payment, presence: true

    post :create, '/donation'

    private

    def validate_arguments

    end

  end
end