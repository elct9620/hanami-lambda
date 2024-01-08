# frozen_string_literal: true

module Hanami
  module Lambda
    HANDLER_KEY_NAMESPACE = "functions"

    # The application to configure for AWS Lambda.
    #
    # @since 0.1.0
    module Application
      # @since 0.2.0
      # @api private
      def self.extended(base)
        base.class_eval do
          prepare_load_path if respond_to?(:prepare_load_path)
        end
      end

      # Dispatch event to the handler
      #
      # @api private
      # @since 0.1.0
      def handle_lambda(event:, context:)
        lambda_dispatcher.call(event: event, context: context)
      end

      # Get lambda dispatcher
      #
      # @return [Hanami::Lambda::Dispatcher] the dispatcher
      #
      # @since 0.1.0
      def lambda_dispatcher
        @lambda_dispatcher ||= load_lambda_dispatcher
      end

      # Load lambda dispatcher
      #
      # @return [Hanami::Lambda::Dispatcher] the dispatcher
      #
      # @since 0.2.0
      # @api private
      def load_lambda_dispatcher
        if root.directory?
          dispatcher_path = File.join(root, LAMBDA_CONFIG_PATH)

          begin
            require dispatcher_path
          rescue LoadError => exception
            raise exception unless exception.path == dispatcher_path
          end
        end

        begin
          dispatcher_class = namespace.const_get(LAMBDA_CLASS_NAME)
          dispatcher_class.build(
            rack_app: app.rack_app,
            resolver: ->(to) { app.resolve("#{HANDLER_KEY_NAMESPACE}.#{to}") }
          )
        rescue NameError => exception
          raise exception unless exception.name == LAMBDA_CLASS_NAME
        end
      end
    end
  end
end
