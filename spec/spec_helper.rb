$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'nfg-rest-client'

def validate_presence_of(obj, attribute)
  obj.send("#{attribute}=", nil)
  obj.valid?
  expect(obj.errors.try(:[], attribute)).to include("must be present"), "expected #{attribute} to not be valid when nil"
end
