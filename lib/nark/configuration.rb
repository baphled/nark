module Nark
  module Configuration
    class << self
      attr_accessor :settings
      def settings
        begin
          settings ||= YAML.load_file File.absolute_path Nark.settings_path
        rescue
          {}
        end
      end
    end
  end
end
