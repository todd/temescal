module Temescal
  class Middleware
    def initialize(app, &block)
      @app = app
      yield(configuration) if block
    end

    def call(env)
      begin
        @status, @headers, @response = @app.call(env)
      rescue => error
        raise if configuration.raise_errors?

        @error = error
        $stderr.print formatted_error

        @status   = @error.respond_to?(:http_status) ? @error.http_status : 500
        @headers  = {"Content-Type" => "application/json"}
        @response = Temescal::Response.build(@status, @error)
      end
      [@status, @headers, @response]
    end

    private

    def configuration
      @_configuration ||= Configuration.new
    end

    def formatted_error
      message = "\n#{@error.class}: #{@error.message}\n  "
      message << @error.backtrace.join("\n  ")
      message << "\n\n"
    end
  end
end
