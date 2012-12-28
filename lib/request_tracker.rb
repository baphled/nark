module Rack
  module RequestTracker
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
      def initialize app
        @app = app
      end

      def pre_call env
        self.class.increment_requests
      end
    end

    def self.included(receiver)
      receiver.extend         ClassMethods
      receiver.send :include, InstanceMethods
    end

  end
end
