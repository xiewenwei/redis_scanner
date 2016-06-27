require "ruby-progressbar"

module RedisScanner
  class Engine
    def initialize(redis, options)
      @redis = RedisWrapper.new(redis, options)
      @options = options
    end

    def run
      result = scan
      result.values.sort
    end

    private

    def create_progress_bar
      total = @redis.total_keys
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
          if @options[:detail]
            type, size = @redis.get_type_and_size(key)
            stat[pattern].increment key, type, size
          else
            stat[pattern].increment key
          end
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