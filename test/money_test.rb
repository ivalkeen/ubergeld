require "test_helper"

class MoneyTest < Minitest::Test
  Money.conversion_rates(
    "EUR",
    "USD" => 1.11,
    "Bitcoin" => 0.0047,
  )

  def test_conversion_rates_set
    assert_equal("EUR", Money.base_currency)
    assert_equal(1.11, Money.rates["USD"])
    assert_equal(0.0047, Money.rates["Bitcoin"])
  end

  def test_amount
    money = Money.new(50, "EUR")
    assert_equal(50, money.amount)

    money = Money.new(20, "USD")
    assert_equal(20, money.amount)
  end

  def test_currency
    money = Money.new(50, "EUR")
    assert_equal("EUR", money.currency)

    money = Money.new(20, "USD")
    assert_equal("USD", money.currency)
  end

  def test_inspect
    money = Money.new(50, "EUR")
    assert_equal("50.00 EUR", money.inspect)

    money = Money.new(20.5, "USD")
    assert_equal("20.50 USD", money.inspect)
  end

  def test_convert_from_base_currency
    money = Money.new(50, "EUR")
    money_in_dollars = money.convert_to("USD")
    assert_equal("55.50 USD", money_in_dollars.inspect)
  end

  def test_convert_to_base_currency
    money_in_dollars = Money.new(55.5, "USD")
    money = money_in_dollars.convert_to("EUR")
    assert_equal("50.00 EUR", money.inspect)
  end

  def test_convert_between_non_base_currencies
    money_in_dollars = Money.new(50, "USD")
    money_in_bitcoins = money_in_dollars.convert_to("Bitcoin")
    assert_equal("0.21 Bitcoin", money_in_bitcoins.inspect)
  end
end
