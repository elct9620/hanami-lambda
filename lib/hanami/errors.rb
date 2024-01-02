# frozen_string_literal: true

module Hanami
  module Lambda
    # Base error for Hanami::Lambda
    #
    # @api public
    # @since 0.2.0
    Error = Class.new(StandardError)

    # Raised when {Hanami::Lambda::Application} fails to load.
    #
    # @api public
    # @since 0.2.0
    AppLoadError = Class.new(Error)
  end
end
