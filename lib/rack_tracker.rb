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
  module Tracker
    include Rack::Tracker::Plugins

    #
    # All Rack::Tracker class variables are settable via this configuration method.
    #
    # This means that configuration settings are dynamically added dependant on
    # what variables you expose via your plugins to Rack::Tracker.
    #
    # TODO: Refactor so only specific class variables, possibly only setters, are exposed via our plugins.
    #
    class << self
      def configure
        yield Rack::Tracker
        true
      end
    end
  end
end
