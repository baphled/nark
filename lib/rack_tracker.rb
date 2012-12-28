require 'request_tracker'

#
# This middleware is the basis of all tracking via rack middleware.
#
# It allows you to easily create your own tracker and simply plugin it into Rack::Tracker allowing you to gain
# valuable information on the service you are currently running.
#
module Rack
  class Tracker
    # FIXME: I want a nice way to be able to include custom plugins, this won't do
    include Rack::RequestTracker

    def initialize app
      @app = app
    end

    def call env
      pre_call env if respond_to? :pre_call
      @app.call env
    end
  end
end
