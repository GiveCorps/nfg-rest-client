class FaradayResponseMock < ::Flexirest::FaradayResponseProxy
  # The FaradayResponseMock is setup to automatically resolve all calls by default.
  # By setting auto_resolve to false it allows the spec to control when the response
  # is resolved, which simulates what it is like when inside a Faraday in_parallel block.
  def initialize(response, auto_resolve=true)
    super(response)
    @auto_resolve = auto_resolve
    @finished = false
  end

  def on_complete
    if @auto_resolve
      @finished = true
      yield(@response)
    else
      @callback = Proc.new
    end
  end

  # This is exactly what is called on responses after a Faraday in_parallel block ends.
  # This method simulates the end of in_parallel block.
  def finish
    @finished = true
    @callback.call(@response)
  end

  def finished?
    @finished
  end
end