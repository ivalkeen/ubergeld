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
    in_base_currency = nil

    if currency == Money.base_currency
      in_base_currency = amount
    else
      to_base_rate = Money.rates[currency]
      in_base_currency = amount / to_base_rate
    end

    if target_currency == Money.base_currency
      Money.new(in_base_currency, Money.base_currency)
    else
      to_target_rate = Money.rates[target_currency]
      Money.new(in_base_currency * to_target_rate, target_currency)
    end
  end
end
