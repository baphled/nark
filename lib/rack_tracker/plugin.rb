require_relative "plugin/dsl"

module Rack
  module Tracker
    module Plugin
      include DSL

      module ClassMethods

        @@listeners = []

        def listeners
          @@listeners
        end

        def listeners= value
          @@listeners = value
        end

        def add_plugins plugins
          plugins.each do |plugin|
            begin
              eval "include Rack::Tracker::Plugin::#{plugin.to_s.camelize}"
            rescue NameError => e
              raise Tracker::Exceptions::PluginNotFound.new e
            end
          end
        end

        def plugins
          included_plugins.collect do |plugin|
            plugin.to_s.split('::').last.underscore
          end.sort
        end

        def available_plugins
          found_objects = Rack::Tracker::Plugin.constants
          modules = found_objects.delete_if do |plugin|
            eval("Rack::Tracker::Plugin::#{plugin}").is_a? Class or ignored_modules.include? plugin.to_s.camelize
          end
          modules.collect { |plugin| plugin.to_s.underscore }.sort
        end

        def included_plugins
          ancestors.select do |module_name|
            name = module_name.to_s.split('::').last
            module_name.to_s =~ /Rack::Tracker::Plugin::[[:alnum:]]+$/ and not ignored_modules.include? name
          end
        end

        def ignored_modules
          ['ClassMethods','InstanceMethods']
        end
      end

      def self.included(receiver)
        receiver.extend         ClassMethods
      end
    end
  end
end
