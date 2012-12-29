module Rack
  module Tracker::Plugins
    module RepositoryRevision
      module ClassMethods
        def revision
          if Dir.exists? '.git'
            %x[cat .git/refs/heads/master| cut -f 1].chomp
          else
            raise Rack::TrackerPlugin::RevisionNotFound.new 'Unable to find a way to get the applications revision'
          end
        end
      end

      def self.included(receiver)
        receiver.extend         ClassMethods
      end
    end
  end
end
