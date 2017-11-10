class Cryptofool::Normalizer
  @table = {
    "IOT" => "MIOTA"
  }

  def self.normalize_currency_symbol(symbol)
    @table[symbol] || symbol
  end
end
