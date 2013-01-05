require 'rack_tracker/macros'

module Rack
  module Tracker
    module Plugin
      module DSL
        include Rack::Tracker::Macros

        module ClassMethods
          def define plugin_name, &block
            @@currently_defining = plugin_name
            eval define_plugin_module plugin_name, &block
            yield Rack::Tracker::DSL
            @@currently_defining = nil
            Rack::Tracker.module_eval "include Rack::Tracker::Plugin::#{plugin_name.to_s.camelize}"
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

          protected

          def define_plugin_module plugin_name, &block
            """
          module Rack::Tracker::Plugin::#{plugin_name.to_s.camelize}
          end
          """
          end
        end

        def self.included(receiver)
          receiver.extend         ClassMethods
        end
      end
    end
  end
end
