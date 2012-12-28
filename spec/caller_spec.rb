require "spec_helper"

describe Rack::Caller do
  include Rack::Test::Methods

  class SubjectClass
    include Rack::Caller
  end

  def app
    @target_app = mock('The target application')
    @target_app.stub(:call).and_return([200, {}, "Target application"])
    SubjectClass.new(@target_app)
  end

  describe "#call" do
    it "calls to before_call" do
      SubjectClass.any_instance.should_receive :before_call
      get '/'
    end

    it "calls to after_call" do
      SubjectClass.any_instance.should_receive :after_call
      get '/'
    end
  end
end
