module NfgRestClient
  class Base < Flexirest::Base
    include Configuration
    self.request_body_type = :json

    def initialize(attrs={})
      super
      self.source = self.class.source
    end

    def call_duration
      callDuration
    end

    def error_details
      errorDetails
    end

    def full_error_messages
      return "" unless errors.present?
      errors.reduce([]) do |memo, (field, error)|
        memo << "#{field.to_s} #{error}"
      end
    end

    private

  end
end