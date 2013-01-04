require "spec_helper"

describe "Running multiple plugins" do
  include Rack::Test::Methods

  def app
    @target_app = mock('The target application')
    @target_app.stub(:call).and_return([200, {'PATH_INFO' => '/'}, "Target application"])
    Rack::Tracker::Middleware.new @target_app
  end

  describe "running two plugins that use the before hook" do
    before :each do
      Rack::Tracker.add_hook :before_call do |env|
        Rack::Tracker.total_requests += 1
      end

      # FIXME: These get automatically set when requiring the plugin. Need another solution for dealing with these
      Rack::Tracker.add_hook :before_call do |env|
        @start_time = Time.now
      end

      Rack::Tracker.add_hook :after_call do |env|
        request_time = (Time.now - @start_time)
        Rack::Tracker.last_request_time = request_time
        Rack::Tracker.request_times << {:url => env['PATH_INFO'], :request_time => request_time}
      end
    end

    it "can track the number of requests and the amount of time the request took" do
      # TODO: Refactor this once plugins no longer needed to be define conventionally
      Rack::Tracker.add_plugins [:request_times, :requests ]
      get '/'
      Rack::Tracker.last_request_time.should be_within(0.1).of(0.1)
      Rack::Tracker.total_requests.should_not eql 0
    end
  end
end
