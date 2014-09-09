require "spec_helper"

describe Nark::Event do
  let(:plugin_method_block) { Proc.new {|p| p } }
  let(:params) { { :plugin => :some_plugin, :type => 'before_call', :method_block => plugin_method_block } }

  subject { Nark::Event.new params }

  describe "#type" do
    it "stores the trigger type" do
      params.merge! :type => :before_call
      subject.type.should eql :before_call
    end

    it "can be a string" do
      subject.type.should eql 'before_call'
    end
  end

  describe "#method_block" do
    it "stores a block" do
      subject.method_block.should eql plugin_method_block
    end

    it "throws an exception if a block is not passed" do
      expect {
        subject = Nark::Event.new :type => :before_call, :method_block => 'foo'
      }.to raise_error ArgumentError
    end
  end

  describe "#plugin" do
    it "stores the plugin's name" do
      subject.plugin.should eql :some_plugin
    end
  end

  describe "#to_hash" do
    it "returns the attributes as a Hash" do
      subject.to_hash.should eql params
    end
  end

  describe "#exists?" do
    before :each do
      class EventsWrapper
        include Nark::Events
      end
    end

    after :each do
      Object.send :remove_const, :EventsWrapper
    end

    it "returns false" do
      Nark::Plugin.events.stub(:find).and_return false
      subject.should_not exist
    end

    it "returns true" do
      Nark::Plugin.events.stub(:find).and_return true
      subject.should exist
    end
  end

  describe "instance variables" do
    describe "mutability" do
      context "external manipulation" do
        it "restricts the type" do
          expect {
            subject.type = 'foo'
          }.to raise_error NoMethodError
        end

        it "restricts the method_block" do
          expect {
            subject.method_block = 'foo'
          }.to raise_error NoMethodError
        end

        it "restricts the plugin" do
          expect {
            subject.plugin = 'foo'
          }.to raise_error NoMethodError
        end

        it "restricts the attributes" do
          expect {
            subject.attributes = {}
          }.to raise_error NoMethodError
        end
      end
    end
  end
end
