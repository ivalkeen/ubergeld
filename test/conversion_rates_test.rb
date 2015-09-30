require "test_helper"

class ConversionRatesTest < Minitest::Test
  def setup
    @rates = Money::ConversionRates.new(
      "EUR",
      "USD" => 1.11,
      "Bitcoin" => 0.0047,
    )
  end

  def test_base_currency
    assert_equal("EUR", @rates.base_currency)
  end

  def test_rates
    assert_equal({ "USD" => 1.11, "Bitcoin" => 0.0047 }, @rates.rates)
  end

  def test_base_currency_frozen
    assert(@rates.base_currency.frozen?)
  end

  def test_rates_frozen
    assert(@rates.rates.frozen?)
  end

  def test_fails_if_incorrect_base_currency
    assert_raises(ArgumentError) do
      Money::ConversionRates.new("")
    end
  end

  def test_if_incorrect_rates
    assert_raises(ArgumentError) do
      Money::ConversionRates.new("EUR", "" => 1.11)
    end

    assert_raises(ArgumentError) do
      Money::ConversionRates.new("EUR", "USD" => "hello")
    end
  end

  def test_valid_currency_base_currency
    assert(@rates.valid_currency?("EUR"))
  end

  def test_valid_currency_rate_currency
    assert(@rates.valid_currency?("USD"))
  end

  def test_valid_currency_not_found
    refute(@rates.valid_currency?("Aurum"))
  end

  def test_conversion_rate_one_for_same_currency
    assert_equal(1, @rates.conversion_rate("EUR", "EUR"))
    assert_equal(1, @rates.conversion_rate("USD", "USD"))
  end

  def test_conversion_rate_from_base
    assert_equal(1.11, @rates.conversion_rate("EUR", "USD"))
  end

  def test_conversion_rate_to_base
    assert_equal(1.to_d / 1.11, @rates.conversion_rate("USD", "EUR"))
  end

  def test_conversion_rate_between_not_base
    assert_equal(1.to_d / 1.11 * 0.0047, @rates.conversion_rate("USD", "Bitcoin"))
  end
end
