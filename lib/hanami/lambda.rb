# frozen_string_literal: true

require "zeitwerk"
require "dry-struct"
require "hanami"

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

    LIB_DIR = "lib"
    private_constant :LIB_DIR

    @_mutex = Mutex.new

    # Return the application
    #
    # @api public
    # @since 0.1.0
    #
    # @return [Hanami::Lambda::Application] the application
    def self.app
      Hanami.app
    end

    # Run the application
    #
    # @api public
    def self.call(event:, context:)
      prepare_load_path
      app.boot
      app.call(event: event, context: context)
    end

    # Prepare the load path
    #
    # @since 0.2.0
    # @api private
    private_class_method def self.prepare_load_path
      lib_path = File.join(Dir.pwd, LIB_DIR)
      $LOAD_PATH.unshift(lib_path) unless $LOAD_PATH.include?(lib_path)
    end

    # Inflector to convert event key
    #
    # @return [Dry::Inflector]
    #
    # @since 0.2.0
    # @api private
    def self.inflector
      @_mutex.synchronize do
        return @inflector if defined?(@inflector)

        @inflector ||= Dry::Inflector.new
      end

      @inflector
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
