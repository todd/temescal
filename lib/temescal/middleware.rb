module Temescal
  class Middleware
    NOT_FOUND_ERRORS = ["ActiveRecord::RecordNotFound", "Sinatra::NotFound"]

    # Public: Initializes the middleware.
    #
    # app   - The Rack application.
    # block - Optional block for configuring the middleware.
    #
    # Returns an instance of the middleware.
    def initialize(app, &block)
      @app = app
      yield(configuration) if block
    end

    # Public: call method for Rack application. Rescues from an exception and
    # does the following: 1) Logs the error 2) Reports error to configured
    # monitoring services 3) Generates a JSON response with error information.
    #
    # env - The environment of the request.
    #
    # Returns an array of response data for Rack.
    def call(env)
      begin
        @status, @headers, @response = @app.call(env)
      rescue => error
        raise if configuration.raise_errors?

        @error  = error
        message = configuration.default_message || @error.message

        $stderr.print formatted_error
        configuration.monitors.each { |monitor| monitor.report(@error) }

        @status   = set_status
        @response = Response.build(@status, @error, message)
        @headers  = { "Content-Type"   => "application/json" }
      end
      [@status, @headers, @response]
    end

    private

    # Private: Getter for middleware configuration.
    def configuration
      @_configuration ||= Configuration.new
    end

    # Private: Formats the exception for logging.
    def formatted_error
      message = "\n#{@error.class}: #{@error.message}\n  "
      message << @error.backtrace.join("\n  ")
      message << "\n\n"
    end

    # Private: Returns the proper error code for the exception.
    def set_status
      return 404 if NOT_FOUND_ERRORS.include? @error.class.to_s
      @error.respond_to?(:http_status) ? @error.http_status : 500
    end
  end
end
