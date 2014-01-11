module Temescal
  module Monitors
    class NewRelic
      def self.report(exception)
        ::NewRelic::Agent.notice_error exception
      end
    end
  end
end