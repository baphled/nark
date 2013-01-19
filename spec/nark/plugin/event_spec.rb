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

  describe "#plugin_method" do
    it "stores a block"
  end

  describe "#plugin" do
    it "stores the plugin as a symbol"
  end
end
