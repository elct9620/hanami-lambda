# frozen_string_literal: true

require "rack"

module Hanami
  module Lambda
    class Env
      def initialize(event:, headers:, context:)
        @event = event
        @headers = headers
        @content_type = extract_content_type
        @http_headers = transform_http_headers
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
        }.tap do |env|
          env["CONTENT_TYPE"] = @content_type if @content_type
        end.merge(@http_headers)
      end

      private

      def extract_content_type
        @headers.delete("Content-Type") ||
          @headers.delete("content-type") ||
          @headers.delete("CONTENT_TYPE")
      end

      def transform_http_headers
        @headers.transform_keys { |k| "HTTP_#{k.upcase.tr('-', '_')}" }
      end
    end
  end
end
