require 'spec_helper'

describe Nark::Plugin::DSL do

  describe "#define" do
    it "allows me to define a plugin" do
      Nark::Plugin.define :suttin_cool do
      end
      expect {
        Nark::Plugin::SuttinCool
      }.to_not raise_error NameError
    end

    context "defining class variables" do
      it "allows me to define a class method for the plugin" do
        Nark::Plugin.define :a_cool_plugin do |plugin|
          plugin.variables :total_requests => 0
        end
        Nark.total_requests.should eql 0
      end
    end

    it "keeps track of the current plugin being defined" do
      Nark::Plugin.define :a_random_plugin do
        Nark::Plugin.currently_defining.should eql :a_random_plugin
      end
    end
  end

  describe "#currently_defining" do
    context "not started to define one yet" do
      it "throws an exception" do
        expect {
          Nark::Plugin.currently_defining
        }.to raise_error Nark::Exceptions::UnableToTrackPluginBeingDefined
      end
    end
  end
end