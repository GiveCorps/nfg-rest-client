module NfgRestClient::ValidationHelpers
  def validate_presence_of(obj, attribute)
    obj.send("#{attribute}=", nil)
    obj.valid?
    expect(obj.errors.try(:[], attribute)).to include("must be present"), "expected #{attribute} to not be valid when nil"
  end

  def validate_inclusion_of(obj, attribute, options)
    raise "an options hash containing an :in value that is an array must be included when using validate_inclusion_of" unless (options[:in] && options[:in].is_a?(Array))
    inclusion_array = options[:in]
    validation_inclusion_array = obj.class._validations.
                                  select {|v| v[:field_name] == attribute.to_sym && v[:options].try(:[], :inclusion).present? }.
                                  first[:options][:inclusion][:in] rescue []
    expect(inclusion_array).to eq(validation_inclusion_array), "expected the inclusion array to match [#{ inclusion_array.join(', ') }], got [#{ validation_inclusion_array.try(:join, ', ') }]"
    obj.send("#{attribute}=", Time.now.to_s)
    obj.valid?
    expect(obj.errors.try(:[], attribute)).to include("must be included in #{ inclusion_array.join(", ") }"), "expected #{attribute} to be invalid when not included in [#{ options[:in].join(', ') }]"
    inclusion_array.each do |elem|
      obj.send("#{attribute}=", elem)
      obj.valid?
      expect(obj.errors.try(:[], attribute)).to be_blank, "expected #{attribute} to be valid when set to one of #{ inclusion_array.join(', ')}"
    end
  end

  def validate_numericality_of(obj, attribute, options = {})
    obj.send("#{ attribute }=", 'baz')
    obj.valid?
    expect(obj.errors.try(:[], attribute)).to include("must be numeric"), "expected #{attribute} to be invalid when not numeric"

    if options[:minimum]
      obj.send("#{ attribute }=", options[:minimum].to_f - 0.0000000001)
      obj.valid?
      expect(obj.errors.try(:[], attribute)).to include("must be at least #{options[:minimum]}"), "expected #{attribute} to be invalid when less than #{options[:minimum]}"
    end

    if options[:maximum]
      obj.send("#{ attribute }=", options[:maximum].to_f + 0.0000000001)
      obj.valid?
      expect(obj.errors.try(:[], attribute)).to include("must be no more than #{options[:maximum]}"), "expected #{attribute} to be invalid when more than #{options[:maximum]}"
    end
  end
end