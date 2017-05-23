# Evolis::PremiumSdk

This gem is a ruby interface for the [Evolis Premium SDK](http://www.evolis.com/software/evolis-premium-sdk-software-development-kit),
and are therefore based on the documentation from Evolis.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'evolis-premium_sdk'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install evolis-premium_sdk

## Usage

Require the library and then use the classes as their own services or set up a new Sdk class and use all the other classes from that.
The code documents the usage.

    require 'evolis/premium_sdk'
    sdk = Evolis::PremiumSdk::Sdk.new '127.0.0.1', 18000
    sdk.echo.echo 'Hello World'

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at [https://github.com/esselt/evolis-premium_sdk](https://github.com/esselt/evolis-premium_sdk). This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

