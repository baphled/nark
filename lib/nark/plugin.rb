require_relative "plugin/dsl"
require_relative "plugin/cli"

module Nark
  #
  # This is the main Module for the Plugin functionality.
  #
  # It's main functionality is to allow users to easily create their own
  # custom plugins using a simple DSL.
  #
  # It also keeps track of these plugins so that a user can easily figure out
  # what plugins are being used at any given time.
  #
  module Plugin
    #
    # Defines the plugins DSL
    # 
    # Allowing the user to create their own plugins
    #
    include DSL

    #
    # Handles the events that will be triggered
    #
    include Events

    class << self
      #
      # Returns a message with all the defined plugin accessors
      #
      # We intensionally ignore all assignment accessors as they are not needed to be tracked.
      #
      # @TODO: Refactor so that we rely on plugin accessors being added to Nark via an internal module
      #
      def defined_methods
        Nark.available_plugins.map {|plugin| plugin_accessors(plugin) }.flatten.sort
      end

      #
      # Helper methods used to help track which plugin accessors are available.
      #
      # Once we refactoring the architecture so that plugins live in their own namespace these methods will no longer
      # be needed.
      #
      protected

      def plugin_accessors plugin_name
        plugin_class = "Nark::Plugin::#{plugin_name.camelize}::PluginMethods".constantize
        plugin_instance_methods = plugin_class.instance_methods
        plugin_instance_methods.select { |accessor| not accessor.to_s.include? '=' }
      end
    end

    module ClassMethods

      #
      # Returns a list of plugins that are currently attached
      #
      # Figures out what plugins are setup and returns a list of them
      #
      # TODO: Refactor, need to be able to update the ancestor tree when
      # undefining a plugin
      #
      def available_plugins
        found_modules = Nark::Plugin.constants
        modules = filter_modules found_modules
        modules.collect { |plugin| plugin.to_s.underscore }.sort
      end

      #
      # Loads all the plugins from the define plugin path
      #
      # This is used to resolve the issue of having to rely on the user to require the plugin manually.
      #
      # TODO: Refactor so that we can iterate of more than one path
      #
      def load_plugins
        Dir["#{defined_plugin_path}/*.rb"].each { |plugin| eval File.read(plugin) }
      end

      protected

      #
      # Stores the path of the plugins
      #
      # TODO: Refactor so that it takes a single path and checks to see if it is valid
      #
      def defined_plugin_path
        File.absolute_path File.join File.dirname(__FILE__), "..", "..", Nark.plugins_path
      end

      #
      # This is a helper method that returns a list of plugin modules
      #
      # Determines which objects are actually plugin modules are what are not.
      #
      # There are a few modules that we don't want to return that are part of
      # Narks architecture. These are checked for and removed from the list if
      # found.
      #
      # All Nark plugins are modules, so that is the easy part, we check to
      # make sure that the object we currently have is a module.
      #
      def filter_modules found_modules
        found_modules.delete_if do |plugin|
          eval("Nark::Plugin::#{plugin}").is_a? Class or ignored_modules.include? plugin.to_s.camelize
        end
      end

      #
      # Returns a list of modules that we don't want to include when we are
      # filtering our modules.
      #
      # TODO: Improve upon this so that we don't have to add to this every time
      # we add a mixin to the Plugin module.
      #
      def ignored_modules
        ['ClassMethods','InstanceMethods','DSL']
      end
    end

    def self.included(receiver)
      receiver.extend         ClassMethods
    end
  end
end
