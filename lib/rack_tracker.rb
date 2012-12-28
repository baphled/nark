require "active_support/core_ext"
require 'plugins/request_tracker'
require 'caller'

#
# This middleware is the basis of all tracking via rack middleware.
#
# It allows you to easily create your own tracker and simply plugin it into Rack::Tracker allowing you to gain
# valuable information on the service you are currently running.
#
module Rack
  class Tracker
    # FIXME: I want a nice way to be able to include custom plugins, this won't do
    include Rack::TrackerPlugin::Requests
    include Rack::Caller

    def self.plugins
      included_plugins.collect do |plugin|
        plugin.to_s.split('::').last.downcase
      end
    end

    protected

    def self.included_plugins
      ancestors.select do |module_name|
        module_name.to_s =~ /Rack::TrackerPlugin::[[:alnum:]]+$/
      end
    end
  end
end
