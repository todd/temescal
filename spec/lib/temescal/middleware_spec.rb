require "spec_helper"

describe Temescal::Middleware do
  context "Ok response" do
    let(:app) { ->(env) { [200, env, "app" ] } }

    let(:middleware) do
      Temescal::Middleware.new(app)
    end

    it "should render the application's response" do
      code, _, _ = middleware.call env_for('http://foobar.com')

      expect(code).to eq 200
    end
  end

  context "Bad response" do
    before do
      Temescal::Monitors::NewRelic.stub(:report)
      $stderr.stub(:print)

      # Travis automatically sets RACK_ENV=test
      # Need to override for tests to run correctly.
      ENV["RACK_ENV"] = nil
    end

    let(:app) { ->(env) { raise StandardError.new("Foobar") } }

    let(:middleware) do
      Temescal::Middleware.new(app) do |config|
        config.monitors = :new_relic
      end
    end

    it "should respond with a 500 if the exception does not have a http_status attribute" do
      code, _, _ = middleware.call env_for("http://foobar.com")

      expect(code).to eq 500
    end

    it "should respond with the appropriate status if the exception has a http_status attribute" do
      StandardError.any_instance.stub(:http_status).and_return(403)

      code, _, _ = middleware.call env_for("http://foobar.com")

      expect(code).to eq 403
    end

    it "should set the correct content type header" do
      _, headers, _ = middleware.call env_for("http://foobar.com")

      expect(headers["Content-Type"]).to eq "application/json"
    end

    it "should render a JSON response for the error" do
      _, _, response = middleware.call env_for("http://foobar.com")

      json = JSON.parse(response.first)["meta"]
      expect(json["status"]).to  eq 500
      expect(json["error"]).to   eq "StandardError"
      expect(json["message"]).to eq "Foobar"
    end

    it "should log the error" do
      expect($stderr).to receive(:print).with(an_instance_of String)

      middleware.call env_for("http://foobar.com")
    end

    it "should report the error to the specified monitors" do
      expect(Temescal::Monitors::NewRelic).to receive(:report).with(an_instance_of StandardError)

      middleware.call env_for("http://foobar.com")
    end

    context "with default_message set" do
      it "should build a response with the specified message instead of the exception message" do
        middleware = Temescal::Middleware.new(app) do |config|
          config.default_message = "An error has occured - we'll get on it right away!"
        end

        _, _, response = middleware.call env_for("http://foobar.com")

        json = JSON.parse(response.first)["meta"]
        expect(json["message"]).to eq "An error has occured - we'll get on it right away!"
      end
    end
  end

  context "Override middleware to raise exception" do
    before do
      $stderr.stub(:print)
    end

    let(:app) { ->(env) { raise StandardError.new("Foobar") } }

    let(:middleware) do
      Temescal::Middleware.new(app) do |config|
        config.raise_errors = true
      end
    end

    it "should raise the error" do
      expect { middleware.call env_for("http://foobar.com") }.to raise_error StandardError
    end
  end

  def env_for url, opts={}
    Rack::MockRequest.env_for(url, opts)
  end
end
