require "test_helper"

class MoneyTest < Minitest::Test
  def setup
    Money.conversion_rates(
      "EUR",
      "USD" => 1.11,
      "Bitcoin" => 0.0047,
    )
  end

  def test_fails_if_no_conversion_rates
    Money.conversion_rates(nil)

    assert_raises(Money::ConversionRatesNotSet) do
      Money.new(1, "EUR")
    end
  end

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

  def test_currency_fails_if_unsuppored
    assert_raises(Money::InvalidCurrency) do
      Money.new(1, "Aurum")
    end
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

  def test_convert_to_fails_if_unsupported
    money = Money.new(10, "USD")
    assert_raises(Money::InvalidCurrency) do
      money.convert_to("Aurum")
    end
  end

  def test_convert_between_non_base_currencies
    money_in_dollars = Money.new(50, "USD")
    money_in_bitcoins = money_in_dollars.convert_to("Bitcoin")
    assert_equal("0.21 Bitcoin", money_in_bitcoins.inspect)
  end

  def test_sum
    money1 = Money.new(50, "USD")
    money2 = Money.new(25, "USD")
    result = money1 + money2
    assert_equal("75.00 USD", result.inspect)

    money1 = Money.new(50, "USD")
    money2 = Money.new(50, "EUR")
    result = money1 + money2
    assert_equal("105.50 USD", result.inspect)
  end

  def test_diffirence
    money1 = Money.new(50, "USD")
    money2 = Money.new(25, "USD")
    result = money1 - money2
    assert_equal("25.00 USD", result.inspect)

    money1 = Money.new(50, "EUR")
    money2 = Money.new(50, "USD")
    result = money1 - money2
    assert_equal("4.95 EUR", result.inspect)
  end

  def test_division
    money = Money.new(50, "EUR")
    result = money / 2
    assert_equal("25.00 EUR", result.inspect)

    money = Money.new(40, "USD")
    result = money / 4.5
    assert_equal("8.89 USD", result.inspect)
  end

  def test_division_by_zero_raises_error
    money = Money.new(50, "EUR")

    assert_raises(ZeroDivisionError) do
      money / 0
    end
  end

  def test_multiplication
    money = Money.new(50, "EUR")
    result = money * 2
    assert_equal("100.00 EUR", result.inspect)

    money = Money.new(40, "USD")
    result = money * 3.5
    assert_equal("140.00 USD", result.inspect)
  end
end
