module Rack
  module Tracker
    module Plugins
      class DSL
        include Rack::Tracker::Macros

        def initialize plugin_name, &block
          @@currently_defining = plugin_name
          eval define_plugin_module plugin_name, &block
          yield Rack::Tracker::DSL
          @@currently_defining = nil
        end

        class << self
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
