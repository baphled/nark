require 'spec_helper'

describe Rack::Tracker::Plugin::DSL do

  describe "#define" do
    it "allows me to define a plugin" do
      Rack::Tracker::Plugin::DSL.define :suttin_cool do
      end
      expect {
        Rack::Tracker::Plugin::SuttinCool
      }.to_not raise_error NameError
    end

    context "defining class variables" do
      it "allows me to define a class method for the plugin" do
        Rack::Tracker::DSL.define :a_cool_plugin do |plugin|
          plugin.variables :total_requests => 0
        end
        class RandomPluginWrapper
          include Rack::Tracker::Plugin::ACoolPlugin
        end
        RandomPluginWrapper.total_requests.should eql 0
      end

    end

    it "keeps track of the current plugin being defined" do
      Rack::Tracker::Plugin::DSL.define :a_random_plugin do
        Rack::Tracker::DSL.currently_defining.should eql :a_random_plugin
      end
    end
  end

  describe "#currently_defining" do
    context "not started to define one yet" do
      it "throws an exception" do
        expect {
          Rack::Tracker::Plugin::DSL.currently_defining
        }.to raise_error Rack::Tracker::Exceptions::UnableToTrackPluginBeingDefined
      end
    end
  end
end

