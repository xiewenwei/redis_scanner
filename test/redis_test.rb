require 'test_helper'

class RedisTest < Minitest::Test
  def setup
    options = {host: '127.0.0.1', port: 6379, db: 9}
    @redis = RedisScanner::Redis.new(options)
    @redis.client.flushdb
  end

  def teardown
    @redis.client.flushdb
  end

  def test_total_keys
    setup_redis_data(@redis.client)
    assert_equal 6, @redis.total_keys
  end
end