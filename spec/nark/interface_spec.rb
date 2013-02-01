require "spec_helper"

describe Nark::Interface do
  describe "#call" do
    it "can call a plugin accessor" do
      Nark.should_receive(:public_send).with(:available_plugins)
      Nark::Interface.call(:available_plugins)
    end

    it "returns a hash" do
      Nark::Interface.call(:available_plugins).should be_a Hash
    end

    it "returns the name of call and the response" do
      Nark::Interface.call(:available_plugins).should eql :available_plugins => []
    end

    context "message not found" do
      it "returns an error" do
        Nark::Interface.call(:foo).should eql :error => 'Unrecognised message: foo'
      end
    end
  end

  describe "#messages" do
    before :each do
      Nark.load_plugins
    end

    it "includes the available_plugins message" do
      Nark::Interface.messages[:messages].should include :available_plugins
    end

    it "includes the defined_methods message" do
      Nark::Interface.messages[:messages].should include :defined_methods
    end

    it "includes the load_plugins message" do
      Nark::Interface.messages[:messages].should include :load_plugins
    end

    it "includes the reporters message" do
      Nark::Interface.messages[:messages].should include :reporters
    end

    messages = [:available_plugins, :last_request_time, :load_plugins, :revision, :statues, :total_requests]

    messages.each do |message|
      it "returns #{message}" do
        Nark::Interface.messages[:messages].should include message
      end
    end
  end
end
