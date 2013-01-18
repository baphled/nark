require "spec_helper"

describe Nark::Middleware do
  include Rack::Test::Methods

  def app
    @target_app = mock('The target application')
    @target_app.stub(:call).and_return([200, {}, "Target application"])
    Nark::Middleware.new(@target_app)
  end

  describe "#call" do
    it "triggers before and after hooks at least twice" do
      Nark::Middleware.any_instance.should_receive(:trigger_hook).at_least(:twice)
      get '/'
    end
  end

  describe "#events" do
    it "stores a list of events to listen out for" do
      Nark::Middleware.events.should be_an Array
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
