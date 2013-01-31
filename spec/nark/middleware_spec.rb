require "spec_helper"

describe Nark::Middleware do
  let(:response_body) { [ 200, {}, {} ] }
  let(:target_app) { mock('The target application', call: response_body) }
  let(:environment) { { 'PATH_INFO' => '/' } }
  let(:event_handler) { stub(:CustomEventHandler, trigger: stub) }
  subject { Nark::Middleware.new target_app, event_handler: event_handler }

  describe "#new" do
    it "initialises the application" do
      subject.app.should eql target_app
    end

    it "initialises the event handler" do
      subject.event_handler.should eql event_handler
    end
  end

  describe "#call" do
    it "triggers before and after hooks at least twice" do
      subject.event_handler.should_receive(:trigger).at_least(:twice)
      subject.call environment
    end

    it "calls the application" do
      subject.app.should_receive(:call).with environment
      subject.call environment
    end

    it "returns the applications response" do
      response = subject.call environment
      response.should eql [ 200, {}, { } ]
    end
  end

  describe "#before_call" do
    it "takes the request environment" do
      event_handler.should_receive(:trigger).once.with(:before_call, environment)
      subject.call environment
    end
  end

  describe "#after_call" do
    it "takes a response payload" do
      response_body_and_env = [response_body, environment].flatten
      event_handler.should_receive(:trigger).once.with(:after_call, response_body_and_env)
      subject.call environment
    end
  end
end
