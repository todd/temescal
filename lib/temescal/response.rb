require 'json'

module Temescal
  module Response
    def self.build(status, error)
      [
        {
          meta: {
            status:  status,
            error:   error.class.to_s,
            message: error.message
          }
        }.to_json
      ]
    end
  end
end
