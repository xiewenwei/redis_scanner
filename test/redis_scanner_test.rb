require 'test_helper'

class RedisScannerTest < Minitest::Test
  def setup
    @options = {host: '127.0.0.1', port: 6379, db: 9}
    @redis = RedisScanner::Redis.new @options
    @engine = RedisScanner::Engine.new(@redis, @options)
    @redis.client.flushdb
  end

  def teardown
    @redis.client.flushdb
  end

  def test_scan_to_file
    setup_redis_data(@redis.client)

    file = "test/result.txt"
    RedisScanner.scan @options.merge(file: file)
    assert File.exists? file
    File.delete file
  end
end
