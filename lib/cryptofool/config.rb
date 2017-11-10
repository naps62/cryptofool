module Cryptofool
  class Config
    def initialize
      @settings = JSON.parse(File.read("/home/naps62/.config/cryptofool/config.json"))
    end

    def exchanges
      @settings["exchanges"] || []
    end

    def method_missing(method, *args, &block)
      @settings[method.to_s]
    end
  end
end
