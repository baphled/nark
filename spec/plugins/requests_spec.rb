require "spec_helper"
require "#{File.dirname(__FILE__)}/../../lib/plugins/requests.rb"

describe Rack::Tracker::Plugins::Requests do
  include Rack::Test::Methods

  before :all do
    Rack::Tracker.add_plugins [ :requests ]
  end

  def app
    @target_app = mock('The target application')
    @target_app.stub(:call).and_return([200, {'PATH_INFO' => '/'}, "Target application"])
    Rack::Tracker::Middleware.new @target_app
  end

  context "when Rack::Tracker is initialised" do
    it "tracks the total requests made" do
      Rack::Tracker.should respond_to :total_requests
    end
  end

  context "sending a request" do
    it "should increment the total requests" do
      get '/'
      Rack::Tracker.total_requests.should be_an Numeric
    end
  end
end
