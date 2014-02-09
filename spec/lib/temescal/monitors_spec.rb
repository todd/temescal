require "spec_helper"

describe Temescal::Monitors do
  let(:exception) { StandardError.new }

  context "MonitorsStrategy" do
    it "should raise an error when the report method is called" do
      expect { Temescal::Monitors::MonitorsStrategy.report(exception) }.to raise_error(NotImplementedError)
    end
  end

  context "Airbrake" do
    it "should send the exception to Airbrake when report is called" do
      Airbrake.stub(:send_notice)

      expect(Airbrake).to receive(:notify).with(exception)

      Temescal::Monitors::Airbrake.report exception
    end
  end

  context "NewRelic" do
    it "should send the exception to New Relic when report is called" do
      expect(NewRelic::Agent).to receive(:notice_error).with(exception)

      Temescal::Monitors::NewRelic.report exception
    end
  end

  context 'Bugsnag' do
    it "should send the exception to Bugsnag when report is called" do
      expect(Bugsnag).to receive(:notify).with(exception)

      Temescal::Monitors::Bugsnag.report exception
    end
  end
end
