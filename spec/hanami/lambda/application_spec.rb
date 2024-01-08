# frozen_string_literal: true

require "tmpdir"

RSpec.describe Hanami::Lambda::Application do
  subject(:app) { Hanami.app }

  around do |example|
    tmpdir = Dir.mktmpdir
    Dir.chdir(tmpdir) do
      Pathname.new(tmpdir).join("config").mkpath

      File.write "config/lambda.rb", <<~RUBY
        module Example
          class Lambda < Hanami::Lambda::Dispatcher
            delegate "ExampleApi"
          end
        end
      RUBY

      module Example
        class Application < Hanami::App
          extend Hanami::Lambda::Application
        end
      end

      example.run
    end

    Object.send(:remove_const, :Example) if Object.const_defined?(:Example)
    Hanami.remove_instance_variable(:@_app) if Hanami.instance_variable_defined?(:@_app)
  end

  it { is_expected.to be_a(Hanami::Lambda::Application) }

  describe ".handle_lambda" do
    subject(:call) { app.handle_lambda(event: event, context: context) }

    let(:rack_app) do
      lambda do |_env|
        [200, {}, ["Hello World"]]
      end
    end

    let(:event) { {} }
    let(:context) { double(:context, function_name: "ExampleApi") }

    before do
      allow(app).to receive(:rack_app).and_return(rack_app)
    end

    it { is_expected.to include(statusCode: 200) }
    it { is_expected.to include(body: "Hello World") }
  end
end
