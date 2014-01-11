class Configuration
  attr_reader :monitors
  attr_writer :raise_errors

  def initialize
    @monitors = []
  end

  def monitors=(*monitors)
    monitors.each do |monitor|
      monitor = camelizeSymbol(monitor)
      @monitors << Object.const_get("Temescal::Monitors::#{monitor}")
    end

    # TODO: Rescue from this for bad monitor names?
  end

  def raise_errors?
    @raise_errors == true || ENV["RACK_ENV"] == "test"
  end

  private

  def camelizeSymbol(symbol)
    symbol.to_s.split(/_/).map { |word| word.capitalize }.join
  end
end
