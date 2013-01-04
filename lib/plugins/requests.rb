module Rack::Tracker::Plugins
  module Requests
    module ClassMethods
      @@total_requests = 0

      def total_requests
        @@total_requests
      end

      def total_requests= number
        @@total_requests += number
      end
    end

    def self.included(receiver)
      receiver.extend ClassMethods
    end
  end
end
