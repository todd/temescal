module Temescal
  class Configuration
    attr_reader :monitors
    attr_writer :raise_errors

    def initialize
      @monitors = []
    end

    def monitors=(*monitors)
      monitors.flatten.each do |monitor|
        monitor = camelize_symbol(monitor)
        @monitors << Temescal::Monitors.const_get(monitor)
      end

    rescue NameError => exception
      strategy = exception.message.split(" ").last
      raise NameError.new("#{strategy} is not a valid monitoring strategy")
    end

    def raise_errors?
      @raise_errors == true || ENV["RACK_ENV"] == "test"
    end

    private

    def camelize_symbol(symbol)
      symbol.to_s.split(/_/).map { |word| word.capitalize }.join
    end
  end
end
