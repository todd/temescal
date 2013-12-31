require 'spec_helper'
require 'logger'

describe Temescal::Middleware do
  context "Ok response" do
    let(:app) { ->(env) { [200, env, "app" ] } }

    let(:middleware) do
      Temescal::Middleware.new(app) do |config|
        config.logger = Logger.new(STDOUT)
      end
    end

    it "should render the application's response" do
      code, _, _ = middleware.call env_for('http://foobar.com')

      expect(code).to eq 200
    end
  end

  context "Bad response" do
    before do
      File.delete('test.log') if File.exists? 'test.log'
    end

    let(:app) { ->(env) { raise StandardError.new("Foobar") } }

    let(:middleware) do
      Temescal::Middleware.new(app) do |config|
        config.logger = Logger.new('test.log')
      end
    end

    it "should respond with a 500" do
      code, _, _ = middleware.call env_for("http://foobar.com")

      expect(code).to eq 500
    end

    it "should set the correct content type header" do
      _, headers, _ = middleware.call env_for("http://foobar.com")

      expect(headers["Content-Type"]).to eq "application/json"
    end

    it "should render a JSON response for the error" do
      _, _, response = middleware.call env_for('http://foobar.com')

      json = JSON.parse(response.first)["meta"]
      expect(json["status"]).to  eq 500
      expect(json["error"]).to   eq "StandardError"
      expect(json["message"]).to eq "Foobar"
    end

    it "should log the error" do
      middleware.call env_for('http://foobar.com')

      file = File.open('test.log', 'rb').to_a
      expect(file[2]).to eq "#<StandardError: Foobar>\n"
    end
  end

  def env_for url, opts={}
    Rack::MockRequest.env_for(url, opts)
  end
end
