module Nark
  #
  # Plugin macros used to generate custom plugins
  #
  # These methods allow a user to create the basics needed to create a plugin
  # module.
  #
  module Macros
    module ClassMethods
      #
      # Add an event hook to the tracker
      #
      # This allows you to attach a block to a specific event. Whenever an
      # event is triggered the attached block will be triggered.
      #
      # This basically allows you track things of aspects of their application.
      #
      # At present the following hooks can be attached to:
      #   :before_call
      #   :after_call
      #
      def add_hook hook, &block
        event_trigger = Nark::Event.new(
          type: hook,
          method_block: block,
          plugin: Nark::Plugin.currently_defining.to_s
        )
        Nark::Plugin.add_trigger event_trigger
      end

      #
      # Define a method associated to a given plugin.
      #
      # This allows a user to create a custom method that can be used to
      # track system based functionality as well as help to keep event block
      # short with the use of helper methods.
      #
      def method method_name, &block
        plugin_method_definition = self.plugin_method_code(method_name, &block)

        Nark::Plugin.module_eval(plugin_method_definition)
      end

      #
      # Define variables needed for the plugin.
      #
      # This macro allows you to create a plugin method that can be used to
      # track and share information relating to your plugin.
      #
      def variables variable_hashes
        variable_hashes.reduce('') do |s, (variable, value)|
          plugin_class_methods_definition = self.plugin_class_methods variable, value

          Nark::Plugin.module_eval(plugin_class_methods_definition)
          Nark::Plugin.defined_methods << variable
        end
      end

      def description title
        Nark::Plugin.module_eval(description_method title)
      end
    end

    def self.included(receiver)
      receiver.extend         ClassMethods
    end
  end

  protected

  class << self
    def plugin_method_code method_name, &block
      """
      module #{Nark::Plugin.currently_defining.to_s.camelize}
        module PluginMethods
          def #{method_name}
            #{block.call}
          end
        end

        def self.included(receiver)
          receiver.extend PluginMethods
        end
      end
      """
    end

    def description_method title
      """
      module #{Nark::Plugin.currently_defining.to_s.camelize}
        class << self
          def metadata
            '#{title.to_s}'
          end
        end
      end
      """
    end

    def plugin_class_methods variable, value
      """
      module #{Nark::Plugin.currently_defining.to_s.camelize}
        module PluginMethods
          @@#{variable} = #{value.inspect}

          def #{variable}
            @@#{variable}
          end

          def #{variable}= value
            @@#{variable} = value
          end
        end

        def self.included(receiver)
          receiver.extend PluginMethods
        end
      end
      """
    end
  end
end
