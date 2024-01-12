# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

require "rubocop/rake_task"

RuboCop::RakeTask.new

task :steep do
  # Steep doesn't provide Rake integration yet,
  # but can do that ourselves
  require "steep"
  require "steep/cli"

  Steep::CLI.new(argv: ["check"], stdout: $stdout, stderr: $stderr, stdin: $stdin).run
end

task default: %i[spec rubocop steep]
