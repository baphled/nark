module Rack::TrackerPlugin
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
  
    module InstanceMethods
      def before_call env
        self.class.increment_requests
      end
    end

    def self.included(receiver)
      receiver.extend         ClassMethods
      receiver.send :include, InstanceMethods
    end
  end
end
