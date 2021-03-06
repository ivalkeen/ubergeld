[![Build Status](https://travis-ci.org/ivalkeen/ubergeld.svg)](https://travis-ci.org/ivalkeen/ubergeld)

# Ubergeld

A Ruby gem to perform currency conversion and arithmetics with different currencies

## Installation

*Warning*: This gem is not pushed to rubygems (by purpose).

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.
To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Usage

```ruby
# Configure the currency rates with respect to a base currency (here EUR):
Money.conversion_rates('EUR', {
  'USD'     => 1.11,
  'Bitcoin' => 0.0047
})

# Instantiate money objects:
fifty_eur = Money.new(50, 'EUR')

# Get amount and currency:
fifty_eur.amount # => 50
fifty_eur.currency # => "EUR"
fifty_eur.inspect # => "50.00 EUR"

# Perform operations in different currencies:
twenty_dollars = Money.new(20, 'USD')

# Arithmetics:
fifty_eur + twenty_dollars # => 68.02 EUR
fifty_eur - twenty_dollars # => 31.98 EUR
twenty_dollars * 3 # => 60.00 USD
fifty_eur / 2 # => 25.00 EUR

# Comparisons (also in different currencies):
twenty_dollars == Money.new(20, 'USD') # => true
twenty_dollars == Money.new(30, 'USD')#  => false

fifty_eur_in_usd = fifty_eur.convert_to('USD') # => 55.50 USD
fifty_eur_in_usd == fifty_eur # => true

twenty_dollars > Money.new(5, 'USD') # => true
twenty_dollars < fifty_eur # => true
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ivalkeen/ubergeld.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
