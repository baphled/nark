module Rack
  module Tracker
    module Cli
      module ClassMethods
        def example plugin
          copy_to_path = 'lib/rack_tracker/plugin'
          plugin_content = 
"""Rack::Tracker::Plugin.define :requests do |plugin|
  plugin.variables :total_requests => 0

  plugin.add_hook :before_call do |env|
    plugin.total_requests += 1
  end
end"""

          plugin_path = ::File.join(copy_to_path, plugin.to_s)

          if not ::File.directory? ::File.dirname plugin_path
            FileUtils.mkdir_p ::File.dirname plugin_path
          end

          ::File.open "#{plugin_path}.rb", 'w' do |file|
            file.write plugin_content
          end
        end
      end

      def self.included(receiver)
        receiver.extend         ClassMethods
      end
    end
  end
end
