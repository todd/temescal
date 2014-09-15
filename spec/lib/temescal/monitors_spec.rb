require "spec_helper"

describe Temescal::Monitors do
  let(:exception) { StandardError.new }

  context "MonitorsStrategy" do
    describe '.report' do
      it "raises an error" do
        expect { Temescal::Monitors::MonitorsStrategy.report(exception) }.to raise_error(NotImplementedError)
      end
    end
  end

  context "Airbrake" do
    describe '.report' do
      it "sends the exception to Airbrake" do
        Airbrake.stub(:send_notice)

        expect(Airbrake).to receive(:notify).with(exception)

        Temescal::Monitors::Airbrake.report exception
      end
    end
  end

  context "NewRelic" do
    describe '.report' do
      it "sends the exception to New Relic" do
        expect(NewRelic::Agent).to receive(:notice_error).with(exception)

        Temescal::Monitors::NewRelic.report exception
      end
    end
  end

  context 'Bugsnag' do
    describe '.report' do
      it "sends the exception to Bugsnag" do
        expect(Bugsnag).to receive(:notify).with(exception)

        Temescal::Monitors::Bugsnag.report exception
      end
    end
  end

    context 'Honeybadger' do
    describe '.report' do
      it "sends the exception to Honeybadger" do
        expect(Honeybadger).to receive(:notify).with(exception)

        Temescal::Monitors::Honeybadger.report exception
      end
    end
  end
end
