require "thread"

module Cryptofool
  class CLI
    def initialize
      @config = Cryptofool::Config.new
    end

    def exchange_rates(*args)
      client = Cryptofool::Apis::CoinMarketCap.new

      response = client.ticker

      rates = []
      response.each do |ticker|
        rate_key = "price_#{config.base_currency.downcase}"

        if config.crypto_whitelist.member?(ticker.symbol)
          value = ticker[rate_key].to_f.round(2)
          puts "#{"%-5.5s" % ticker.symbol}  #{value}"
        end
      end
    end

    def portfolio(*args)
      balances = Hash.new { 0 }
      semaphore = Mutex.new

      exchange_threads = config.exchanges.map do |exchange|
        client = Cryptofool::Apis.client_for_exchange(exchange)

        client.balances.map do |balance|
          semaphore.synchronize do
            balances[balance[:currency]] += balance[:amount]
          end
        end
      end

      wallet_threads = config.wallets.map do |wallet|
        Thread.new do
          client = Cryptofool::Apis.client_for_wallet(wallet)

          semaphore.synchronize do
            balances[wallet["currency"]] += client.balance
          end
        end
      end

      exchange_threads.concat(wallet_threads).map(&:join)

      balances.each do |currency, balance|
        puts "#{currency} #{balance.round(2)}"
      end
    end

    private

    attr_reader :config
  end
end
