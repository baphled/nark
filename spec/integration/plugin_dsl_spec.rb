require "spec_helper"

describe "Plugin DSL" do
  include Rack::Test::Methods

  before :each do
    def app
      @target_app = mock('The target application')
      @target_app.stub(:call).and_return([200, {'PATH_INFO' => '/'}, "Target application"])
      Rack::Tracker::Middleware.new @target_app
    end
  end

  describe "defining a plugin hook" do
    it "triggers the hook when the application is called" do
      Rack::Tracker::Plugin::DSL.define :something_really_cool do |plugin|
        plugin.variables :total_requests => 0

        plugin.add_hook :before_call do |env|
          Rack::Tracker.total_requests += 1
        end
      end

      module Rack::Tracker
        include Rack::Tracker::Plugin::SomethingReallyCool
      end

      get '/'
      Rack::Tracker.total_requests.should eql 1
    end
  end

  describe "defining a plugin class method" do
    it "allows us to define a plugin method" do
      Rack::Tracker::Plugin::DSL.define :something_really_cool do |plugin|
        plugin.method :revision do
          %x[cat .git/refs/heads/master| cut -f 1].chomp
        end
      end

      module Rack::Tracker
        include Rack::Tracker::Plugin::SomethingReallyCool
      end

      Rack::Tracker.revision.should eql %x[cat .git/refs/heads/master| cut -f 1].chomp
    end
  end

  context "finished defining a plugin" do
    it "should not be storing a plugin name" do
      Rack::Tracker::Plugin::DSL.define :something_really_cool do |plugin|
      end
      expect {
        Rack::Tracker::Plugin::DSL.currently_defining
      }.to raise_error Rack::Tracker::Exceptions::UnableToTrackPluginBeingDefined
    end
  end
end
