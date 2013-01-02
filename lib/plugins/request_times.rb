module Rack::Tracker::Plugins
  module RequestTimes
    module ClassMethods
      @@last_request_time = nil
      @@request_times = []

      def last_request_time
        @@last_request_time
      end

      def request_times
        @@request_times
      end

      def last_request_time= time
        @@last_request_time = time
      end
    end

    Rack::Tracker.add_hook :before_call do |env|
      @start_time = Time.now
    end

    Rack::Tracker.add_hook :after_call do |env|
      request_time = (Time.now - @start_time)
      Rack::Tracker.last_request_time = request_time
      Rack::Tracker.request_times << {:url => env['PATH_INFO'], :request_time => request_time}
    end

    def self.included(receiver)
      receiver.extend         ClassMethods
    end
  end
end
