require "spec_helper"

describe Rack::RequestTracker do
  include Rack::Test::Methods

  before :all do
    class SubjectClass
      include Rack::RequestTracker

      # FIXME: This is crap, could actually use Rack::Tracker or extracting the call method so that it is easy to
      # autoamatically include in request like plugins
      def call env
        before_call env
        @app.call env
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

  context "when Rack::Tracker is initialised" do
    it "tracks the total requests made" do
      SubjectClass.should respond_to :total_requests
    end
  end
end
