Hanami::Lambda
===

Hanami Lambda is a gem that provides a way to run hanami application on AWS Lambda.

## Status

[![Gem Version](https://badge.fury.io/rb/hanami-lambda.svg)](https://badge.fury.io/rb/hanami-lambda)
[![CI](https://github.com/elct9620/hanami-lambda/actions/workflows/main.yml/badge.svg)](https://github.com/elct9620/hanami-lambda/actions/workflows/main.yml)

## Rubies

**Hanami::Lambda** supports Ruby (MRI) 3.0+

## Installation

Add this line to your application's Gemfile:

```ruby
gem "hanami-lambda"
```

And then execute:

```
$ bundle install
```

Create `config/lambda.rb` with below content

```ruby
require 'hanami/lambda'

module MyApp # Rename to your app name
  class Lambda < Hanami::Lambda::Application
  end
end
```

Create `app/function.rb` as handler base class

```ruby
module MyApp
  class Function < Hanami::Lambda::Function
  end
end
```

> Generator is comming soon.

## Usage

Use `config/lambda.Hanami::Lambda.call` as the function handler

```yaml
# AWS SAM
Resources:
  MyFunction:
    Type: AWS::Serverless::Function
    Properties:
      CodeUri: .
      Handler: config/lambda.Hanami::Lambda.call
      Runtime: ruby3.2
```

### Delegate

If the lambda function isn't trigger by APIGateway, we can use `delegate` method to define the handler function.

```ruby
module MyApp
  class Lambda < Hanami::Lambda::Application
    delegate "MyFunction", to: "daily_task"
  end
end
```

> The IaC generated function will be `my-app-MyFunction-r8faNAo3iUqx` therefore the dispatcher will use include `MyFunction` to find targeted function

Add `app/functions/daily_task.rb` to define the handle action

```ruby
module MyApp
  module Functions
    class DailyTask < MyApp::Function
      def handle(event, context)
        # ...
      end
    end
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/elct9620/hanami-lambda.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
