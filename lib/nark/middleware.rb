#
# This middleware is the basis of all tracking via rack middleware.
#
# It allows you to easily create your own tracker and simply plugin it into Nark allowing you to gain
# valuable information on the service you are currently running.
#
module Nark
  class Middleware
    #
    # Set the application to an instance variable.
    #
    # This is needed to allow Rack to call our middleware simply by
    # use the module.
    #
    def initialize app
      @app = app
    end

    #
    # Call our middleware
    #
    # This is called by Rack when the Module is included in an application.
    #
    # This is where events are triggered if any are defined within a custom
    # plugin.
    #
    def call env
      trigger_hook :before_call, env
      status, header, body = @app.call env
      trigger_hook :after_response, [status, header, body, env]
      trigger_hook :after_call, env
      [status, header, body]
    end

    #
    # Triggers an event.
    #
    # This is used internally to determine whether there are any events to be
    # triggered.
    #
    def trigger_hook hook, env
      before_hooks = self.class.events.select do |listener|
        listener[:hook].to_sym == hook.to_sym
      end
      before_hooks.each do |before_hook|
        Nark.class_eval 'before_hook[:plugin_method].call env'
      end
    end

    class << self
      #
      # Keeps tracks of the events to be triggered.
      #
      @@events = []

      #
      # Accessor for the events class instance
      #
      def events
        @@events
      end

      #
      # Setter for the events class instance
      #
      def events= value
        @@events = value
      end
    end
  end
end
