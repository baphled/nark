require "spec_helper"

describe Nark::Plugin::Event do
  describe "#type" do
    it "stores the trigger type" do
      event = Nark::Plugin::Event.new :type => :before_call
      event.type.should eql :before_call
    end

    it "can be a string" do
      event = Nark::Plugin::Event.new :type => 'before_call'
      event.type.should eql 'before_call'
    end
  end

  describe "#method_block" do
    it "stores a block" do
      plugin_method_block = Proc.new {|p| p }
      params = {
        :type => 'before_call',
        :method_block => plugin_method_block
      }
      event = Nark::Plugin::Event.new params
      event.method_block.should eql plugin_method_block
    end

    it "throws an exception if a block is not passed"
  end

  describe "#plugin" do
    it "stores the plugin's name" do
      params = {
        :plugin => :some_plugin,
      }
      event = Nark::Plugin::Event.new params
      event.plugin.should eql :some_plugin
    end
  end

  describe "#to_hash" do
    it "returns the attributes as a Hash" do
      plugin_method_block = Proc.new {|p| p }
      params = {
        :plugin => :some_plugin,
        :type => 'before_call',
        :method_block => plugin_method_block
      }
      event = Nark::Plugin::Event.new params
      event.to_hash.should eql params
    end
  end

  describe "#exists?" do
    let(:plugin_method_block) { Proc.new {|p| p } }
    let(:params) {
      { :plugin => :some_plugin, :type => 'before_call', :method_block => plugin_method_block }
    }

    before :each do
      class EventsWrapper
        include Nark::Events
      end
    end

    after :each do
      Object.send :remove_const, :EventsWrapper
    end

    it "returns false if it does not exist" do
      event = Nark::Plugin::Event.new params
      Nark::Plugin.events.stub(:find).and_return false
      event.should_not exist
    end

    it "returns true if it does exist" do
      event = Nark::Plugin::Event.new params
      Nark::Plugin.events.stub(:find).and_return true
      event.should exist
    end
  end
end
