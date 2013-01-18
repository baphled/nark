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
    include DSL
    include CLI
    include Events

    module ClassMethods
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

      protected

      def filter_modules found_modules
        found_modules.delete_if do |plugin|
          eval("Nark::Plugin::#{plugin}").is_a? Class or ignored_modules.include? plugin.to_s.camelize
        end
      end

      def ignored_modules
        ['ClassMethods','InstanceMethods','DSL']
      end
    end

    def self.included(receiver)
      receiver.extend         ClassMethods
    end
  end
end
