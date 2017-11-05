require "blanket"

module Cryptofool
  class Apis
    class CoinMarketCap
      def ticker
        client.ticker.get
      end

      private

      def client
        Blanket.wrap("https://api.coinmarketcap.com/v1")
      end
    end
  end
end
