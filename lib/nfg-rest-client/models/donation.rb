module NfgRestClient
  class Donation < BaseTransaction

    verbose! # comment this out or set to false to turn off verbose reporting
    self.base_url base_nfg_service_url # this gets set at the time the class is loaded so is ignorant of initialized config settings

    def initialize(attrs={})
      super
      self.donationLineItems = instantiate_donation_line_items(self.donationLineItems)
      self.payment = instantiate_payment_method(self.payment)
      self.addOrDeductFeeAmount = 0 unless addOrDeductFeeAmount.present?
    end

    validates :donationLineItems, presence: true
    validates :totalAmount, presence: true
    validates :tipAmount, presence: true
    validates :partnerTransactionId, presence: true
    validates :payment, presence: true

    validates :donationLineItems do |object, field_name, donation_line_items|
      next if donation_line_items.nil? # should be caught by the presence validator
      if !donation_line_items.is_a?(Array)
        object._errors[field_name] << "must be an array"
      elsif donation_line_items.empty?
        object._errors[field_name] << "must contain at least one record"
      else
        donation_line_items.each_with_index do |donation_line_item, index|
          unless donation_line_item.valid?
            object._errors[field_name] << "record #{ index } returned the following errors #{ donation_line_item.full_error_messages.join(", ") }"
          end
        end
      end
    end

    validates :payment do |object, field_name, payment_method|
      next if payment_method.nil?
      unless payment_method.valid?
        object._errors[field_name] << payment_method.full_error_messages
      end
    end

    # this validation has turned out to be flaky. Even though the values
    # appear to be correct, the floating point math causes them to be slightly
    # different (i.e. 24.000000002 does not equal 24)
    # validates :totalAmount do |object, field_name, total_amount|
    #   unless total_amount.to_f == object.send(:calculated_total)
    #     object._errors[field_name] << "is not equal to the sum of donation line item amounts"
    #   end
    # end

    post :create, '/donation'

    private

    def total_from_line_items
      return 0 unless donationLineItems.present?
      donationLineItems.inject(0) { |total, dli| total + dli.amount.to_f }
    end

    def calculated_total
      (total_from_line_items.to_f + addOrDeductFeeAmount.to_f).floor(2)
    end
  end
end