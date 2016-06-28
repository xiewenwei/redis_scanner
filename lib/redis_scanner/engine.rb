require "ruby-progressbar"

module RedisScanner
  class Engine
    def initialize(redis, options)
      @redis = redis
      @options = options
      @rule = Rule.new
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
          pattern = @rule.extract_pattern(key)
          if @options[:detail]
            type, size = @redis.get_type_and_size(key)
            stat[pattern].increment type, size
          else
            stat[pattern].increment
          end
          bar.increment unless bar.finished?
        end
        cursor = cursor.to_i
        break if cursor == 0
      end
      bar.finish unless bar.finished?

      stat
    end

  end
end