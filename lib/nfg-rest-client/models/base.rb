module NfgRestClient
  class Base < ObjectBase
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

    private

  end
end