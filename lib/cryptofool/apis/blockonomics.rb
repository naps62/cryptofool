require "blanket"

module Cryptofool
  class Apis
    class Blockconomics
      def initialize(wallet)
        @wallet = wallet
      end

      def balance
        response = client.balance.post(body: {
          addr: (wallet["xpub"] || wallet["address"]),
        })

        # TODO this request is causing an error
      end

      private

      attr_reader :wallet

      def client
        Blanket.wrap("https://www.blockonomics.co/api")
      end
    end
  end
end
