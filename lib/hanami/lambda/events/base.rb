# frozen_string_literal: true

module Hanami
  module Lambda
    module Events
      class Base < Dry::Struct
        transform_keys do |key|
          Hanami::Lambda.inflector.underscore(key).to_sym
        end
      end
    end
  end
end
