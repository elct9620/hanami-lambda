# frozen_string_literal: true

module Hanami
  module Lambda
    module Events
      class Base < Dry::Struct
        transform_keys do |key|
          key.gsub("-", "_").to_sym
        end
      end
    end
  end
end
