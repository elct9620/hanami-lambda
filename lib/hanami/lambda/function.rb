# frozen_string_literal: true

module Hanami
  module Lambda
    # The base class for handler
    #
    # @since 0.2.0
    class Function
      # @since 0.2.0
      def call(event:, context:)
        handle(event, context)
      end

      protected

      def handle(_event, _context)
        raise NotImplementedError
      end
    end
  end
end
