module NfgRestClient
  class Base < Flexirest::Base
    include Configuration
    self.base_url = base_nfg_url

    def initialize(args = {})
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
  end
end