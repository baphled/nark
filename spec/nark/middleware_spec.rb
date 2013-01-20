require "spec_helper"

describe Nark::Middleware do
  include Rack::Test::Methods
  let(:target_app) { mock('The target application') }

  def app
    target_app.stub(:call).and_return([200, {}, "Target application"])
    Nark::Middleware.new(target_app)
  end

  describe "#new" do
    it "stores the application" do
      middleware = Nark::Middleware.new target_app
      middleware.app.should eql target_app
    end

    it "stores the event handler" do
      event_handler = stub(:CustomEventHandler, trigger: stub)
      middleware = Nark::Middleware.new target_app, event_handler
      middleware.event_handler.should eql event_handler
    end
  end

  describe "#call" do
    it "triggers before and after hooks at least twice" do
      Nark::Plugin.should_receive(:trigger).at_least(:twice)
      get '/'
    end
  end

  describe "#before_call" do
    it "takes the responses environment"
  end

  describe "#after_call" do
    it "takes a response payload"

    describe "response payload" do
      it "has a status code"
      it "has a response header"
    end

    describe "request environment" do
      it "has the original request environment"
    end
  end
end
