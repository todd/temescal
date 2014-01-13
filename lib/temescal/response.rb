require 'json'

module Temescal
  module Response

    # Public: Builds a response body for the Rack response.
    #
    # status    - The HTTP status code of the response.
    # exception - The caught exception.
    # message   - The error message.
    #
    # Returns an Array containing a JSON string as the response body.
    def self.build(status, exception, message)
      [
        {
          meta: {
            status:  status,
            error:   exception.class.to_s,
            message: message
          }
        }.to_json
      ]
    end
  end
end
