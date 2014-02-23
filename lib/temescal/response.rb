require "json"

module Temescal
  module Response

    # Public: Builds a response body for the Rack response.
    #
    # error - The Temescal::Error object representing the caught exception.
    #
    # Returns an Array containing a JSON string as the response body.
    def self.build(error)
      [
        {
          $_temescal_configuration.meta_key => {
            status:  error.status,
            error:   error.type,
            message: error.message
          }
        }.to_json
      ]
    end
  end
end
