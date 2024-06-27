# frozen_string_literal: true

require "rack"

module Hanami
  module Lambda
    class Env
      def initialize(event:, headers:, context:)
        @event = event
        @headers = standardize_headers(headers)
        @context = context
      end

      def to_h
        {
          ::Rack::REQUEST_METHOD => @event["httpMethod"],
          ::Rack::PATH_INFO => @event["path"] || "",
          ::Rack::RACK_VERSION => ::Rack.release,
          ::Rack::RACK_INPUT => StringIO.new(@event["body"] || ""),
          ::Hanami::Lambda::LAMBDA_EVENT => @event,
          ::Hanami::Lambda::LAMBDA_CONTEXT => @context
        }.merge(@headers)
      end

      private

      def standardize_headers(headers)
        headers.transform_keys do |key|
          if ::Rack::Headers::KNOWN_HEADERS[key.downcase.tr("_", "-")]
            key.upcase.tr("-", "_")
          else
            "HTTP_#{key.upcase.tr('-', '_')}"
          end
        end
      end
    end
  end
end
