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

    @@plugins_paths = ["#{::File.dirname(__FILE__)}/plugins"]

    def self.plugins_paths
      @@plugins_paths
    end

    def self.require_plugins
      plugins_paths.each do |plugin_path|
        Dir["#{plugin_path}/*.rb"].each {|f| require f}
      end
    end

    def self.add_plugins plugins
      plugins.each do |plugin|
        begin
          eval "include Rack::TrackerPlugin::#{plugin.camelize}"
        rescue NameError => e
          raise TrackerPlugin::NotFound.new e
        end
      end
    end

    def self.plugins
      included_plugins.collect do |plugin|
        plugin.to_s.split('::').last.underscore
      end
    end

    def self.available_plugins
      found_objects = Rack::TrackerPlugin.constants
      modules = found_objects.delete_if { |plugin| eval("Rack::TrackerPlugin::#{plugin}").is_a? Class }
      modules.collect { |plugin| plugin.to_s.underscore }.sort
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
