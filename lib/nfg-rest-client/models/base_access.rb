module NfgRestClient
  class BaseAccess < Base
    # To be used be all access related classes. 

    self.base_url base_nfg_access_url # pass the url so it is set as a variable on this instance of the class, not on the root class
  end
end