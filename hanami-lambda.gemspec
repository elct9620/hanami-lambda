# frozen_string_literal: true

require_relative "lib/hanami/lambda/version"

Gem::Specification.new do |spec|
  spec.name = "hanami-lambda"
  spec.version = Hanami::Lambda::VERSION
  spec.authors = ["Aotokitsuruya"]
  spec.email = ["contact@aotoki.me"]

  spec.summary = "Hanami Lambda"
  spec.description = "Hanami Lambda is a gem that provides a way to run hanami application on AWS Lambda."
  spec.homepage = "https://github.com/elct9620/hanami-lambda"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/elct9620/hanami-lambda"
  spec.metadata["changelog_uri"] = "https://github.com/elct9620/hanami-lambda/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "zeitwerk", "~> 2.6"
  spec.add_dependency "hanami", "~> 2.0"
  spec.add_dependency "hanami-utils", "~> 2.0"
  spec.add_dependency "dry-struct", "~> 1.0"
  spec.add_dependency "dry-inflector", "~> 1.0"
  spec.add_development_dependency "rubocop", "~> 1.59"

  spec.metadata["rubygems_mfa_required"] = "true"
end
