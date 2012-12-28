require "active_support/core_ext"
require 'plugins'
require 'caller'
require 'exceptions'

#
# This middleware is the basis of all tracking via rack middleware.
#
# It allows you to easily create your own tracker and simply plugin it into Rack::Tracker allowing you to gain
# valuable information on the service you are currently running.
#
module Rack
  class Tracker
    include Rack::Caller
    include Rack::TrackerPlugins

    class << self
      def configure
        yield self
        true
      end
    end
  end
end
