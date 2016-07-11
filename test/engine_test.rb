# -*- encoding : utf-8 -*-

require 'test_helper'

class EngineTest < Minitest::Test
  def setup
    @options = {host: '127.0.0.1', port: 6379, db: 9}
    @redis = RedisScanner::Redis.new @options
    @redis.client.flushdb
  end

  def teardown
    @redis.client.flushdb
  end

  def test_run_without_match
    setup_redis_data(@redis.client)
    engine = RedisScanner::Engine.new(@redis, @options)

    result = engine.run
    assert_equal ["u:<id>:name 2", "test 1", "u:<date> 1",
      "u:<uuid>:age 1", "user 1"], result.map(&:to_s)
  end

  def test_run_with_match
    setup_redis_data(@redis.client)
    engine = RedisScanner::Engine.new(@redis, @options.merge({match: "u:*"}))

    result = engine.run
    assert_equal ["u:<id>:name 2", "u:<date> 1",
      "u:<uuid>:age 1"], result.map(&:to_s)
  end
end