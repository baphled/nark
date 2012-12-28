require 'plugins/request_tracker'

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
      before_call env
      @app.call env
    end

    def before_call env
      super
    end
  end
end
