module Rack
  module Tracker
    module Macros
      module ClassMethods
        def add_hook hook, &block
          Rack::Tracker::Middleware.events << {hook: hook, plugin_method: block}
        end

        def method method_name, &block
          plugin_method_code = """
            module Rack::Tracker::Plugin::#{Rack::Tracker::Plugin.currently_defining.to_s.camelize}
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
          Rack::Tracker.module_eval plugin_method_code
        end

        def variables variable_hashes
          variable_hashes.reduce('') do |s, (variable, value)|
            plugin_class_methods = """
              module Rack::Tracker::Plugin::#{Rack::Tracker::Plugin.currently_defining.to_s.camelize}
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
end
