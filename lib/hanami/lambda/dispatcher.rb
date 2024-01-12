# frozen_string_literal: true

module Hanami
  module Lambda
    # Dispatch Event to the Handler
    #
    # @api private
    class Dispatcher
      # @since 0.2.0
      # @api private
      DEFAULT_RESOLVER = ->(to) { to }

      attr_reader :rack_app, :handlers, :default, :resolver

      # @since 0.2.0
      def initialize(rack_app:, resolver: DEFAULT_RESOLVER)
        @handlers = {}
        @resolver = resolver
        @default = Rack.new(rack_app)
      end

      # Call the handler
      #
      # @param event [Hash] the event
      # @param context [Hash] the context
      #
      # @since 0.2.0
      def call(event:, context:)
        handler = lookup(event: event, context: context)
        return default.call(event: event, context: context) unless handler

        handler.call(event: event, context: context)
      end

      # Lookup the handler
      #
      # @param event [Hash] the event
      # @param context [Hash] the context
      #
      # @return [Handler] the handler
      def lookup(event:, context:) # rubocop:disable Lint/UnusedMethodArgument
        function_name = ENV.fetch("AWS_LAMBDA_FUNCTION_NAME", context.function_name)
        handlers
          .select { |name, _| function_name.include?(name) }
          .max_by { |name, _| name.length }
          &.last
      end

      # Register a handler
      #
      # @param name [String] the name of the handler
      # @param args [Array] the arguments to pass to the handler
      # @param kwargs [Hash] the keyword arguments to pass to the handler
      # @param block [Proc] the block to pass to the handler
      #
      # @since 0.2.0
      def register(name, *_args, to: nil)
        handlers[name] =
          if to.nil?
            @default
          else
            resolver.call(to)
          end
      end

      class << self
        # Definitions of handlers
        #
        # @api private
        def definitions
          @definitions ||= []
        end

        # Define function delegate action
        #
        # @param name [String] the name of the handler
        # @param args [Array] the arguments to pass to the handler
        # @param kwargs [Hash] the keyword arguments to pass to the handler
        # @param block [Proc] the block to pass to the handler
        def delegate(name, *args, **kwargs, &block)
          definitions << [name, args, kwargs, block]
        end

        # Build Dispatcher
        #
        # @api private
        def build(rack_app:, resolver:)
          new(rack_app: rack_app, resolver: resolver).tap do |dispatcher|
            definitions.each do |(name, args, kwargs, block)|
              if block
                dispatcher.register(name, *args, **kwargs, &block)
              else
                dispatcher.register(name, *args, **kwargs)
              end
            end
          end
        end
      end
    end
  end
end
