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
      Rack::Tracker::DSL.new :request_times do |plugin|
        plugin.variables :last_request_time => nil

        plugin.add_hook :before_call do |env|
          @start_time = Time.now
        end

        plugin.add_hook :after_call do |env|
          Rack::Tracker.last_request_time = (Time.now - @start_time)
        end
      end

      Rack::Tracker::DSL.new :requests do |plugin|
        plugin.variables :total_requests => 0

        plugin.add_hook :before_call do |env|
          Rack::Tracker.total_requests += 1
        end
      end
    end

    it "can track the number of requests and the amount of time the request took" do
      Rack::Tracker.add_plugins [:request_times, :requests ]
      get '/'
      Rack::Tracker.last_request_time.should be_within(0.1).of(0.1)
      Rack::Tracker.total_requests.should_not eql 0
    end
  end
end
