require "blanket"

module Cryptofool
  class Apis
    class Cryptoid
      class LTC
        include HTTParty

        base_uri "https://chainz.cryptoid.info/ltc"

        def initialize(wallet)
          @wallet = wallet
        end

        def balance
          response = self.class.get("/api.dws", query: {
            q: :getbalance,
            a: wallet["address"],
          })

          response.body.to_f
        end

        private

        attr_reader :wallet
      end
    end
  end
end
