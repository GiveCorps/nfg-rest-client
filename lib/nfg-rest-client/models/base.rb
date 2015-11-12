module NfgRestClient
  class Base < Flexirest::Base
    include Configuration
    self.request_body_type = :json

    def initialize(attrs={})
      super
      self.userid = self.class.userid
      self.source = self.class.source
    end

    def call_duration
      callDuration
    end

    def error_details
      errorDetails
    end

    private

  end
end