require "spec_helper"

describe "Running multiple plugins" do
  describe "running two plugins that use the before hook" do
    include Rack::Test::Methods

    def app
      @target_app = mock('The target application')
      @target_app.stub(:call).and_return([200, {'PATH_INFO' => '/'}, "Target application"])
      Rack::Tracker::Middleware.new @target_app
    end

    it "can track the number of requests and the amount of time the request took" do
      Rack::Tracker.add_plugins [:request_times, :requests ]
      get '/'
      Rack::Tracker.last_request_time.should be_within(0.1).of(0.1)
      Rack::Tracker.total_requests.should eql 1
    end
  end
end
