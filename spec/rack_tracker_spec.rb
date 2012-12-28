require "spec_helper"

describe Rack::Tracker do
  include Rack::Test::Methods

  def app
    @target_app = mock('The target application')
    @target_app.stub(:call).and_return([200, {}, "Target application"])
    Rack::Tracker.new(@target_app)
  end

  context "sending a request" do
    it "should increment the total requests" do
      get '/'
      Rack::Tracker.total_requests.should eql 1
    end
  end
end
