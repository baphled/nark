module Nark
  module Configuration
    PLUGIN_DESTINATION = 'lib/nark/plugin'.freeze
    PLUGIN_PATH = 'plugins'.freeze

    class << self
      attr_accessor :settings
      attr_accessor :plugins_paths, :plugin_destination

      #
      # Returns paths to find all the plugins
      #
      #        
      def plugins_paths
        settings.fetch('plugins_paths', PLUGIN_PATH)
      end

      def plugin_destination
        settings.fetch('plugin_destination', PLUGIN_DESTINATION)
      end

      def settings
        begin
          settings ||= YAML.load_file File.absolute_path Nark.settings_path
        rescue
          {}
        end
      end
    end
  end
end
