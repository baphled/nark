module Nark
  #
  # Basic CLI wrapper to expose Nark to the command line
  #
  # TODO: Refactor this so that it separates the presentation from logic.
  # TODO: Refactor this so that it is more dynamic.
  # TODO: Refactor to expose a public interface that can be asked what is available_plugins.
  # TODO: Interact with an interface that returns help based on the available interface.
  #
  #
  module CLI
    class << self
      #
      # Output Narks help information
      #
      # At present we are forced to keep this up to date whilst adding new
      # features. This should be refactored so that it gather the neccessary
      # information via the new feature.
      #
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
        when :create
        """
        Usage: nark create foo

        Creates new plugin template called foo.
        """
        else
        """
        Usage: nark help

        Displays this message.
        """
        end
      end

      #
      # Returns a list of available plugins
      #
      # TODO: Make this dynamic so that it can work out what plugins added as part of this project
      #
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

      #
      # Creates the passed plugin
      #
      def example plugin
        begin
          plugin_content = determine_plugin_content "#{plugin}.rb"

          plugin_path = File.join(destination_path, plugin.to_s)
          create_template plugin_path, plugin_content
        rescue EOFError
        rescue IOError => e
          puts e.exception
        rescue Errno::ENOENT
          "Invalid plugin name. Try one of the following: #{plugin_list.keys.join(', ')}"
        end
      end

      #
      # Creates a template plugin that you can use to create your own plugin
      #
      def create plugin
        template_content = determine_plugin_content 'template.erb'
        template = ERB.new template_content

        plugin_content = template.result binding
        plugin_path = File.join(destination_path, plugin.to_s)
        create_template plugin_path, plugin_content
      end

      protected

      def determine_plugin_content plugin_name
        plugin_path = File.join File.dirname(__FILE__), '..','..', '..', 'plugins', plugin_name
        IO.read(File.expand_path plugin_path).chomp
      end

      #
      #  Returns a list of plugins that are part of Nark
      #
      # FIXME: This is sloppy. Come up with a way of removing the dependencies
      #
      def plugin_list
        {
          :requests => 'Tracks the number of requests made to your application',
          :request_times => 'Keeps track of the amount of time each request takes',
          :revisions => 'Outputs the git revision'
        }
      end

      #
      # Stores the location where plugins will be created
      #
      def destination_path
        Nark.plugins_path
      end

      protected

      #
      # Creates the plugin with the passed in content
      #
      # This will more than likely be extracted once we devise a way for developers to easily create their own plugins
      #
      def create_template plugin_path, plugin_content
        if not File.directory? File.dirname plugin_path
          FileUtils.mkdir_p File.dirname plugin_path
        end

        File.open "#{plugin_path}.rb", 'w' do |file|
          file.write plugin_content
        end
      end

    end
  end
end
