require "redis_scanner/version"
require "redis_scanner/rule"
require "redis_scanner/pattern"
require "redis_scanner/redis"
require "redis_scanner/engine"
require "redis_scanner/formatter"
require "redis"

module RedisScanner
  def self.scan(options)
    redis = Redis.new options
    engine = Engine.new redis, options
    patterns = engine.run
    output_result(patterns, options)
  end

  def self.output_result(patterns, options)
    formatter = Formatter.new(options)
    result = formatter.format patterns
    if options[:file]
      File.open(options[:file], "w") do |file|
        file.puts result
      end
    else
      puts result
    end
  end

end
