require "spec_helper"

describe Rack::Tracker::Middleware do
  include Rack::Test::Methods

  def app
    @target_app = mock('The target application')
    @target_app.stub(:call).and_return([200, {}, "Target application"])
    Rack::Tracker::Middleware.new(@target_app)
  end

  describe "#call" do
    it "triggers before and after hooks at least twice" do
      Rack::Tracker::Middleware.any_instance.should_receive(:trigger_hook).at_least(:twice)
      get '/'
    end
  end

  describe "#events" do
    it "stores a list of events to listen out for" do
      Rack::Tracker::Middleware.events.should be_an Array
    end
  end
end
