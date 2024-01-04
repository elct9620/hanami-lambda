# frozen_string_literal: true

RSpec.describe Hanami::Lambda::Dispatcher do
  subject(:dispatcher) { described_class.new(rack_app: rack_app) }

  let(:rack_app) do
    lambda do |_env|
      [200, {}, ["Hello from Rack"]]
    end
  end

  describe "#call" do
    subject(:call) { dispatcher.call(event: event, context: context) }

    let(:event) { {} }
    let(:context) { double(:context, function_name: "NonExist") }

    it { is_expected.to include(statusCode: 200) }
    it { is_expected.to include(headers: {}) }
    it { is_expected.to include(body: "Hello from Rack") }
  end
end
