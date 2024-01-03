# frozen_string_literal: true

require "tmpdir"

RSpec.describe Hanami::Lambda::Application do
  subject(:app) do
    Class.new(described_class) do
      register "ExampleApi"
    end
  end

  after do
    Hanami::Lambda.remove_instance_variable(:@_app) if Hanami::Lambda.instance_variable_defined?(:@_app)
  end

  it { is_expected.to be_a(Hanami::Slice::ClassMethods) }
  it { is_expected.to be_a(Hanami::App::ClassMethods) }
  it { is_expected.to be_a(Hanami::Lambda::Application::ClassMethods) }

  describe ".definitions" do
    subject(:definitions) { app.definitions }

    it { is_expected.to include(["ExampleApi", [], {}, nil]) }
  end

  describe ".register" do
    subject(:register) { app.register("ExampleApi") }

    it "registers the application" do
      expect { register }.to change { app.definitions.size }.by(1)
    end
  end

  describe ".call" do
    subject(:call) { app.call(event: event, context: context) }

    let(:rack_app) do
      lambda do |_env|
        [200, {}, ["Hello World"]]
      end
    end

    let(:event) { {} }
    let(:context) { double(:context, function_name: "ExampleApi") }

    before do
      allow(app).to receive(:app).and_return(rack_app)
    end

    it { is_expected.to include(statusCode: 200) }
    it { is_expected.to include(body: "Hello World") }
  end
end
