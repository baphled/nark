require 'nark/macros'

module Nark
  #
  # The main DSL for defining and creating a custom plugin
  #
  # The primary function of this module is to define a custom plugin
  #
  # Allowing users to easily generate plugins that automatically become
  # part of the tracker once they have been successfully defined.
  #
  # TODO: Find a better way of keeping track of the plugin we are currently defining
  # TODO: Create a plugin abstraction layer where all plugin functionality will live
  #
  module DSL
    include Nark::Macros

    class << self
      #
      # Delegate class methods not explicitly part of the DSL or Macros to
      # Nark as this is where all plugin class variables are included.
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
        Nark::Plugin.module_eval(define_plugin_module(plugin_name))
        yield Nark::DSL
        Nark.module_eval "include Nark::Plugin::#{plugin_name.to_s.camelize}"
        @@currently_defining = nil
      end

      #
      # Undefine a custom plugin
      #
      # This allows a user to remove a plugin from Nark without having
      # to restart the server.
      #
      # This functionality is potentially quite complex and could
      # possibly do with having a new home. We'll leave it where it is
      # for the time being and see how this module evolves.
      #
      # TODO: This could be done a lot easier if the ancestor tree was updated
      #
      def undefine plugin_name
        undefine_plugin_class_methods plugin_name
        Nark::Plugin.remove_trigger plugin_name
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

      #
      # These procted methods are for handling the injection and
      # removal of plugin functionality into Nark.
      #
      # They don't really belong here as such but will be left alone
      # for the moment until the DSL is full ironed out.
      #
      protected

      #
      # Set the the name of the plugin that is currently being defined
      #
      def currently_defining= value
        @@currently_defining = value
      end

      #
      # Work out if we need to remove any class methods associated to the plugin we are undefining
      #
      def undefine_plugin_class_methods plugin_name
        plugin_module = "Nark::Plugin::#{plugin_name.to_s.camelize}".constantize
        if plugin_module.constants.include? :PluginMethods
          remove_plugin_class_methods plugin_module
        end
      end

      #
      # Actually remove the plugin methods from Nark
      #
      def remove_plugin_class_methods plugin_module
        instance = module_instance(plugin_module)
        instance_methods = instance.instance_methods
        instance_methods.each do |method|
          instance.send :remove_method, method.to_sym
          Nark::Plugin.defined_methods.reject! { |defined| defined.to_sym == method.to_sym }
        end
      end

      #
      # Gets an instance of the plugin's class methods
      #
      def module_instance plugin_module
        "#{plugin_module}::PluginMethods".constantize
      end

      #
      # initialize the plugin module before doing anything else
      #
      # TODO: Determine whether this is actually needed
      #
      def define_plugin_module plugin_name
        """
        module Nark::Plugin::#{plugin_name.to_s.camelize}
          class << self
            def metadata
              'Fallback description: Use the description macro to define the plugins description'
            end
          end
        end
        """
      end
    end

    def self.included(receiver)
      receiver.extend         ClassMethods
    end
  end
end
