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
      rates = nil
      converter = Cryptofool::Converter.new

      exchange_threads = config.exchanges.map do |exchange|
        Thread.new do
          client = Cryptofool::Apis.client_for_exchange(exchange)

          client.balances.map do |balance|
            currency = Cryptofool::Normalizer.normalize_currency_symbol(balance[:currency])
            semaphore.synchronize do
              balances[currency] += balance[:amount]
            end
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

      rates_thread = Thread.new do
        converter.fetch_rates!
      end

      exchange_threads.map(&:join)
      wallet_threads.map(&:join)
      rates_thread.join

      total_usd = 0

      balances.each do |currency, balance|
        usd_amount = converter.to_usd(balance, currency)
        total_usd += usd_amount
        puts "#{currency} #{balance.round(2)} (USD #{usd_amount.round(2)})"
      end

      puts "USD #{total_usd}"
    end

    private

    attr_reader :config
  end
end
