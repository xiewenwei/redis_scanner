module RedisScanner
  class Engine
    def initialize(redis, options)
      @redis = redis
      @options = options
    end

    def run
      convert_to_sorted_array scan
    end

    private

    def convert_to_sorted_array(stat)
      stat.to_a.sort do |x, y|
        if x[1] == y[1]
          x[0] <=> y[0]
        else
          y[1] <=> x[1]
        end
      end
    end

    def scan
      cursor = 0
      stat = Hash.new(0)
      while true
        if @options[:match]
          cursor, result = @redis.scan cursor, match: @options[:match]
        else
          cursor, result = @redis.scan cursor
        end
        result.each do |key|
          pattern = resolve_pattern(key)
          stat[pattern] += 1
        end
        cursor = cursor.to_i
        break if cursor == 0
      end
      stat
    end

    PATTERNS = [
      [/(:\d+:)/, ":<id>:"],
      [/(:\w{8}-\w{4}-\w{4}-\w{4}-\w{12}:)/, ":<uuid>:"],
      [/(:\d{4}-\d{2}-\d{2}:)/, ":<date>:"],
      [/(:\d+)$/, ":<id>"],
      [/(:\w{8}-\w{4}-\w{4}-\w{4}-\w{12})$/, ":<uuid>"],
      [/(:\d{4}-\d{2}-\d{2})$/, ":<date>"]
    ]

    def resolve_pattern(key)
      PATTERNS.each do |pattern, replacer|
        if m = pattern.match(key)
          key = key.sub(m[1], replacer)
          break
        end
      end
      key
    end
  end
end