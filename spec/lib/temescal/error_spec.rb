require "spec_helper"

describe Temescal::Error do
  let(:exception) { StandardError.new("Foobar") }
  let(:error)     { Temescal::Error.new(exception) }

  before do
    # This is admittedly a little hacky, but it's the best way to prevent
    # previously memoized configurations from polluting these tests.
    $_temescal_configuration = Temescal::Configuration.new
  end

  describe "#message" do
    it "returns the configured default message if it is set in the configuration" do
      allow_any_instance_of(Temescal::Configuration).to receive(:default_message).and_return("Some other message.")

      expect(error.message).to eq "Some other message."
    end

    it "returns the exception's message if the default message is not configured" do
      expect(error.message).to eq "Foobar"
    end
  end

  describe "#status" do
    it "returns 404 if the exception is an ActiveRecord::RecordNotFound" do
      exception = ActiveRecord::RecordNotFound.new
      error     = Temescal::Error.new(exception)

      expect(error.status).to eq 404
    end

    it "returns 404 if the exception is a Sinatra::NotFound" do
      exception = Sinatra::NotFound.new
      error     = Temescal::Error.new(exception)

      expect(error.status).to eq 404
    end

    it "returns the exception's status code if assigned" do
      allow(exception).to receive(:http_status).and_return(403)

      expect(error.status).to eq 403
    end

    it "returns 500 for all other exceptions" do
      expect(error.status).to eq 500
    end
  end

  describe "#formatted" do
    it "returns a String formatted for log output" do
      allow(exception).to receive(:backtrace).and_return(["Line 1", "Line 2"])

      expect(error.formatted).to eq "\nStandardError: Foobar\n  Line 1\n  Line 2\n\n"
    end
  end

  describe "#type" do
    it "returns the exception's class name" do
      expect(error.type).to eq "StandardError"
    end
  end

  describe "#ignore?" do
    before do
      allow_any_instance_of(Temescal::Configuration).to receive(:ignored_errors).and_return([TypeError])
    end

    it "returns true if the exception type is configured as an ignored error" do
      error = Temescal::Error.new(TypeError.new)
      expect(error.ignore?).to be true
    end

    it "returns false if the exception type is not an ignored error" do
      expect(error.ignore?).to be false
    end
  end
end
