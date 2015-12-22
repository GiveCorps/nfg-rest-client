# In some cases, we want to be able to generate the api request headers and body
# without making the call to the api. This not only allows us to inspect these
# values separately, but also use services such as Spreedly's Payment Method Distribution

module Flexirest

  class Request

    # Extracts and combines methods from #call and #do_request
    # Does not include logic to handle "fakes"
    def prepare_request
      @explicit_parameters = nil
      @body = nil
      prepare_params
      prepare_url
      if object_is_class?
        @object.send(:_filter_request, :before, @method[:name], self)
      else
        @object.class.send(:_filter_request, :before, @method[:name], self)
      end
      append_get_parameters
      prepare_request_body
      self.original_url = self.url
      http_headers = {}
      http_headers["Accept"] = "application/hal+json, application/json;q=0.5"
      headers.each do |key,value|
        value = value.join(",") if value.is_a?(Array)
        http_headers[key] = value
      end
    end
  end


  class Base
    def prepare_request(method_name)
      mapped = self.class._mapped_method(method_name.to_sym)
      request = Request.new(mapped, self, nil)
      request.prepare_request
      request
    end
  end
end