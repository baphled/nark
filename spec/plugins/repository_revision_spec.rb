require "spec_helper"
require "#{File.dirname(__FILE__)}/../../lib/plugins/repository_revision"

describe Rack::Tracker::Plugins::RepositoryRevision do
  before :each do
    class SubjectClass
      include Rack::Tracker::Plugins::RepositoryRevision
    end
  end

  after :each do
    Object.send :remove_const, :SubjectClass
  end

  describe "#revision" do
    it "a way to get the revision was unsuccessful" do
      Dir.stub(:exists?).with('.git').and_return false
      expect {
        SubjectClass.revision
      }.to raise_error Rack::TrackerPlugin::RevisionNotFound
    end

    context "the .git directory is found" do
      it "returns the current git ref" do
        git_revision = %x[cat .git/refs/heads/master| cut -f 1].chomp
        SubjectClass.revision.should eql git_revision
      end
    end
  end
end
