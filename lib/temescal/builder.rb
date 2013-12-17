module Temescal
  class Builder
    def initialize(app, &block)
      @app = app
      yield(configuration)
    end

    def configuration
      @_configuration ||= Configuration.new
    end

    def call(env)
      begin
        @status, @headers, @response = @app.call(env)
      rescue => error
        configuration.logger.error(error.inspect)
        configuration.logger.error(formatted_backtrace(error.backtrace))

        @status = 500
        @headers = {"Content-Type" => "application/json"}
        @response = build_response(error)
      end
      [@status, @headers, @response]
    end

    private

    def formatted_backtrace(backtrace)
      backtrace.inject("") do |string, line|
        string << "    #{line}\n"
      end
    end

    def build_response(error)
      [
        {
          meta: {
            status:  @status,
            error:   error.class.to_s,
            message: error.message
          }
        }.to_json
      ]
    end
  end

  class Configuration
    attr_accessor :logger
  end
end
