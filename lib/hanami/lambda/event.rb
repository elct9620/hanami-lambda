# frozen_string_literal: true

require "hanami/utils/hash"

module Hanami
  module Lambda
    # Base event class
    #
    # @since 0.2.0
    class Event
      attr_reader :raw

      # @param event [Hash] the raw event from AWS Lambda
      # @return [Hanami::Lambda::Event]
      #
      # @since 0.2.0
      def initialize(event)
        @raw = event
        @event = Hanami::Utils::Hash.deep_symbolize(@raw)
        freeze
      end

      # Return the value of the given key
      #
      # @param key [Symbol] the key to fetch
      #
      # @return [Object,NilClass] the associated value if found
      #
      # @since 0.2.0
      def [](key)
        @event[key]
      end

      # Return an value associated with the given event key
      #
      # @param keys [Array<Symbol, Integer>] the keys to fetch
      #
      # @return [Object,NilClass] the associated value if found
      #
      # @since 0.2.0
      def get(*keys)
        @event.dig(*keys)
      end
      alias_method :dig, :get

      # Return the hash of the event
      #
      # @return [Hash] the hash of the event
      #
      # @since 0.2.0
      def to_h
        @event
      end
    end
  end
end
