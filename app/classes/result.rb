class Result
  attr_reader :value
  attr_reader :error
  attr_reader :code

  def initialize(succeeded: true, value: nil, error: nil, code: nil)
    @succeeded = succeeded
    @value = value
    @error = error
    @code = code
  end

  def self.success value=nil
    return Result.new value: value
  end

  def self.failure error=nil, code=nil
    return Result.new succeeded: false, error: error, code: code
  end

  def succeeded?
    return @succeeded == true
  end

  def successful?
    return succeeded
  end

  def failed?
    return @succeeded != true
  end

  def print_errors
    error = ""
    error = "#{@code.to_s}: " if @code != nil
    error += @error.to_s
  end
end
