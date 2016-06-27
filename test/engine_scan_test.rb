require 'test_helper'

class EngineScanTest < Minitest::Test
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
    engine = RedisScanner::Engine.new(@redis, @redis_options)
    assert_equal 6, engine.send(:total_keys)
  end

  def test_run_without_match
    setup_redis_data(@redis)
    engine = RedisScanner::Engine.new(@redis, @redis_options)
    result = engine.run
    assert_equal ["u:<id>:name 2", "test 1", "u:<date> 1",
      "u:<uuid>:age 1", "user 1"], result.map(&:to_s)
  end

  def test_run_with_match
    setup_redis_data(@redis)
    engine = RedisScanner::Engine.new(@redis, @redis_options.merge({match: "u:*"}))
    result = engine.run
    assert_equal ["u:<id>:name 2", "u:<date> 1",
      "u:<uuid>:age 1"], result.map(&:to_s)
  end
end