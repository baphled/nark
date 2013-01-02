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
        trigger_hook :before_call, env
        response = @app.call env
        trigger_hook :after_call, env
        response
      end

      def trigger_hook hook, env
        before_hooks = Rack::Tracker.listeners.select do |listener|
          listener[:hook].to_sym == hook.to_sym
        end
        before_hooks.each do |before_hook|
          Rack::Tracker.class_eval 'before_hook[:plugin_method].call env'
        end
      end
    end

    def self.included(receiver)
      receiver.extend         ClassMethods
      receiver.send :include, InstanceMethods
    end
  end
end
