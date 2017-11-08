require "spec_helper"

describe "Running multiple plugins" do
  include Rack::Test::Methods

  let(:target_app) { double('The target application') }

  before :each do
    def app
      allow(target_app).to receive(:call).and_return([200, {'PATH_INFO' => '/'}, "Target application"])

      Nark::Middleware.new(target_app)
    end
  end

  describe "running two plugins that use the before hook" do
    let(:request_times_plugin) { create_plugin(:request_times) }
    let(:requests) { create_plugin(:requests) }

    before :each do
      Nark::Plugin.define :request_times, &request_times_plugin
      Nark::Plugin.define :requests, &requests
    end

    it "can track the number of requests and the amount of time the request took" do
      get '/'

      expect(Nark.last_request_time).to be_within(0.1).of(0.1)
      expect(Nark.total_requests).not_to eql(0)
    end
  end
end
