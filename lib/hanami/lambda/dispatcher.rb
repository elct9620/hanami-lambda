# frozen_string_literal: true

module Hanami
  module Lambda
    # Dispatch Event to the Handler
    #
    # @api private
    class Dispatcher
      attr_reader :app, :handlers

      def initialize(app)
        @app = app
        @handlers = {}
      end

      # Call the handler
      #
      # @param event [Hash] the event
      # @param context [Hash] the context
      #
      # @since 0.2.0
      def call(event:, context:)
        handler = lookup(event: event, context: context)
        handler.call(event: event, context: context)
      end

      # Lookup the handler
      #
      # @param event [Hash] the event
      # @param context [Hash] the context
      #
      # @return [Handler] the handler
      def lookup(event:, context:) # rubocop:disable Lint/UnusedMethodArgument
        function_name = context.function_name
        handlers[function_name]
      end

      # Register a handler
      #
      # @param name [String] the name of the handler
      # @param args [Array] the arguments to pass to the handler
      # @param kwargs [Hash] the keyword arguments to pass to the handler
      # @param block [Proc] the block to pass to the handler
      #
      # @since 0.2.0
      def register(name, ...)
        handlers[name] = Rack.new(app)
      end
    end
  end
end
