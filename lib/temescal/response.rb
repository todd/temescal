require 'json'

module Temescal
  module Response
    def self.build(status, error, message)
      [
        {
          meta: {
            status:  status,
            error:   error.class.to_s,
            message: message
          }
        }.to_json
      ]
    end
  end
end
