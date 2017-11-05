require "blanket"

module Cryptofool
  class Apis
    class Etherscan
      def initialize(wallet)
        @wallet = wallet
      end

      def balance
        response = client.get(
          params: {
            module: :account,
            action: :balance,
            address: wallet["address"],
          }
        )

        response.result.to_f / Cryptofool::WEI
      end

      private

      attr_reader :wallet

      def client
        Blanket.wrap("https://api.etherscan.io/api")
      end
    end
  end
end
