require "spec_helper"

describe Rack::Tracker::Macros do
  describe "#add_hook" do
    it "adds the hook to the middlewares events" do
      Rack::Tracker::Middleware.events.should_receive :<<
      Rack::Tracker::Plugin.define :requests do |plugin|
        plugin.variables :last_request_time => nil

        plugin.add_hook :before_call do |env|
          start_time = Time.now
        end
      end
    end
  end

  describe "#method" do
    it "creates the defined class method" do
      Rack::Tracker::Plugin.define(:revision) do |plugin|
        plugin.method :revision do
          `cat .git/refs/heads/master| cut -f 1`.chomp
        end
      end
      Rack::Tracker.revision.should eql `cat .git/refs/heads/master| cut -f 1`.chomp
    end
  end

  describe "#variables" do
    it "are accessible" do
      Rack::Tracker::Plugin.define(:some_plugin) do |plugin|
        plugin.variables :last_request_time => nil
      end
      Rack::Tracker.should respond_to :last_request_time
    end

    it "can take a hash of variables" do
      Rack::Tracker::Plugin.define(:some_cool_plugin) do |plugin|
        plugin.variables :msg => 'hey', :value => 2, :hash => {:foo => 'bar'}
      end
      hash = {:foo => 'bar'}
      Rack::Tracker.hash.should eql hash
      Rack::Tracker.msg.should eql 'hey'
      Rack::Tracker.value.should eql 2
    end
  end
end
