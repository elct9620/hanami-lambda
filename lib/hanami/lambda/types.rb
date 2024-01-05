# frozen_string_literal: true

require "dry-struct"

module Hanami
  module Lambda
    module Types
      include Dry.Types(default: :params)
    end
  end
end
