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
        headers = event["headers"] || {}
        env = build_env(event, headers, context)
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
      def build_env(event, headers, context)
        Env.new(event: event, headers: headers, context: context).to_h
      end
    end
  end
end
