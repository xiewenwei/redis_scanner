require 'test_helper'

class RedisScannerTest < Minitest::Test
  def setup
    @redis_options = {host: '127.0.0.1', port: 6379, db: 9}
    @redis = Redis.new @redis_options
    @redis.flushdb
  end

  def teardown
    @redis.flushdb
  end

  def test_scan_to_file
    setup_redis_data(@redis)

    file = "test/result.txt"
    RedisScanner.scan @redis_options.merge(file: file)
    assert File.exists? file
    File.delete file
  end
end
