require 'spec_helper'

describe Nark::DSL do

  describe "#define" do
    it "allows me to define a plugin" do
      Nark::Plugin.define :suttin_cool do
      end

      expect {
        Nark::Plugin::SuttinCool
      }.to_not raise_error
    end

    context "defining class variables" do
      it "allows me to define a class method for the plugin" do
        Nark::Plugin.define :a_cool_plugin do |plugin|
          plugin.variables :total_requests => 0
        end

        expect(Nark.total_requests).to eql(0)
      end
    end

    it "keeps track of the current plugin being defined" do
      Nark::Plugin.define :a_random_plugin do
        expect(Nark::Plugin.currently_defining).to eql(:a_random_plugin)
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

      expect(Nark::Plugin.constants).to include(:RandomPlugin)

      Nark::Plugin.undefine :random_plugin

      expect(Nark::Plugin.constants).not_to include(:RandomPlugin)
    end

    it "removes all of the relating class variables" do
      Nark::Plugin.define :random_plugin do |plugin|
        plugin.variables :bar => 1
      end

      expect(Nark::Plugin::RandomPlugin::PluginMethods.class_variables).to eql([:@@bar])
      expect(Nark).to respond_to(:bar)
      expect(Nark).to respond_to(:bar=)

      Nark::Plugin.undefine :random_plugin

      expect(Nark).not_to respond_to(:bar)
      expect(Nark).not_to respond_to(:bar=)
    end

    it "removes all of the relating class methods" do
      Nark::Plugin.define :random_plugin do |plugin|
        plugin.method :cool do
          2 + 2
        end
      end

      expect(Nark).to respond_to(:cool)

      Nark::Plugin.undefine :random_plugin

      expect(Nark).not_to respond_to(:cool)
    end

    it "removes the plugin events" do
      Nark::Plugin.define :random_plugin do |plugin|
        plugin.add_hook :before_call do |env|
          puts 'some before hook'
        end
      end

      expect(Nark::Plugin.events).not_to be_empty

      Nark::Plugin.undefine :random_plugin

      expect(Nark::Plugin.events.collect{ |event| event.plugin }).not_to include('random_plugin')
    end

    it "doesn't try to undefine class methods when there aren't any" do
      Nark::Plugin.define :random_plugin do |plugin|
      end

      expect {
        Nark::Plugin.undefine :random_plugin
      }.to_not raise_error
    end

    it "only remove events relating to the plugin we're Undefining" do
      Nark::Plugin.define :second_plugin do |plugin|
        plugin.add_hook :before_call do |env|
          puts 'some other before hook'
        end
      end

      Nark::Plugin.define :random_plugin do |plugin|
        plugin.add_hook :before_call do |env|
          puts 'some before hook'
        end
      end

      Nark::Plugin.undefine :random_plugin

      expect(Nark::Plugin.events.collect{ |event| event.plugin }).not_to include('random_plugin')
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
