$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'redis_scanner'

require 'minitest/autorun'

class Minitest::Test
  def setup_redis_data(redis)
    redis.set "u:1:name", "vincent"
    redis.set "u:12:name", "susu"
    redis.set "u:2016-08-12", "ok"
    redis.set "u:ddfaf6ba-d710-11e1-aab4-782bcb6589d5:age", "24"
    redis.set "test", "haha"
    redis.set "user", "good"
  end
end
