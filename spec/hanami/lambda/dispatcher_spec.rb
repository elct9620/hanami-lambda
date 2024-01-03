# frozen_string_literal: true

RSpec.describe Hanami::Lambda::Dispatcher do
  subject(:dispatcher) { described_class.new(Hanami.app) }

  let(:rack_app) do
    lambda do |_env|
      [200, {}, ["Hello from Rack"]]
    end
  end

  before do
    allow(Hanami.app).to receive(:rack_app).and_return(rack_app)
  end

  around do |example|
    module Example
      class Application < Hanami::Lambda::Application
      end
    end

    example.run

    Object.send(:remove_const, :Example)
    Hanami.remove_instance_variable(:@_app) if Hanami.instance_variable_defined?(:@_app)
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
