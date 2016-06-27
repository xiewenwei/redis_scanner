require "ruby-progressbar"

module RedisScanner
  class Engine
    def initialize(redis, options)
      @redis = redis
      @options = options
    end

    def run
      result = scan
      result.values.sort
    end

    private

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
      total = total_keys
      bar = ProgressBar.create(
        title: "Keys",
        format: '%a %bᗧ%i %p%% %t',
        progress_mark: ' ',
        remainder_mark: '･',
        total: total)
      bar.log "total keys is #{total}"
      bar
    end

    def scan
      cursor = 0
      stat = Hash.new {|hash, key| hash[key] = Pattern.new(key) }

      bar = create_progress_bar
      while true
        if @options[:match]
          cursor, result = @redis.scan cursor, match: @options[:match]
        else
          cursor, result = @redis.scan cursor
        end
        result.each do |key|
          pattern = extract_pattern(key)
          stat[pattern].increment
          bar.increment
        end
        cursor = cursor.to_i
        break if cursor == 0
      end
      bar.finish

      stat
    end

    RULES = [
      [/(:\d+:)/, ":<id>:"],
      [/(:\w{8}-\w{4}-\w{4}-\w{4}-\w{12}:)/, ":<uuid>:"],
      [/(:\d{4}-\d{2}-\d{2}:)/, ":<date>:"],
      [/(:\d+)$/, ":<id>"],
      [/(:\w{8}-\w{4}-\w{4}-\w{4}-\w{12})$/, ":<uuid>"],
      [/(:\d{4}-\d{2}-\d{2})$/, ":<date>"]
    ]

    def extract_pattern(key)
      RULES.each do |rule, replacer|
        if m = rule.match(key)
          key = key.sub(m[1], replacer)
          break
        end
      end
      key
    end
  end
end