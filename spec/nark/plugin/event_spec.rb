require "spec_helper"

describe Nark::Event do
  let(:plugin_method_block) { Proc.new {|p| p } }
  let(:params) { { :plugin => :some_plugin, :type => 'before_call', :method_block => plugin_method_block } }

  subject { Nark::Event.new params }

  describe "#type" do
    it "stores the trigger type" do
      params.merge! :type => :before_call

      expect(subject.type).to eql(:before_call)
    end

    it "can be a string" do
      expect(subject.type).to eql('before_call')
    end
  end

  describe "#method_block" do
    it "stores a block" do
      expect(subject.method_block).to eql(plugin_method_block)
    end

    it "throws an exception if a block is not passed" do
      expect {
        subject = Nark::Event.new :type => :before_call, :method_block => 'foo'
      }.to raise_exception(ArgumentError)
    end
  end

  describe "#plugin" do
    it "stores the plugin's name" do
      expect(subject.plugin).to eql(:some_plugin)
    end
  end

  describe "#to_hash" do
    it "returns the attributes as a Hash" do
      expect(subject.to_hash).to eql(params)
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
      allow(Nark::Plugin.events)
        .to receive(:find)
        .and_return(false)

      expect(subject).not_to exist
    end

    it "returns true" do
      allow(Nark::Plugin.events)
        .to receive(:find)
        .and_return(true)

      expect(subject).to exist
    end
  end

  describe "instance variables" do
    describe "mutability" do
      context "external manipulation" do
        it "restricts the type" do
          expect {
            subject.type = 'foo'
          }.to raise_exception(NoMethodError)
        end

        it "restricts the method_block" do
          expect {
            subject.method_block = 'foo'
          }.to raise_exception(NoMethodError)
        end

        it "restricts the plugin" do
          expect {
            subject.plugin = 'foo'
          }.to raise_exception(NoMethodError)
        end

        it "restricts the attributes" do
          expect {
            subject.attributes = {}
          }.to raise_exception(NoMethodError)
        end
      end
    end
  end
end
