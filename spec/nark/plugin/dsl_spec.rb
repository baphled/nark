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

  describe "#undefine" do
    it "removes the plugin from its namespace" do
      Nark::Plugin.define :random_plugin do |plugin|
        plugin.method :foo do
          'cool stuff'
        end
      end
      Nark::Plugin.constants.should include :RandomPlugin
      Nark::Plugin.undefine :random_plugin
      Nark::Plugin.constants.should_not include :RandomPlugin
    end

    it "removes all of the relating class variables" do
      Nark::Plugin.define :random_plugin do |plugin|
        plugin.variables :bar => 1
      end
      Nark::Plugin::RandomPlugin::ClassMethods.class_variables.should eql [:@@bar]
      Nark.should respond_to :bar
      Nark.should respond_to :bar=
      Nark::Plugin.undefine :random_plugin
      Nark.should_not respond_to :bar
      Nark.should_not respond_to :bar=
    end

    it "removes all of the relating class methods" do
      Nark::Plugin.define :random_plugin do |plugin|
        plugin.method :cool do
          2 + 2
        end
      end
      Nark.should respond_to :cool
      Nark::Plugin.undefine :random_plugin
      Nark.should_not respond_to :cool
    end

    it "removes the plugin events"

    it "doesn't try to undefine class methods when there aren't any" do
      Nark::Plugin.define :random_plugin do |plugin|
      end
      expect {
        Nark::Plugin.undefine :random_plugin
      }.to_not raise_error NameError
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
