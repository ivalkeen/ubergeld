require "ubergeld/version"

require "bigdecimal"
require "bigdecimal/util"

class Money
  class << self
    def conversion_rates(base_currency, rates)
      @base_currency = base_currency
      @rates = rates.freeze
    end

    attr_reader :rates, :base_currency
  end

  attr_reader :amount, :currency

  def initialize(amount, currency)
    @amount = amount.to_d
    @currency = currency.to_s
  end

  def inspect
    format("%#.2f #{currency}", amount)
  end

  def convert_to(target_currency)
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
end
