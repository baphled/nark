module Nark
  module Cli
    module ClassMethods
      def help option = ''
        case option.to_sym
        when :list
        """
        Usage: nark list plugins

        Lists all example plugins that you can generate.
        """
        when :example
        """
        Usage: nark example requests

        Creates an example plugin.
        """
        else
        """
        Usage: nark help

        Displays this message.
        """
        end
      end

      def list type
        # FIXME: This is sloppy. Come up with a way of removing the dependencies
        case type.to_sym
        when :plugins
          list = []
          {
            :requests => 'Tracks the number of requests made to your application',
            :request_times => 'Keeps track of the amount of time each request takes',
            :revisions => 'Outputs the git revision'
          }.reduce('') do |s, (plugin, description)|
            list << sprintf("%-20s - %s", plugin.to_sym, description)
          end
          list
        else
          'Invalid list type'
        end
      end

      def example plugin
        copy_to_path = 'lib/nark/plugin'
        plugin_content = determine_plugin_content plugin

        plugin_path = ::File.join(copy_to_path, plugin.to_s)

        if not ::File.directory? ::File.dirname plugin_path
          FileUtils.mkdir_p ::File.dirname plugin_path
        end

        ::File.open "#{plugin_path}.rb", 'w' do |file|
          file.write plugin_content
        end
      end

      def determine_plugin_content plugin
        case plugin.to_sym
        when :requests
          """Nark::Plugin.define :requests do |plugin|
  plugin.variables :total_requests => 0

  plugin.add_hook :before_call do |env|
    plugin.total_requests += 1
  end
end"""
        when :request_times
          """Nark::Plugin.define :requests do |plugin|
  plugin.variables :last_request_time => nil

  plugin.add_hook :before_call do |env|
    @start_time = Time.now
  end

  plugin.add_hook :after_call do |env|
    plugin.last_request_time = (Time.now - @start_time)
  end
end"""
        when :revisions
          """Nark::Plugin.define :revisions do |plugin|
  plugin.method :revision do
    %x[cat .git/refs/heads/master| cut -f 1].chomp
  end
end"""
        end
      end

      def create plugin
        copy_to_path = 'lib/nark/plugin'
        plugin_content = 
          """Nark::Plugin.define :#{plugin.to_s} do |plugin|
  plugin.method :#{plugin.to_s} do
    # Do something clever here.
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
