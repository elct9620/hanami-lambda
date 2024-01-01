# frozen_string_literal: true

module Hanami
  module Lambda
    # The application to configure for AWS Lambda.
    #
    # @since 0.1.0
    class Application
      # @api private
      def self.inherited(subclass)
        super

        Hanami::Lambda.app = subclass
        subclass.extend(ClassMethods)
      end

      module ClassMethods
        # Dispatch event to the handler
        #
        # @api private
        # @since 0.1.0
        def call(event:, context:)
          handler = lookup(event: event, context: context)
          handler.call
        end

        # Lookup the handler for the given event
        #
        # @api private
        # @since 0.1.0
        def lookup(event:, context:)
          Rack.new(Hanami.app, event: event, context: context)
        end
      end
    end
  end
end
