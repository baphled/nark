module Rack::Tracker::Plugins
  module Requests
    module ClassMethods
      @@total_requests = 0

      def total_requests
        @@total_requests
      end

      def increment_requests
        @@total_requests += 1
      end
    end

    Rack::Tracker.add_hook :before_call do |env|
      Rack::Tracker.increment_requests
    end

    def self.included(receiver)
      receiver.extend ClassMethods
    end
  end
end
