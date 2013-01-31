require "spec_helper"

describe Nark::Plugin::Event do
  let(:plugin_method_block) { Proc.new {|p| p } }

  describe "#type" do
    it "stores the trigger type" do
      params = {
        :type => :before_call,
        :method_block => plugin_method_block
      }
      event = Nark::Plugin::Event.new params
      event.type.should eql :before_call
    end

    it "can be a string" do
      params = {
        :type => 'before_call',
        :method_block => plugin_method_block
      }
      event = Nark::Plugin::Event.new params
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

    it "throws an exception if a block is not passed" do
      expect {
      event = Nark::Plugin::Event.new :type => :before_call, :method_block => 'foo'
      }.to raise_error ArgumentError
    end
  end

  describe "#plugin" do
    it "stores the plugin's name" do
      params = { :plugin => :some_plugin, :type => 'before_call', :method_block => plugin_method_block }
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

  describe "instance variables" do
    let(:plugin_method_block) { Proc.new {|p| p } }
    let(:params) {
      { :plugin => :some_plugin, :type => 'before_call', :method_block => plugin_method_block }
    }
    let(:event) { Nark::Plugin::Event.new params }

    describe "mutability" do
      context "external manipulation" do
        it "restricts the type" do
          expect {
            event.type = 'foo'
          }.to raise_error NoMethodError
        end

        it "restricts the method_block" do
          event = Nark::Plugin::Event.new params
          expect {
            event.method_block = 'foo'
          }.to raise_error NoMethodError
        end

        it "restricts the plugin" do
          event = Nark::Plugin::Event.new params
          expect {
            event.plugin = 'foo'
          }.to raise_error NoMethodError
        end

        it "restricts the attributes" do
          event = Nark::Plugin::Event.new params
          expect {
            event.attributes = {}
          }.to raise_error NoMethodError
        end
      end
    end
  end
end
