module Temescal
  module Monitors
    class MonitorsStrategy
      def self.report(exception)
        raise NotImplementedError
      end
    end

    class Airbrake < MonitorsStrategy
      def self.report(exception)
        ::Airbrake.notify exception
      end
    end

    class NewRelic < MonitorsStrategy
      def self.report(exception)
        ::NewRelic::Agent.notice_error exception
      end
    end
  end
end
