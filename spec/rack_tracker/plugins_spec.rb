require "spec_helper"

describe Rack::Tracker::Plugins do

  before :each do
    class SubjectClass
      include Rack::Tracker::Plugins
    end
  end

  after :each do
    Object.send :remove_const, :SubjectClass
  end

  it "stores an array of plugin available" do
    Rack::Tracker::Middleware.new stub(:app, :call => 'foo')
    Rack::Tracker.available_plugins.should be_an Array
  end

  describe "#plugins" do
    it "has no plugins set by default" do
      SubjectClass.plugins.should eql []
    end

    it "provides does not manage a plugins name" do
      SubjectClass.require_plugins
      SubjectClass.add_plugins ['request_times']
      SubjectClass.plugins.should include 'request_times'
    end
  end

  describe "#available_plugins" do
    it "provides a list of plugins available"
  end

  describe "#add_plugin" do
    context "plugins are required" do
      before :each do
        SubjectClass.require_plugins
      end

      it "includes all listed plugins" do
        SubjectClass.add_plugins ['requests']
        SubjectClass.included_plugins.should include Rack::Tracker::Plugins::Requests
      end
    end

    context "plugin is not found" do
      it "should throw an exception" do
        expect {
          SubjectClass.add_plugins ['flakey']
        }.to raise_error Rack::TrackerPlugin::NotFound
      end
    end
  end

  describe "#require_plugins" do
    it "loads all plugins to the TrackerPlugin namespace" do
      SubjectClass.require_plugins
      SubjectClass.available_plugins.should include 'requests'
    end
  end

  describe "#plugins_paths" do
    it "stores the default plugins path" do
      SubjectClass.plugins_paths.should_not be_empty
    end
  end

  describe "#add_plugin_path" do
    it "stores the plugin path"
    it "throws an exception if no plugins were found"
    it "allows us to add a new path to search for plugins in"
  end
end
