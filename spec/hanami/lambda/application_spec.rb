# frozen_string_literal: true

RSpec.describe Hanami::Lambda::Application do
  after do
    Hanami::Lambda.remove_instance_variable(:@_app) if Hanami::Lambda.instance_variable_defined?(:@_app)
  end

  subject(:app) { Class.new(described_class) }

  it { is_expected.to be_a(Hanami::Lambda::Application::ClassMethods) }

  describe ".lookup" do
    subject(:lookup) { app.lookup(event: event, context: context) }

    let(:event) { {} }
    let(:context) { double(:context) }

    before do
      allow(Hanami).to receive(:app).and_return(double("Hanami::Application"))
    end

    it { is_expected.to be_a(Hanami::Lambda::Rack) }
  end
end
