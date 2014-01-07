class Configuration
  attr_writer :raise_errors

  def raise_errors?
    @raise_errors == true || ENV["RACK_ENV"] == "test"
  end
end
