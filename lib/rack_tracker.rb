require "active_support/core_ext"
require 'plugins'
require 'caller'

# FIXME: These need to be automatically required. Remove once done
require 'plugins/requests'
require 'plugins/request_times'

#
# This middleware is the basis of all tracking via rack middleware.
#
# It allows you to easily create your own tracker and simply plugin it into Rack::Tracker allowing you to gain
# valuable information on the service you are currently running.
#
module Rack
  class Tracker
    include Rack::Caller

    @@plugins_paths = ["#{::File.dirname(__FILE__)}/plugins"]

    def self.plugins_paths
      @@plugins_paths
    end

    def self.add_plugins plugins
      plugins.each do |plugin|
        eval "include Rack::TrackerPlugin::#{plugin.camelize}"
      end
    end

    def self.plugins
      included_plugins.collect do |plugin|
        plugin.to_s.split('::').last.underscore
      end
    end

    def self.available_plugins
      Rack::TrackerPlugin.constants.collect { |plugin| plugin.to_s.underscore }.sort
    end

    def self.add_plugin_path path
      @@plugins_paths << path
    end

    protected

    def self.included_plugins
      ancestors.select do |module_name|
        module_name.to_s =~ /Rack::TrackerPlugin::[[:alnum:]]+$/
      end
    end
  end
end
