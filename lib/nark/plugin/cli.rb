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
        begin
          plugin_content = determine_plugin_content plugin

          plugin_path = ::File.join(copy_to_path, plugin.to_s)
          create_template plugin_path, plugin_content
        rescue EOFError
        rescue IOError => e
          puts e.exception
        rescue Errno::ENOENT
          "Invalid plugin name. Try one of the following: requests, request_times, revisions"
        end
      end

      def determine_plugin_content plugin
        plugin_path = File.join File.dirname(__FILE__), '..','..', '..', 'plugins', "#{plugin.to_s}.rb"
        IO.read(File.expand_path plugin_path)
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
        create_template plugin_path, plugin_content
      end
      
      protected

      def create_template plugin_path, plugin_content
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
