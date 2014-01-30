module Temescal
  class Middleware
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
      rescue => exception
        raise if configuration.raise_errors?

        error = Error.new(exception)

        unless configuration.ignored_errors.include? exception.class
          $stderr.print error.formatted
          configuration.monitors.each { |monitor| monitor.report(exception) }
        end

        @status   = error.status
        @response = Response.build(error)
        @headers  = { "Content-Type" => "application/json" }
      end
      [@status, @headers, @response]
    end

    private

    # Private: Getter for Temescal configuration.
    def configuration
      $_temescal_configuration ||= Configuration.new
    end
  end
end
