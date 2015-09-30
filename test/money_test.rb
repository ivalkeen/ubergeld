require "test_helper"

class MoneyTest < Minitest::Test
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

  def test_conversion_rates_setting
    Money.conversion_rates(
      "EUR",
      "USD" => 1.11,
      "Bitcoin" => 0.0047,
    )
  end
end
