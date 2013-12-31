require 'json'

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
        logger = configuration.logger
        logger.fatal(formatted_error(error))

        @status = 500
        @headers = {"Content-Type" => "application/json"}
        @response = build_response(error)
      end
      [@status, @headers, @response]
    end

    private

    def formatted_error(error)
      message = "\n#{error.inspect}\n  "
      message << error.backtrace.join("\n  ")
      message << "\n\n"
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
