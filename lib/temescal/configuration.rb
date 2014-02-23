module Temescal
  class Configuration

    # Public: Getter for monitors array.
    attr_reader :monitors

    # Public: Getter for ignored errors array.
    attr_reader :ignored_errors

    # Public: Setter for raise_errors option.
    attr_writer :raise_errors

    # Public: Setter for meta_key option.
    attr_writer :meta_key

    # Public: Getter/Setter for default JSON message.
    attr_accessor :default_message

    # Public: Initializes configuration and monitors option.
    #
    # Returns a new Configuration object.
    def initialize
      @monitors = []
      @ignored_errors = []
    end

    # Public: Setter for monitors option.
    #
    # monitors - Zero or more Symbols representing monitoring services
    #            supported by Temescal.
    #
    # Raises NameError if a monitor Symbol is invalid.
    def monitors=(*monitors)
      monitors.flatten.each do |monitor|
        monitor = camelize_symbol(monitor)
        @monitors << Temescal::Monitors.const_get(monitor)
      end

    rescue NameError => exception
      strategy = exception.message.split(" ").last
      raise NameError.new("#{strategy} is not a valid monitoring strategy")
    end

    # Public: Getter for raise_errors.
    #
    # Returns true if raise_errors is configured to true or the application is
    # running in a test environment, false otherwise.
    def raise_errors?
      @raise_errors == true || ENV["RACK_ENV"] == "test"
    end

    # Public: Setter for ignored_errors option.
    #
    # errors - Zero or more Exception classes.
    def ignored_errors=(*errors)
      @ignored_errors = errors.flatten
    end

    # Public: Getter for meta_key option.
    #
    # Returns the meta_key option or simply "meta" if null.
    def meta_key
      @meta_key || "meta"
    end

    private

    # Private: Converts a snake cased Symbol to a camel cased String.
    #
    # Returns the converted String.
    def camelize_symbol(symbol)
      symbol.to_s.split(/_/).map { |word| word.capitalize }.join
    end
  end
end
