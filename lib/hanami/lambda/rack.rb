# frozen_string_literal: true

require "rack"

module Hanami
  module Lambda
    # Rack interface for AWS Lambda.
    #
    # @api private
    # @since 0.1.0
    class Rack
      attr_reader :app

      # Initialize the Rack interface
      #
      # @since 0.1.0
      def initialize(app)
        @app = app
      end

      # Handle the request
      #
      # @return [Hash] the response
      #
      # @since 0.1.0
      def call(event:, context:)
        env = build_env(event, context)
        status_code, headers, body = app.call(env)

        {
          statusCode: status_code,
          headers: headers,
          body: body.join
        }
      end

      # Build the Rack environment
      #
      # @return [Hash] the Rack environment
      #
      # @since 0.1.0
      def build_env(event, context)
        {
          ::Rack::REQUEST_METHOD => event["httpMethod"],
          ::Rack::PATH_INFO => event["path"] || "",
          ::Rack::VERSION => ::Rack::VERSION,
          ::Rack::RACK_INPUT => StringIO.new(event["body"] || ""),
          ::Hanami::Lambda::LAMBDA_EVENT => event,
          ::Hanami::Lambda::LAMBDA_CONTEXT => context
        }
      end
    end
  end
end
