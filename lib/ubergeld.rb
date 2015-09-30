require "ubergeld/version"

require "bigdecimal"
require "bigdecimal/util"

class Money
  class InvalidCurrency < StandardError; end
  class ConversionRatesNotSet < StandardError; end

  class << self
    def conversion_rates(base_currency, rates = {})
      @base_currency = base_currency.to_s

      @rates = rates.each_with_object({}) do |(k, v), memo|
        memo[k.to_s] = v.to_d
      end.freeze
    end

    attr_reader :rates, :base_currency
  end

  attr_reader :amount, :currency

  def initialize(amount, currency)
    fail ConversionRatesNotSet unless valid_rates?
    fail InvalidCurrency unless valid_currency?(currency)

    @amount = amount.to_d
    @currency = currency.to_s
  end

  def inspect
    format("%#.2f #{currency}", amount)
  end

  def convert_to(target_currency)
    fail InvalidCurrency unless valid_currency?(target_currency)

    in_base_currency = convert_to_base
    in_base_currency.convert_from_base(target_currency)
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

  protected

  def convert_to_base
    if currency == Money.base_currency
      self
    else
      rate = Money.rates[currency]
      Money.new(amount / rate, Money.base_currency)
    end
  end

  def convert_from_base(target_currency)
    if currency == target_currency
      self
    else
      rate = Money.rates[target_currency]
      Money.new(amount * rate, target_currency)
    end
  end

  def valid_currency?(currency)
    Money.base_currency == currency ||
      (Money.rates[currency] && Money.rates[currency] > 0)
  end

  def valid_rates?
    Money.base_currency && Money.base_currency.length > 0 && Money.rates
  end
end
