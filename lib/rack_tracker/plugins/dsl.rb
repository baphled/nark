module Rack
  module Tracker
    module Plugins
      class DSL
        @@currently_defining = nil

        class << self
          def currently_defining
            if @@currently_defining.nil?
              raise Rack::Tracker::Exceptions::UnableToTrackPluginBeingDefined
            else
              @@currently_defining
            end
          end
        end

        def initialize plugin_name, &block
          eval define_plugin_module plugin_name, &block
          @@currently_defining = plugin_name
        end

        protected

        def define_plugin_module plugin_name, &block
          """
          module Rack::Tracker::Plugins::#{plugin_name.to_s.camelize}
            module ClassMethods
              #{block.call}
            end

            def self.included(receiver)
              receiver.extend ClassMethods
            end
          end
          """
        end
      end
    end
  end
end
