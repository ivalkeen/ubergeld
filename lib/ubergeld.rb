require "ubergeld/version"

require "bigdecimal"
require "bigdecimal/util"

class Money
  class << self
    def conversion_rates(_, _)
    end
  end

  attr_reader :amount, :currency

  def initialize(amount, currency)
    @amount = amount.to_d
    @currency = currency.to_s
  end

  def inspect
    format("%#.2f #{currency}", amount)
  end
end
