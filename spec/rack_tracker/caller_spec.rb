require "spec_helper"

describe Rack::Caller do
  include Rack::Test::Methods

  before :each do
    class SubjectClass
      include Rack::Caller
    end

    def app
      @target_app = mock('The target application')
      @target_app.stub(:call).and_return([200, {}, "Target application"])
      SubjectClass.new(@target_app)
    end
  end

  after :each do
    Object.send :remove_const, :SubjectClass
  end

  describe "#call" do
    it "triggers before and after hooks at least twice" do
      SubjectClass.any_instance.should_receive(:trigger_hook).at_least(:twice)
      get '/'
    end
  end
end
