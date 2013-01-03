module Rack
  module Tracker
    module Plugins
      class DSL
        class << self

          def plugin_variables variable_hashes
            variable_hashes.reduce('') do |s, (variable, value)|
              """
              module Rack::Tracker::Plugins::ACoolPlugin
                module ClassMethods
                  @@#{variable} = #{value}

                  def #{variable}
                    @@#{variable}
                  end

                  def #{variable}= value
                    @@#{variable} = value
                  end
                end
              end
              """
            end
          end
        end

        def initialize plugin_name, &block
          eval define_plugin_module plugin_name, &block
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
