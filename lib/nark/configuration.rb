require 'yaml'

module Nark
  module Configuration
    PLUGIN_PATH = 'plugins'.freeze
    CONFIG_PATH = 'config/nark.yml'.freeze

    class << self
      #
      # Stores the configuration settings
      #
      attr_accessor :settings

      #
      # Configuration settings can be setting via a YAML file or a config block
      #
      attr_accessor :plugins_path

      #
      # Can only be set via the config block to define the path of the config file
      #
      attr_accessor :settings_path

      #
      # Returns paths to find all the plugins
      #
      #
      def plugins_path
        settings.fetch('plugins_path', PLUGIN_PATH)
      end

      #
      # Sets the path of the configuration file
      #
      # FIXME: Holds state
      #
      def settings_path
        @settings_path.nil? ? CONFIG_PATH : @settings_path
      end

      def settings_path= path
        @settings_path = path
      end

      #
      # Load the configurations if needed and return the value
      #
      # At the configuration file is primarily used along side the CLI so it is
      # not neccessarily needed in all cases.
      #
      # TODO: Review this functionality, not sure it's the best thing to do 
      #
      def settings
        begin
          settings ||= YAML.load_file File.absolute_path Nark.settings_path
        rescue
          {}
        end
      end

      def configure
        yield Nark
        true
      end

      alias_method :config, :configure
    end
  end
end
