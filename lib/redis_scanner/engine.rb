require "ruby-progressbar"

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

    def total_keys
      ret = 0

      if (info = @redis.info) && (str = info["db#{@options[:db].to_i}"])
        if m = str.scan(/keys=(\d+)/)
          ret = m.flatten.first.to_i
        end
      end

      ret
    end

    def create_progress_bar
      ProgressBar.create(
        title: "Keys",
        format: '%a %bᗧ%i %p%% %t',
        progress_mark: ' ',
        remainder_mark: '･',
        total: total_keys)
    end

    def scan
      cursor = 0
      stat = Hash.new(0)

      bar = create_progress_bar
      while true
        if @options[:match]
          cursor, result = @redis.scan cursor, match: @options[:match]
        else
          cursor, result = @redis.scan cursor
        end
        result.each do |key|
          pattern = resolve_pattern(key)
          stat[pattern] += 1
          bar.increment
        end
        cursor = cursor.to_i
        break if cursor == 0
      end
      bar.finish

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