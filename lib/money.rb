require "bigdecimal"
require "bigdecimal/util"

require "money/version"
require "money/errors"
require "money/conversion_rates"
require "money/inspectable"

#
# This class allows to perform currency conversion and arithmetics with different currencies
# To be able to create new instances, conversion rates must be set (see #conversion_rates)
#
class Money
  attr_reader :amount, :currency

  include Comparable

  class << self
    # Set conversion rates
    #
    # @example
    #   Money.conversion_rates('EUR', {
    #     'USD' => 1.11,
    #     'Bitcoin' => 0.0047
    #   })
    #
    # @param base_currency [String] the name of the currency to be used as the base for conversions to other currencies
    # @param rates [Hash] key value pairs where key is the currency code and value is the conversion rate from the base currency
    def conversion_rates(base_currency, rates)
      @rates = Money::ConversionRates.new(base_currency, rates)
    end

    attr_reader :rates
  end

  # @example
  #   Money.new(50, "EUR") # => 50.00 EUR
  #   Money.new(20, "USD") # => 20.00 USD
  #
  # @param amount [Number] value in the units of the highest denomination
  # @param currency [String] currency code: "EUR", "USD", ...
  def initialize(amount, currency)
    fail ConversionRatesNotSet unless Money.rates
    fail InvalidCurrency unless Money.rates.valid_currency?(currency)

    @amount = amount.to_d
    @amount.extend(Inspectable)
    @currency = currency.to_s
  end

  # Converts currency to `target_currency`
  #
  # @example
  #   Money.new(50, "EUR").convert_to("USD") # => 55.50 USD
  #
  # @param target_currency [String] The code of the currency to convert to
  # @returns [Money] result of the conversion
  def convert_to(target_currency)
    fail InvalidCurrency unless Money.rates.valid_currency?(target_currency)

    rate = Money.rates.conversion_rate(currency, target_currency)
    Money.new(amount * rate, target_currency)
  end

  # Calculates sum for two money objects
  #
  # @example
  #   Money.new(50, "EUR") + Money.new(10, "EUR") # => 60.00 EUR
  #
  # @param other [Money] money object to sum with
  # @returns [Money] result of the sum
  def +(other)
    other = other.convert_to(currency)
    Money.new(amount + other.amount, currency)
  end

  # Calculates difference between two money objects
  #
  # @example
  #   Money.new(50, "EUR") - Money.new(10, "EUR") # => 40.00 EUR
  #
  # @param other [Money] money to calculate difference with
  # @returns [Money] result of the difference
  def -(other)
    other = other.convert_to(currency)
    Money.new(amount - other.amount, currency)
  end

  # Divides money object by number
  #
  # @example
  #   Money.new(60, "EUR") / 2 # => 30.00 EUR
  #
  # @param other [Number] divider
  # @returns [Money] result of the division
  def /(other)
    fail ZeroDivisionError, "Division by zero is not supported" if other == 0
    Money.new(amount / other, currency)
  end

  # Multiplication of the money object by number
  #
  # @example
  #   Money.new(60, "EUR") * 2 # => 120.00 EUR
  #
  # @param other [Number] multiplier
  # @returns [Money] result of the multiplication
  def *(other)
    Money.new(amount * other, currency)
  end

  # Compare two Money objects regardless of their currency
  #
  # @example
  #   Money.new(10, "EUR").convert_to("USD") == Money.new(10, "EUR") # => true
  #   Money.new(11, "EUR").convert_to("USD") > Money.new(10, "EUR") # => true
  #   Money.new(9, "EUR").convert_to("USD") < Money.new(10, "EUR") # => true
  #
  # @param other [Money] object to compare with
  # @returns [Boolean] true if objects have the same value (currency may be different)
  def <=>(other)
    other = other.convert_to(currency)
    amount.round(2) <=> other.amount.round(2)
  end

  def inspect
    format("%#.2f #{currency}", amount)
  end
end
