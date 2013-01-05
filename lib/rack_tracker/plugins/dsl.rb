module Rack
  module Tracker
    module Plugins
      class DSL
        include Rack::Tracker::Macros

        @@currently_defining = nil

        def initialize plugin_name, &block
          @@currently_defining = plugin_name
          yield Rack::Tracker::DSL
          eval define_plugin_module plugin_name, &block
        end

        class << self
          def add_hook hook, &block
            Rack::Tracker.listeners << {hook: hook, plugin_method: block}
          end

          def currently_defining
            if @@currently_defining.nil?
              raise Rack::Tracker::Exceptions::UnableToTrackPluginBeingDefined
            else
              @@currently_defining
            end
          end

          def currently_defining= value
            @@currently_defining = value
          end
        end

        protected

        def define_plugin_module plugin_name, &block
          """
          module Rack::Tracker::Plugins::#{plugin_name.to_s.camelize}
          end
          """
        end
      end
    end
  end
end
