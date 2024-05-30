# frozen_string_literal: true

RSpec.describe Hanami::Lambda::Rack do
  subject(:rack) { described_class.new(app) }

  let(:app) do
    lambda do |_env|
      [200, {}, ["Hello from Rack"]]
    end
  end

  let(:event) do
    {
      "httpMethod" => "GET",
      "path" => "/",
      "body" => ""
    }
  end

  let(:headers) do
    {
      "Content-Type" => "text/plain",
      "X-Custom-Header" => "Custom Value"
    }
  end

  let(:context) { double(:context) }

  describe "#call" do
    subject(:call) { rack.call(event: event, context: context) }

    it { is_expected.to include(statusCode: 200) }
    it { is_expected.to include(body: "Hello from Rack") }
    it { is_expected.to include(headers: {}) }
  end

  describe "#env" do
    subject(:env) { rack.build_env(event, headers, context) }

    it { is_expected.to include(::Hanami::Lambda::LAMBDA_EVENT) }
    it { is_expected.to include(::Hanami::Lambda::LAMBDA_CONTEXT) }
    it { is_expected.to include("CONTENT_TYPE" => "text/plain") }
    it { is_expected.to include("HTTP_X_CUSTOM_HEADER" => "Custom Value") }
  end
end
