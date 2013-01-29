require_relative 'plugin/events'
#
# This middleware is the basis of all tracking via rack middleware.
#
# It allows you to easily create your own tracker and simply plugin it into Nark allowing you to gain
# valuable information on the service you are currently running.
#
module Nark
  class Middleware
    #
    # Keep trap of the event Handlers
    #
    # Also make it easier to handle our changes
    #
    attr_accessor :event_handler

    #
    # Stores the application that the middle ware will call
    #
    attr_accessor :app

    #
    # Set the application to an instance variable.
    #
    # This is needed to allow Rack to call our middleware simply by
    # use the module.
    #
    def initialize app, options = {}
      defaults = { event_handler: Nark::Plugin }
      options = defaults.merge options
      @app = app
      @event_handler = options[:event_handler]
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
      event_handler.trigger :before_call, env
      status, header, body = app.call env
      event_handler.trigger :after_call, [status, header, body, env]
      [status, header, body]
    end

    #
    # Run the application with Nark and its reporters
    #
    def self.with app
      Rack::Builder.new do
        Nark.reporters.each do |reporter|
          use reporter
        end
        use Nark::Middleware
        run app
      end
    end
  end
end
