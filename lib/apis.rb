require "apis/blockchain"
require "apis/etherscan"

module Cryptofool
  class Apis
    def self.client_for(wallet)
      class_for(wallet["provider"]).new(wallet)
    end

    def self.class_for(provider)
      case provider
        when "blockchain.info" then Apis::Blockchain
        when "etherscan.io" then Apis::Etherscan
        else raise "API Provider #{provider} unknown"
      end
    end
  end
end
