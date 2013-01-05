require "spec_helper"

describe Rack::Tracker::Plugins do
  include Rack::Test::Methods

  def app
    @target_app = mock('The target application')
    @target_app.stub(:call).and_return([200, {}, "Target application"])
    Rack::Tracker::Middleware.new @target_app
  end

  it "stores an array of plugin available" do
    Rack::Tracker::Middleware.new stub(:app, :call => 'foo')
    Rack::Tracker.available_plugins.should be_an Array
  end

  describe "#plugins" do
    it "can add a plugin" do
      Rack::Tracker.add_plugins ['request_times']
      Rack::Tracker.plugins.should include 'request_times'
    end
  end

  describe "#available_plugins" do
    it "should not include class_methods" do
      Rack::Tracker.available_plugins.should_not include 'class_methods'
    end

    it "should not include instance_methods" do
      Rack::Tracker.available_plugins.should_not include 'instance_methods'
    end

    it "provides a list of all available plugins"
  end

  describe "#add_plugin" do
    context "plugins are required" do
      it "includes all listed plugins" do
        Rack::Tracker.add_plugins ['requests']
        Rack::Tracker.included_plugins.should include Rack::Tracker::Plugins::Requests
      end
    end

    context "plugin is not found" do
      it "should throw an exception" do
        pending 'Need to revisit this'
        expect {
          Rack::Tracker.add_plugins ['flakey']
        }.to raise_error Rack::TrackerPlugin::NotFound
      end
    end
  end

  describe "#add_hook" do
    it "adds a listener hook" do
      plugin_block = ->(env) { puts 'do something' }
      Rack::Tracker::Plugins::DSL.add_hook :before_call, &plugin_block
      expected = {:hook => :before_call, :plugin_method => plugin_block}
      Rack::Tracker.listeners.should include expected
    end

    describe ":before_call" do
      class TestObject
        def self.foo; end
      end

      it "calls the added hook" do
        TestObject.should_receive :foo
        block = ->(env) { TestObject.foo }
        Rack::Tracker::Plugins::DSL.add_hook :before_call, &block
        get '/'
      end

      it "can interact with Rack::Tracker class variables" do
        Rack::Tracker.add_plugins [:request_times]
        Rack::Tracker.should_receive(:last_request_time=).at_least :once
        get '/'
      end
    end
  end

  describe "#require_plugins" do
    it "loads all plugins to the TrackerPlugin namespace" do
      Rack::Tracker.available_plugins.should include 'requests'
    end
  end

  describe "#plugins_paths" do
    it "stores the default plugins path" do
      Rack::Tracker.plugins_paths.should_not be_empty
    end
  end
end
