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

        @error  = error
        message = configuration.default_message || @error.message

        $stderr.print formatted_error
        configuration.monitors.each { |monitor| monitor.report(@error) }

        @status   = @error.respond_to?(:http_status) ? @error.http_status : 500
        @response = Response.build(@status, @error, message)
        @headers  = { "Content-Type"   => "application/json" }
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
