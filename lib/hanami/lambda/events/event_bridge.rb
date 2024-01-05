# frozen_string_literal: true

module Hanami
  module Lambda
    module Events
      class EventBridge < Base
        attribute :version, Types::Integer
        attribute :id, Types::String
        attribute :detail_type, Types::String
        attribute :source, Types::String
        attribute :account, Types::String
        attribute :time, Types::Time
        attribute :region, Types::String
        attribute :resources, Types::Array.of(Types::String)
        attribute :detail, Types::String
      end
    end
  end
end
