require "blanket"
require "bitfinex"

module Cryptofool
  class Apis
    class Bitfinex
      def initialize
        @client = create_client
      end

      def balances
        client.balances.map do |balance|
          {
            currency: balance["currency"].upcase,
            amount: balance["available"].to_f
          }
        end
      end

      private

      attr_reader :wallet, :client

      def create_client
        config = Cryptofool::Config.new

        ::Bitfinex::Client.configure do |bfx|
          bfx.api_key = config.bitfinex_api_key
          bfx.secret = config.bitfinex_api_secret
        end

        ::Bitfinex::Client.new
      end
    end
  end
end
