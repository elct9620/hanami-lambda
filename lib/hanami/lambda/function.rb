# frozen_string_literal: true

module Hanami
  module Lambda
    # The base class for handler
    #
    # @since 0.2.0
    class Function
      # Override the Ruby's hook for modules
      #
      # @param base [Class] the target class
      #
      # @since 0.2.0
      # @api private
      def self.inherited(subclass)
        super

        if instance_variable_defined?(:@event_type)
          subclass.instance_variable_set(:@event_type, @event_type)
        end
      end

      # Return the class which define the event type
      #
      # @return [Class] the class which define the event type
      #
      # @since 0.2.0
      # @api private
      def self.event_type
        @event_type || Event
      end

      # @since 0.2.0
      def call(event:, context:)
        event = self.class.event_type.new(event)
        handle(event, context)
      end

      protected

      def handle(_event, _context); end
    end
  end
end
