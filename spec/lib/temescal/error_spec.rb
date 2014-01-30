require "spec_helper"

describe Temescal::Error do
  let(:exception) { StandardError.new("Foobar") }
  let(:error)     { Temescal::Error.new(exception) }

  before do
    # This is admittedly a little hacky, but it's the best way to prevent
    # previously memoized configurations from polluting these tests.
    $_temescal_configuration = Temescal::Configuration.new
  end

  context "#message" do
    it "should return the configured default message if it is set in the configuration" do
      Temescal::Configuration.any_instance.stub(:default_message).and_return("Some other message.")

      expect(error.message).to eq "Some other message."
    end

    it "should return the exception's message if the default message is not configured" do
      expect(error.message).to eq "Foobar"
    end
  end

  context "#status" do
    it "should return 404 if the exception is an ActiveRecord::RecordNotFound" do
      exception = ActiveRecord::RecordNotFound.new
      error     = Temescal::Error.new(exception)

      expect(error.status).to eq 404
    end

    it "should return 404 if the exception is a Sinatra::NotFound" do
      exception = Sinatra::NotFound.new
      error     = Temescal::Error.new(exception)

      expect(error.status).to eq 404
    end

    it "should return the exception's status code if assigned" do
      exception.stub(:http_status).and_return(403)

      expect(error.status).to eq 403
    end

    it "should return 500 for all other exceptions" do
      expect(error.status).to eq 500
    end
  end

  context "#formatted" do
    it "should return a String formatted for log output" do
      exception.stub(:backtrace).and_return(["Line 1", "Line 2"])

      expect(error.formatted).to eq "\nStandardError: Foobar\n  Line 1\n  Line 2\n\n"
    end
  end

  context "#type" do
    it "should return the exception's class name" do
      expect(error.type).to eq "StandardError"
    end
  end

  context "#ignore?" do
    before do
      Temescal::Configuration.any_instance.stub(:ignored_errors).and_return([TypeError])
    end

    it "should return true if the exception type is configured as an ignored error" do
      error = Temescal::Error.new(TypeError.new)
      expect(error.ignore?).to be_true
    end

    it "should return false if the exception type is not an ignored error" do
      expect(error.ignore?).to be_false
    end
  end
end
