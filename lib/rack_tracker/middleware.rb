require 'rack_tracker/caller'
#
# This middleware is the basis of all tracking via rack middleware.
#
# It allows you to easily create your own tracker and simply plugin it into Rack::Tracker allowing you to gain
# valuable information on the service you are currently running.
#
module Rack
  module Tracker
    class Middleware
      include Rack::Caller
    end
  end
end

