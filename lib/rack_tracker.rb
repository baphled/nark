require "active_support/core_ext"

require 'rack_tracker/middleware'
require 'rack_tracker/exceptions'
require 'rack_tracker/plugin'

#
# This middleware is the basis of all tracking via rack middleware.
#
# It allows you to easily create your own tracker and simply plugin it into Rack::Tracker allowing you to gain
# valuable information on the service you are currently running.
#
module Rack
  module Tracker
    include Rack::Tracker::Plugin
  end
end
