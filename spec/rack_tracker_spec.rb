require "spec_helper"

describe Rack::Tracker do
  include Rack::Test::Methods

  def app
    @target_app = mock('The target application')
    @target_app.stub(:call).and_return([200, {}, "Target application"])
    Rack::Tracker.new(@target_app)
  end

  describe "#call" do
    it "calls to before_call" do
      Rack::Tracker.any_instance.should_receive :before_call
      get '/'
    end

    it "calls to after_call" do
      Rack::Tracker.any_instance.should_receive :after_call
      get '/'
    end
  end

  context "sending a request" do
    it "should increment the total requests" do
      get '/'
      Rack::Tracker.total_requests.should be_an Numeric
    end
  end
end
