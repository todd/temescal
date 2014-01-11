require "spec_helper"

class Temescal::Monitors::Monitor;     end
class Temescal::Monitors::FakeMonitor; end
class Temescal::Monitors::FooMonitor;  end

describe Temescal::Configuration do
  let(:config) { Temescal::Configuration.new }

  context "#monitors=" do
    it "should add a list of valid monitor classes to the monitors array from snake-cased arguments" do
      config.monitors = :monitor, :fake_monitor, :foo_monitor

      expect(config.monitors).to eq [
                                      Temescal::Monitors::Monitor,
                                      Temescal::Monitors::FakeMonitor,
                                      Temescal::Monitors::FooMonitor
                                    ]
    end

    it "should raise an error if a monitor strategy is invalid" do
      expect { config.monitors = :foo }.to raise_error(NameError, /Foo is not a valid monitoring strategy/)
    end
  end
end
