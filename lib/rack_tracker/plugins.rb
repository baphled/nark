module Rack
  module Tracker
    module Plugins
      module ClassMethods
        # FIXME: This is pretty brittle should find a better way of
        # storing the path of the plugins
        @@plugins_paths = ["#{::File.dirname(__FILE__)}/../plugins"]
        @@listeners = []

        def listeners
          @@listeners
        end

        def listeners= value
          @@listeners = value
        end

        def plugins_paths
          @@plugins_paths
        end

        def add_plugins plugins
          plugins.each do |plugin|
            begin
              find_and_require_plugin plugin
            rescue NameError => e
              raise TrackerPlugin::NotFound.new e
            end
          end
        end

        def plugins
          included_plugins.collect do |plugin|
            plugin.to_s.split('::').last.underscore
          end.sort
        end

        def available_plugins
          found_objects = Rack::Tracker::Plugins.constants
          modules = found_objects.delete_if do |plugin|
            eval("Rack::Tracker::Plugins::#{plugin}").is_a? Class or ignored_modules.include? plugin.to_s.camelize
          end
          modules.collect { |plugin| plugin.to_s.underscore }.sort
        end

        def add_plugin_path path
          @@plugins_paths << path
        end

        def included_plugins
          ancestors.select do |module_name|
            name = module_name.to_s.split('::').last
            module_name.to_s =~ /Rack::Tracker::Plugins::[[:alnum:]]+$/ and not ignored_modules.include? name
          end
        end

        def ignored_modules
          ['ClassMethods','InstanceMethods']
        end
        protected

        def find_and_require_plugin plugin
          plugins_paths.each do |plugin_path|
            if ::File.exists? "#{plugin_path}/#{plugin}.rb"
              require "#{plugin_path}/#{plugin}"
              eval "include Rack::Tracker::Plugins::#{plugin.to_s.camelize}"
            end
          end
        end
      end

      def self.included(receiver)
        receiver.extend         ClassMethods
      end
    end
  end
end
