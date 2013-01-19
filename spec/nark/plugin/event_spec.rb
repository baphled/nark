require "spec_helper"

describe Nark::Plugin::Event do
  describe "#trigger_type" do
    it "stores the trigger type" do
      event = Nark::Plugin::Event.new :trigger_type => :before_call
      event.trigger_type.should eql :before_call
    end

    it "can be a string" do
      event = Nark::Plugin::Event.new :trigger_type => 'before_call'
      event.trigger_type.should eql 'before_call'
    end
  end

  describe "#method_block" do
    it "stores a block" do
      plugin_method_block = Proc.new {|p| p }
      params = {
        :trigger_type => 'before_call',
        :method_block => plugin_method_block
      }
      event = Nark::Plugin::Event.new params
      event.method_block.should eql plugin_method_block
    end
  end

  describe "#plugin" do
    it "stores the plugin as a symbol"
  end
end
