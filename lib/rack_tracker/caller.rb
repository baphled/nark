module Rack
  #
  # The main caller for our middleware.
  #
  # This has been extracted to help with testing and to make it easier to turn __anything__ into a Rack caller
  #
  module Caller
    module ClassMethods
    end

    module InstanceMethods
      def initialize app
        @app = app
      end

      def call env
        before_call env
        response = @app.call env
        after_call env
        response
      end

      #
      # We are not bothered whether the before and after hooks are call or not
      #
      # TODO: It does make sense to fire off a message stating that the hooks have not been used
      #
      def method_missing method, *args, &block
        super unless [:after_call, :before_call].include? method
      end
    end

    def self.included(receiver)
      receiver.extend         ClassMethods
      receiver.send :include, InstanceMethods
    end
  end
end
