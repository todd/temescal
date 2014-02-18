module Temescal
  class Error
    NOT_FOUND_ERRORS = %w(ActiveRecord::RecordNotFound Sinatra::NotFound)

    # Public: Instantiates a new Error.
    #
    # exception - The raw exception being rescued.
    #
    # Returns a new Error.
    def initialize(exception)
      @exception = exception
    end

    # Public: Determines whether to use a default message (as specified in the
    # configuration) or the exception's message for the API response.
    #
    # Returns a String that's either the default message or the exception's
    # message.
    def message
      configuration.default_message || @exception.message
    end

    # Public: Determines the proper error code for the exception.
    #
    # Returns a Fixnum based on the exception's type and http_status
    # attribute (if applicable), will return a generic 500 for all others.
    def status
      return 404 if NOT_FOUND_ERRORS.include? @exception.class.to_s
      @exception.respond_to?(:http_status) ? @exception.http_status : 500
    end

    # Public: Formats the exception for logging.
    #
    # Returns a String containing the relevant exception information to log
    # via STDERR.
    def formatted
      message = "\n#{@exception.class}: #{@exception.message}\n  "
      message << @exception.backtrace.join("\n  ")
      message << "\n\n"
    end

    # Public: Gets the exception's type.
    #
    # Returns a String representing the exception class name.
    def type
      @exception.class.to_s
    end

    # Public: Determines whether an exception should be silenced.
    #
    # Returns true if the error type is configured as an ignored error, false
    # otherwise.
    def ignore?
      configuration.ignored_errors.each do |error|
        return true if @exception.is_a? error
      end

      false
    end

    private

    # Private: Getter for Temescal configuration.
    def configuration
      $_temescal_configuration
    end
  end
end
