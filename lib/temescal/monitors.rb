module Temescal

  # Public: Collection of reporting strategies for different monitoring
  # services.
  module Monitors

    # Public: Abstract strategy for monitor reporting strategies.
    class MonitorsStrategy
      # Raises NotImplementedError
      def self.report(exception)
        raise NotImplementedError
      end
    end

    # Public: Reporting strategy for Airbrake.
    class Airbrake < MonitorsStrategy
      # Public: Reports an exception to Airbrake.
      #
      # exception - The caught exception.
      def self.report(exception)
        ::Airbrake.notify exception
      end
    end

    # Public: Reporting strategy for New Relic.
    class NewRelic < MonitorsStrategy
      # Public: Reports an exception to New Relic.
      #
      # exception - The caught exception.
      def self.report(exception)
        ::NewRelic::Agent.notice_error exception
      end
    end

    # Public: Reporting strategy for Bugsnag.
    class Bugsnag < MonitorsStrategy
      # Public: Reports an exception to Bugsnag.
      #
      # exception - The caught exception.
      def self.report(exception)
        ::Bugsnag.notify exception
      end
    end

    # Public: Reporting strategy for Honeybadger.
    class Honeybadger < MonitorsStrategy
      # Public: Reports an exception to Honeybadger.
      #
      # exception - The caught exception.
      def self.report(exception)
        ::Honeybadger.notify exception
      end
    end
  end
end
