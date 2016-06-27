require "redis_scanner/version"
require "redis_scanner/pattern"
require "redis_scanner/redis_wrapper"
require "redis_scanner/engine"
require "redis"

module RedisScanner
  def self.scan(options)
    redis = Redis.new extract_redis_options(options)
    engine = Engine.new redis, options
    result = engine.run
    output_result(result, options)
  end

  def self.output_result(result, options)
    if options[:file]
      File.open(options[:file], "w") do |file|
        result.each { |pattern| file.puts pattern }
      end
    else
      puts "=========result is========="
      result.each { |pattern| puts pattern }
      puts "==========================="
    end
  end

  def self.extract_redis_options(options)
    result = {}
    [:host, :port, :socket, :password, :db].each do |key|
      result[key] = options[key]
    end
    result
  end
end
