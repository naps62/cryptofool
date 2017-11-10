class Cryptofool::Converter
  def fetch_rates!
    @rates = Cryptofool::Apis::CoinMarketCap.new.ticker
  end

  def to_usd(amount, currency)
    rate = rates.find do |rate|
      rate.symbol == currency
    end

    amount * rate.price_usd.to_f
  end

  private

  attr_reader :rates
end
