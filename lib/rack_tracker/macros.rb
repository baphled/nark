module Rack
  module Tracker
    module Macros
      module ClassMethods
        def plugin_variables variable_hashes
          variable_hashes.reduce('') do |s, (variable, value)|
            plugin_class_methods = """
              module Rack::Tracker::Plugins::#{Rack::Tracker::DSL.currently_defining.to_s.camelize}
                module ClassMethods
                  @@#{variable} = #{value}

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
