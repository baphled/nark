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

    Rack::Tracker.add_hook :before_call do |env|
      Rack::Tracker.total_requests += 1
    end

    def self.included(receiver)
      receiver.extend ClassMethods
    end
  end
end
