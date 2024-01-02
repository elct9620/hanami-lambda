# frozen_string_literal: true

module Hanami
  module Lambda
    # The application to configure for AWS Lambda.
    #
    # @since 0.1.0
    class Application
      @_mutex = Mutex.new

      # @api private
      def self.inherited(subclass)
        super

        require "hanami/setup"

        Hanami::Lambda.app = subclass
        subclass.extend(ClassMethods)
      end

      module ClassMethods
        # Dispatch event to the handler
        #
        # @api private
        # @since 0.1.0
        def call(event:, context:)
          dispatcher.call(event: event, context: context)
        end

        # Definitions of handlers
        #
        # @api private
        def definitions
          @definitions ||= []
        end

        # Register a handler
        #
        # @param name [String] the name of the handler
        # @param args [Array] the arguments to pass to the handler
        # @param kwargs [Hash] the keyword arguments to pass to the handler
        # @param block [Proc] the block to pass to the handler
        def register(name, *args, **kwargs, &block)
          definitions << [name, args, kwargs, block]
        end

        # Dispatcher
        #
        # @api private
        def dispatcher
          @dispatcher ||= build_dispatcher
        end

        # Hanami application
        #
        # @api private
        # @since 0.2.0
        def app
          Hanami.app
        end

        # Build Dispatcher
        #
        # @api private
        def build_dispatcher
          Dispatcher.new(app).tap do |dispatcher|
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
