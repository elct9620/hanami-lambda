# frozen_string_literal: true

RSpec.describe Hanami::Lambda::Event do
  subject(:event) { described_class.new(event_data) }

  let(:event_data) do
    {
      "name" => "RSpec",
      "children" => [
        {"name" => "RSpec 1"},
        {"name" => "RSpec 2"}
      ]
    }
  end

  it { is_expected.to be_frozen }

  describe "#[]" do
    it "is expected to return :name value" do
      expect(event[:name]).to eq("RSpec")
    end

    it "returns nil if the key is string" do
      expect(event["name"]).to be_nil
    end
  end

  describe "#dig" do
    it "is expected to return nested value" do
      expect(event.dig(:children, 0, :name)).to eq("RSpec 1")
    end

    it "returns nil if the key is string" do
      expect(event.dig("children", 0, "name")).to be_nil
    end
  end
end
