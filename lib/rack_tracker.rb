require "active_support/core_ext"
require 'plugins'
require 'plugins/requests'
require 'caller'

#
# This middleware is the basis of all tracking via rack middleware.
#
# It allows you to easily create your own tracker and simply plugin it into Rack::Tracker allowing you to gain
# valuable information on the service you are currently running.
#
module Rack
  class Tracker
    include Rack::Caller

    def self.add_plugins plugins
      plugins.each do |plugin|
        include eval "Rack::TrackerPlugin::#{plugin.camelize}"
      end
    end

    def self.plugins
      included_plugins.collect do |plugin|
        plugin.to_s.split('::').last.underscore
      end
    end

    def self.available_plugins
      Rack::TrackerPlugin.constants.collect { |plugin| plugin.to_s.underscore }
    end

    protected

    def self.included_plugins
      ancestors.select do |module_name|
        module_name.to_s =~ /Rack::TrackerPlugin::[[:alnum:]]+$/
      end
    end
  end
end
