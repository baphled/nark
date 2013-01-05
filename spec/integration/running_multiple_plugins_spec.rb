require "spec_helper"

describe "Running multiple plugins" do
  include Rack::Test::Methods

  def app
    @target_app = mock('The target application')
    @target_app.stub(:call).and_return([200, {'PATH_INFO' => '/'}, "Target application"])
    Rack::Tracker::Middleware.new @target_app
  end

  describe "running two plugins that use the before hook" do
    let(:request_times_plugin) { create_plugin(:request_times) }
    let(:requests) { create_plugin(:requests) }

    before :each do
      Rack::Tracker::Plugin.define :request_times, &request_times_plugin
      Rack::Tracker::Plugin.define :requests, &requests
    end

    it "can track the number of requests and the amount of time the request took" do
      get '/'
      Rack::Tracker.last_request_time.should be_within(0.1).of(0.1)
      Rack::Tracker.total_requests.should_not eql 0
    end
  end
end
