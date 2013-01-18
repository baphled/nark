require 'nark/plugin/macros'

module Nark
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
      include Nark::Macros

      class << self
        #
        # Delegate class methods not explicitly part of the DSL or Macros to
        # Nark as this is where all plugin class variables are
        # included.
        #
        def method_missing method, *args, &block
          Nark.send method, *args, &block
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
          yield Nark::DSL
          Nark.module_eval "include Nark::Plugin::#{plugin_name.to_s.camelize}"
          @@currently_defining = nil
        end

        def undefine plugin_name
          plugin_module = eval "Nark::Plugin::#{plugin_name.to_s.camelize}"
          if plugin_module.constants.include? :ClassMethods
            plugin_class_methods = eval "#{plugin_module}::ClassMethods"
            instance_methods = plugin_class_methods.instance_methods
            instance_methods.each { |method| plugin_class_methods.send :remove_method, method.to_sym }
          end
          Nark::Plugin.send :remove_const, plugin_name.to_s.camelize.to_sym
        end

        #
        # Track the plugin that is currently being defined
        #
        # This is primarily used to help define methods and variables to the
        # right plugin module
        #
        def currently_defining
          if @@currently_defining.nil?
            raise Nark::Exceptions::UnableToTrackPluginBeingDefined
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
              module Nark::Plugin::#{plugin_name.to_s.camelize}
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
