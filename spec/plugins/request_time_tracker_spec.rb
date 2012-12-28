require "spec_helper"

describe Rack::TrackerPlugin::RequestTime do
  include Rack::Test::Methods

  before :each do
    class SubjectClass
      include Rack::TrackerPlugin::RequestTime
      include Rack::Caller

      def after_call env
        sleep 0.001
        super
      end
    end
  end

  after :each do
    Object.send :remove_const, :SubjectClass
  end

  def app
    @target_app = mock('The target application')
    @target_app.stub(:call).and_return([200, {}, "Target application"])
    SubjectClass.new @target_app
  end

  it "stores the average request time"

  describe "#request_times" do
    it "tracks the times each request has taken" do
      get '/'
      SubjectClass.request_times.should be_an Array
    end

    it "stores a requests path and request time" do
      get '/'
      SubjectClass.request_times.first[:url].should eql '/'
      SubjectClass.request_times.first[:request_time].should be_within(0.1).of(0.1)
    end
  end

  context "tracking the amount of time a request takes" do
    it "stores the amount of milliseconds a request has taken" do
      get '/'
      SubjectClass.last_request_time.should be_within(0.1).of(0.1)
    end
  end
end
