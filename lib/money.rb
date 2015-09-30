require "bigdecimal"
require "bigdecimal/util"

require "money/version"
require "money/errors"
require "money/conversion_rates"

class Money
  attr_reader :amount, :currency

  class << self
    def conversion_rates(base_currency, rates)
      @rates = Money::ConversionRates.new(base_currency, rates)
    end

    attr_reader :rates
  end

  def initialize(amount, currency)
    fail ConversionRatesNotSet unless Money.rates
    fail InvalidCurrency unless Money.rates.valid_currency?(currency)

    @amount = amount.to_d
    @currency = currency.to_s
  end

  def inspect
    format("%#.2f #{currency}", amount)
  end

  def convert_to(target_currency)
    fail InvalidCurrency unless Money.rates.valid_currency?(target_currency)

    rate = Money.rates.conversion_rate(currency, target_currency)
    Money.new(amount * rate, target_currency)
  end

  def +(other)
    other = other.convert_to(currency)
    Money.new(amount + other.amount, currency)
  end

  def -(other)
    other = other.convert_to(currency)
    Money.new(amount - other.amount, currency)
  end

  def /(other)
    fail ZeroDivisionError, "Division by zero is not supported" if other == 0
    Money.new(amount / other, currency)
  end

  def *(other)
    Money.new(amount * other, currency)
  end
end
