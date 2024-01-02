# frozen_string_literal: true

require "zeitwerk"

# @see Hanami::Lambda
# @since 0.1.0
module Hanami
  # Make Hanami can be run on AWS Lambda.
  #
  # @since 0.1.0
  # @api private
  module Lambda
    LAMBDA_EVENT = "lambda.event"
    LAMBDA_CONTEXT = "lambda.context"

    @_mutex = Mutex.new

    # Returns the Hanami::Lambda application.
    #
    # @return [Hanami::Lambda::Application] the application
    # @raise [Hanami::Lambda::AppLoadError] if the application isn't configured
    #
    # @api public
    # @since 0.1.0
    def self.app
      @_mutex.synchronize do
        unless defined?(@_app)
          raise AppLoadError,
                "Hanami::Lambda.app is not yet configured. "
        end

        @_app
      end
    end

    # @api private
    # @since 0.1.0
    def self.app=(klass)
      @_mutex.synchronize do
        raise AppLoadError, "Hanami::Lambda.app is already configured." if instance_variable_defined?(:@_app)

        @_app = klass unless klass.name.nil?
      end
    end

    def self.call(event:, context:)
      app.boot
      app.call(event: event, context: context)
    end

    # @since 0.1.0
    # @api private
    def self.gem_loader
      @gem_loader ||= Zeitwerk::Loader.new.tap do |loader|
        root = File.expand_path("..", __dir__)
        loader.tag = "hanami-lambda"
        loader.inflector = Zeitwerk::GemInflector.new("#{root}/hanami-lambda.rb")
        loader.push_dir(root)
        loader.ignore(
          "#{root}/hanami-lambda.rb",
          "#{root}/hanami/lambda/{rake_tasks,version}.rb",
          "#{root}/hanami/lambda/support"
        )
        loader.inflector.inflect("lambda" => "Lambda")
      end
    end

    gem_loader.setup
    require_relative "lambda/version"
  end
end
