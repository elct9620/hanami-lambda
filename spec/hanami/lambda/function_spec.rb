# frozen_string_literal: true

RSpec.describe Hanami::Lambda::Function do
  subject(:handler) { function.new }

  let(:function) { Class.new(described_class) }
  let(:event) { {"foo" => "bar"} }
  let(:context) { double(:context) }

  context "when define event type" do
    subject(:event_type) { function.event_type }

    let(:function) do
      Class.new(described_class) do
        type Hash
      end
    end

    it { is_expected.to eq(Hash) }
  end

  describe "#call" do
    subject(:call) { handler.call(event: event, context: context) }

    it { is_expected.to be_nil }
  end
end
