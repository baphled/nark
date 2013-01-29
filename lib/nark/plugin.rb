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
    # The Command Line Interface for Nark
    #
    # TODO: This doesn't really belong here. Should move it to a better home.
    #
    include CLI

    #
    # Handles the events that will be triggered
    #
    include Events

    #
    # All of these methods are mixed into the Nark module and made part of it's public API.
    #
    # TODO: Review this functionality, It may make more sense to make these class methods of the plugin module.
    #
    class << self
      @@defined_methods = []

      def defined_methods
        @@defined_methods
      end
    end

    module ClassMethods
      protected

      #
      # Keeps track of the paths to that we can find plugins in
      #
      @@settings_path = 'config/nark.yml'

      public

      def settings_path
        @@settings_path
      end

      def settings_path= settings_path
        @@settings_path = settings_path
      end

      #
      # Returns a list of plugins that are currently attached
      #
      # Figures out what plugins are setup and returns a list of them
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

      #
      # Stores the path of the plugins
      #
      # TODO: Refactor so that it takes a single path and checks to see if it is valid
      #
      def defined_plugin_path
        File.absolute_path File.join File.dirname(__FILE__), "..", "..", Nark::Configuration.plugins_paths
      end

      protected

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
