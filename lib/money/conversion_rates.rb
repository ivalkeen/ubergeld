class Money
  class ConversionRates
    attr_reader :base_currency, :rates

    def initialize(base_currency, rates)
      @base_currency = base_currency.to_s.freeze

      fail ArgumentError, "base_currency is not provided" if @base_currency.empty?

      @rates = rates.each_with_object({}) do |(k, v), memo|
        currency = k.to_s
        rate = BigDecimal.new(v.to_s)

        fail ArgumentError, "rates are not valid" if currency.empty?
        fail ArgumentError, "rates are not valid" if rate == 0

        memo[currency] = rate
      end.freeze
    end

    def valid_currency?(currency)
      base_currency == currency || rates[currency]
    end

    def conversion_rate(source_currency, target_currency)
      return 1 if source_currency == target_currency
      to_base_rate(source_currency) * from_base_rate(target_currency)
    end

    private

    def to_base_rate(currency)
      return 1 if currency == base_currency
      1.to_d / rates[currency]
    end

    def from_base_rate(currency)
      return 1 if currency == base_currency
      rates[currency]
    end
  end
end
