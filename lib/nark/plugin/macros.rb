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
      #   :after_response
      #   :after_call
      #
      def add_hook hook, &block
        Nark::Plugin.events << {hook: hook, plugin_method: block, plugin: Nark::Plugin.currently_defining.to_s }
      end

      #
      # Define a method associated to a given plugin.
      #
      # This allows a user to create a custom method that can be used to
      # track system based functionality as well as help to keep event block
      # short with the use of helper methods.
      #
      def method method_name, &block
        plugin_method_code = """
            module Nark::Plugin::#{Nark::Plugin.currently_defining.to_s.camelize}
              module ClassMethods
                def #{method_name}
                  '#{block.call}'
                end
              end

              def self.included(receiver)
                receiver.extend ClassMethods
              end
            end
                """
                eval plugin_method_code
      end

      #
      # Define variables needed for the plugin.
      #
      # This macro allows you to create a plugin method that can be used to
      # track and share information relating to your plugin.
      #
      def variables variable_hashes
        variable_hashes.reduce('') do |s, (variable, value)|
          plugin_class_methods = """
              module Nark::Plugin::#{Nark::Plugin.currently_defining.to_s.camelize}
                module ClassMethods
                  @@#{variable} = #{value.inspect}

                  def #{variable}
                    @@#{variable}
                  end

                  # FIXME: It's only really need for a way to clear our slate when running specs
                  def #{variable}= value
                    @@#{variable} = value
                  end
                end

                def self.included(receiver)
                  receiver.extend ClassMethods
                end
              end
                    """
                    eval plugin_class_methods
        end
      end
    end

    def self.included(receiver)
      receiver.extend         ClassMethods
    end
  end
end
