module Rack
  class Tracker
    class << self
      @@total_requests = 0

      def total_requests
        @@total_requests
      end
    end

    def initialize app
      @app = app
    end

    def call env
      @@total_requests += 1
      @app.call env
    end
  end
end
