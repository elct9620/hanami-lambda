# frozen_string_literal: true

require "tmpdir"

RSpec.describe Hanami::Lambda::Application do
  subject(:app) { Hanami.app }

  around do |example|
    module Example
      class Application < Hanami::App
        extend Hanami::Lambda::Application
        delegate "ExampleApi"
      end
    end

    example.run

    Object.send(:remove_const, :Example)
    Hanami.remove_instance_variable(:@_app) if Hanami.instance_variable_defined?(:@_app)
  end

  it { is_expected.to be_a(Hanami::Lambda::Application) }

  describe ".definitions" do
    subject(:definitions) { app.definitions }

    it { is_expected.to include(["ExampleApi", [], {}, nil]) }
  end

  describe ".delegate" do
    subject(:delegate) { app.delegate("ExampleApi") }

    it "registers the application" do
      expect { delegate }.to change { app.definitions.size }.by(1)
    end
  end

  describe ".handle_lambda" do
    subject(:call) { app.handle_lambda(event: event, context: context) }

    let(:rack_app) do
      lambda do |_env|
        [200, {}, ["Hello World"]]
      end
    end

    let(:event) { {} }
    let(:context) { double(:context, function_name: "ExampleApi") }

    before do
      allow(app).to receive(:rack_app).and_return(rack_app)
    end

    it { is_expected.to include(statusCode: 200) }
    it { is_expected.to include(body: "Hello World") }
  end
end
