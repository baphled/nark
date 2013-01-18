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
      Nark::Plugin.trigger :before_call, env
      status, header, body = @app.call env
      Nark::Plugin.trigger :after_call, [status, header, body, env]
      [status, header, body]
    end
  end
end
