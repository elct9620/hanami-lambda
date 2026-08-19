# frozen_string_literal: true

RSpec.describe Hanami::Lambda::Env do
  subject(:env) { described_class.new(event: event, headers: headers, context: context) }

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

  describe "#to_h" do
    subject(:hash) { env.to_h }

    it { is_expected.to include(::Hanami::Lambda::LAMBDA_EVENT) }
    it { is_expected.to include(::Hanami::Lambda::LAMBDA_CONTEXT) }
    it { is_expected.to include("CONTENT_TYPE" => "text/plain") }
    it { is_expected.to include("HTTP_X_CUSTOM_HEADER" => "Custom Value") }
  end
end
