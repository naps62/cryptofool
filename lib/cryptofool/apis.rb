require "cryptofool/apis/coin_market_cap"
require "cryptofool/apis/blockchain"
require "cryptofool/apis/blockonomics"
require "cryptofool/apis/etherscan"
require "cryptofool/apis/bitfinex"
require "cryptofool/apis/cryptoid"
require "cryptofool/apis/cryptoid/dash"
require "cryptofool/apis/cryptoid/ltc"

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
        when "blockonomics.co" then Apis::Blockconomics
        when "etherscan.io" then Apis::Etherscan
        when "bitfinex" then Apis::Bitfinex
        when "chainz.cryptoid.info/dash" then Apis::Cryptoid::Dash
        when "chainz.cryptoid.info/ltc" then Apis::Cryptoid::LTC
        else raise "API Provider #{provider} unknown"
      end
    end
  end
end
