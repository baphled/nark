module Rack
  module Tracker
    module Plugins
      class DSL
        def initialize plugin_name, &block
          eval define_plugin_module plugin_name
        end

        protected

        def define_plugin_module plugin_name
          """
          module Rack::Tracker::Plugins::#{plugin_name.to_s.camelize}
            module ClassMethods
              @@total_requests = 0

              def total_requests= amount
                @@total_requests += amount
              end

              def total_requests
                @@total_requests
              end
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
