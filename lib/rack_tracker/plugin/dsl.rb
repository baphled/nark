require 'rack_tracker/plugin/macros'

module Rack
  module Tracker
    module Plugin
      #
      # The main DSL for defining and creating a custom plugin
      #
      # The primary function of this module is to define a custom plugin
      #
      # Allowing users to easily generate plugins that automatically become
      # part of the tracker once they have been successfully defined.
      #
      module DSL
        include Rack::Tracker::Macros

        class << self
          #
          # Delegate class methods not explicitly part of the DSL or Macros to
          # Rack::Tracker as this is where all plugin class variables are
          # included.
          #
          def method_missing method, *args, &block
            Rack::Tracker.send method, *args, &block
          end
        end

        module ClassMethods
          #
          # Define a custom plugin
          #
          # This allows a user to define a custom plugin that then can be used
          # to interact with an Rack based system.
          #
          def define plugin_name, &definition_block
            @@currently_defining = plugin_name
            eval define_plugin_module plugin_name
            yield Rack::Tracker::DSL
            Rack::Tracker.module_eval "include Rack::Tracker::Plugin::#{plugin_name.to_s.camelize}"
            @@currently_defining = nil
          end

          #
          # Track the plugin that is currently being defined
          #
          # This is primarily used to help define methods and variables to the
          # right plugin module
          #
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

          def define_plugin_module plugin_name
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
