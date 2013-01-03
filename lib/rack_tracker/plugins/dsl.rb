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
          end
          """
        end
      end
    end
  end
end
