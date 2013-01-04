module Rack::Tracker::Plugins
  module RequestTimes
    module ClassMethods
      @@last_request_time = nil
      @@request_times = []

      def last_request_time
        @@last_request_time
      end

      def last_request_time= time
        @@last_request_time = time
      end

      def request_times
        @@request_times
      end
    end

    def self.included(receiver)
      receiver.extend         ClassMethods
    end
  end
end
