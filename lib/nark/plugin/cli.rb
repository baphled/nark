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
        case type.to_sym
        when :plugins
          list = []
          plugin_list.reduce('') do |s, (plugin, description)|
            list << sprintf("%-20s - %s", plugin.to_sym, description)
          end
          list
        else
          'Invalid list type'
        end
      end

      def example plugin
        begin
          plugin_content = determine_plugin_content "#{plugin}.rb"

          plugin_path = ::File.join(destination_path, plugin.to_s)
          create_template plugin_path, plugin_content
        rescue EOFError
        rescue IOError => e
          puts e.exception
        rescue Errno::ENOENT
          "Invalid plugin name. Try one of the following: #{plugin_list.keys.join(', ')}"
        end
      end

      def create plugin
        template_content = determine_plugin_content 'template.erb'
        template = ERB.new template_content

        plugin_content = template.result binding
        plugin_path = ::File.join(destination_path, plugin.to_s)
        create_template plugin_path, plugin_content
      end
      
      protected

      def determine_plugin_content plugin_name
        plugin_path = File.join File.dirname(__FILE__), '..','..', '..', 'plugins', plugin_name
        IO.read(File.expand_path plugin_path)
      end

      # FIXME: This is sloppy. Come up with a way of removing the dependencies
      def plugin_list
        {
          :requests => 'Tracks the number of requests made to your application',
          :request_times => 'Keeps track of the amount of time each request takes',
          :revisions => 'Outputs the git revision'
        }
      end

      def destination_path
        'lib/nark/plugin'
      end

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
