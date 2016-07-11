# -*- encoding : utf-8 -*-

module RedisScanner
  class Redis
    attr_reader :client

    def initialize(options)
      @options = options
      @client = ::Redis.new extract_redis_options(options)
    end

    def scan(*args)
      @client.scan *args
    end

    # total keys for given db(default 0)
    def total_keys
      ret = 0
      if (info = @client.info) && (str = info["db#{@options[:db].to_i}"])
        if m = str.scan(/keys=(\d+)/)
          ret = m.flatten.first.to_i
        end
      end
      ret
    end

    def get_type_and_size(key)
      type = @client.type key
      size = case type
        when "string"
          @client.strlen key
        when "list"
          @client.llen key
        when "hash"
          @client.hlen key
        when "set"
          @client.scard key
        when "zset"
          @client.zcard key
        else
          1
      end
      [type, size.to_i]
    end

    private

    def extract_redis_options(options)
      result = {}
      [:host, :port, :socket, :password, :db].each do |key|
        result[key] = options[key]
      end
      result
    end
  end
end