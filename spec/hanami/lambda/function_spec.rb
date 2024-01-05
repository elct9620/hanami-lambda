# frozen_string_literal: true

RSpec.describe Hanami::Lambda::Function do
  subject(:function) { described_class.new }

  let(:event) { {"foo" => "bar"} }
  let(:context) { double(:context) }

  describe "#call" do
    subject(:call) { function.call(event: event, context: context) }

    it { is_expected.to be_nil }
  end
end
