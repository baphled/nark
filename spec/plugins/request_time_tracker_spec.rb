require "spec_helper"

describe Rack::RequestTimeTracker do
  include Rack::Test::Methods

  before :all do
    class SubjectClass
      include Rack::RequestTimeTracker

      def initialize app
        @app = app
      end

      # FIXME: This is crap, could actually use Rack::Tracker or extracting the call method so that it is easy to
      # autoamatically include in request like plugins
      def call env
        before_call env
        response = @app.call env
        after_call env
        response
      end

      def after_call env
        sleep 0.4
        super
      end
    end
  end

  after :all do
    Object.send :remove_const, :SubjectClass
  end

  def app
    @target_app = mock('The target application')
    @target_app.stub(:call).and_return([200, {}, "Target application"])
    SubjectClass.new @target_app
  end

  it "stores the average request time"

  context "tracking the amount of time a request takes" do
    it "times a request" do
      get '/'
      SubjectClass.last_request_time.should be_within(0.1).of(0.4)
    end
  end
end
