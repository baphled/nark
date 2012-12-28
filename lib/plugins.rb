module Rack
  module TrackerPlugins
    module ClassMethods
      @@plugins_paths = ["#{::File.dirname(__FILE__)}/plugins"]

      def plugins_paths
        @@plugins_paths
      end

      def require_plugins
        plugins_paths.each do |plugin_path|
          Dir["#{plugin_path}/*.rb"].each {|f| require f}
        end
      end

      def add_plugins plugins
        # FIXME: Should not be requiring all plugins here. Find a better home for it
        require_plugins
        plugins.each do |plugin|
          begin
            eval "include Rack::TrackerPlugin::#{plugin.to_s.camelize}"
          rescue NameError => e
            raise TrackerPlugin::NotFound.new e
          end
        end
      end

      def plugins
        included_plugins.collect do |plugin|
          plugin.to_s.split('::').last.underscore
        end
      end

      def available_plugins
        found_objects = Rack::TrackerPlugin.constants
        modules = found_objects.delete_if { |plugin| eval("Rack::TrackerPlugin::#{plugin}").is_a? Class }
        modules.collect { |plugin| plugin.to_s.underscore }.sort
      end

      def add_plugin_path path
        @@plugins_paths << path
      end

      def included_plugins
        ancestors.select do |module_name|
          module_name.to_s =~ /Rack::TrackerPlugin::[[:alnum:]]+$/
        end
      end
    end

    module InstanceMethods
      def initialize app
        self.class.require_plugins
        super
      end
    end

    def self.included(receiver)
      receiver.extend         ClassMethods
      receiver.send :include, InstanceMethods
    end
  end
end
