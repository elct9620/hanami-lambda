# frozen_string_literal: true

module Hanami
  module Lambda
    HANDLER_KEY_NAMESPACE = "functions"

    # The application to configure for AWS Lambda.
    #
    # @since 0.1.0
    module Application
      # Dispatch event to the handler
      #
      # @api private
      # @since 0.1.0
      def handle_lambda(event:, context:)
        dispatcher.call(event: event, context: context)
      end

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

      # Dispatcher
      #
      # @api private
      def dispatcher
        @dispatcher ||= build_dispatcher
      end

      # Build Dispatcher
      #
      # @api private
      def build_dispatcher
        Dispatcher.new(rack_app: app.rack_app,
                       resolver: ->(to) {
                         app.resolve("#{HANDLER_KEY_NAMESPACE}.#{to}")
                       }).tap do |dispatcher|
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
