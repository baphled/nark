module Rack
  module RequestTimeTracker
    module ClassMethods
      @@last_request_time = nil

      def last_request_time
        @@last_request_time
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
        self.class.last_request_time = (Time.now - @start_time)
      end
    end
  
    def self.included(receiver)
      receiver.extend         ClassMethods
      receiver.send :include, InstanceMethods
    end
  end
end
