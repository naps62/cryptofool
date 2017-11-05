require "blanket"

module Cryptofool
  class Apis
    class Blockchain
      def initialize(wallet)
        @wallet = wallet
      end

      def balance
        client.rawaddr(wallet["address"]).get.final_balance.to_f / ::Cryptofool::SATOSHI
      end

      private

      attr_reader :wallet

      def client
        Blanket.wrap("https://blockchain.info")
      end
    end
  end
end
