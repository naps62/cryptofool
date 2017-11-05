require "cryptofool/apis/blockchain"
require "cryptofool/apis/etherscan"
require "cryptofool/apis/bitfinex"

module Cryptofool
  class Apis
    def self.client_for_exchange(exchange)
      class_for(exchange).new
    end

    def self.client_for_wallet(wallet)
      class_for(wallet["provider"]).new(wallet)
    end

    def self.class_for(provider)
      case provider
        when "blockchain.info" then Apis::Blockchain
        when "etherscan.io" then Apis::Etherscan
        when "bitfinex" then Apis::Bitfinex
        else raise "API Provider #{provider} unknown"
      end
    end
  end
end
