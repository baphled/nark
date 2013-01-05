#
# This middleware is the basis of all tracking via rack middleware.
#
# It allows you to easily create your own tracker and simply plugin it into Rack::Tracker allowing you to gain
# valuable information on the service you are currently running.
#
module Rack
  module Tracker
    class Middleware
      def initialize app
        @app = app
      end

      def call env
        trigger_hook :before_call, env
        response = @app.call env
        trigger_hook :after_call, env
        response
      end

      def trigger_hook hook, env
        before_hooks = self.class.listeners.select do |listener|
          listener[:hook].to_sym == hook.to_sym
        end
        before_hooks.each do |before_hook|
          Rack::Tracker.class_eval 'before_hook[:plugin_method].call env'
        end
      end

      class << self
        @@listeners = []

        def listeners
          @@listeners
        end

        def listeners= value
          @@listeners = value
        end
      end
    end
  end
end

