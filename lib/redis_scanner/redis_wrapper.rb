module RedisScanner
  class RedisWrapper
    def initialize(redis, options)
      @redis = redis
      @options = options
    end

    def scan(*args)
      @redis.scan *args
    end

    # total keys for given db(default 0)
    def total_keys
      ret = 0
      if (info = @redis.info) && (str = info["db#{@options[:db].to_i}"])
        if m = str.scan(/keys=(\d+)/)
          ret = m.flatten.first.to_i
        end
      end
      ret
    end

    def get_type_and_size(key)
      type = @redis.type key
      size = case type
        when "string"
          @redis.strlen key
        when "list"
          @redis.llen key
        when "hash"
          @redis.hlen key
        when "set"
          @redis.scard key
        when "zset"
          @redis.zcard key
        else
          1
      end
      [type, size.to_i]
    end

  end
end