require "spec_helper"

describe Nark::Plugin::Event do
  describe "#hook" do
    it "stores the hook" do
      event = Nark::Plugin::Event.new :hook => :before_call
      event.hook.should eql :before_call
    end

    describe "hook value type" do
      it "can be a string" do
        event = Nark::Plugin::Event.new :hook => 'before_call'
        event.hook.should eql 'before_call'
      end
    end
  end

  describe "#plugin_method" do
    it "stores a block"
  end

  describe "#plugin" do
    it "stores the plugin as a symbol"
  end
end
