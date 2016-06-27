require 'test_helper'

class RedisWrapperTest < Minitest::Test
  def setup
    @redis_options = {host: '127.0.0.1', port: 6379, db: 9}
    @redis = Redis.new @redis_options
    @redis.flushdb
  end

  def teardown
    @redis.flushdb
  end

  def test_total_keys
    setup_redis_data(@redis)
    wrapper = RedisScanner::RedisWrapper.new(@redis, @redis_options)
    assert_equal 6, wrapper.total_keys
  end
end