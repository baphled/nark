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

    module InstanceMethods
      attr_accessor :start_time

      def before_call env
        @start_time = Time.now
      end

      def after_call env
        request_time = (Time.now - @start_time)
        self.class.last_request_time = request_time
        self.class.request_times << {:url => env['PATH_INFO'], :request_time => request_time}
      end
    end

    def self.included(receiver)
      receiver.extend         ClassMethods
      receiver.send :include, InstanceMethods
    end
  end
end
