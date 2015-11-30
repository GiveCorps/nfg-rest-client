module NfgRestClient
  class ObjectBase < Flexirest::Base
    def initialize(attrs={})
      # convert all keys to camelcase with leading lowercase character
      attrs.deep_transform_keys!{ |key| key.to_s.camelcase(:lower) }
      super
    end
  end
end