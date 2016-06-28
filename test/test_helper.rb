$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'redis_scanner'

require 'minitest/autorun'

class Minitest::Test
  def setup_redis_data(client)
    client.set "u:1:name", "vincent"
    client.set "u:12:name", "susu"
    client.set "u:2016-08-12", "ok"
    client.set "u:ddfaf6ba-d710-11e1-aab4-782bcb6589d5:age", "24"
    client.set "test", "haha"
    client.set "user", "good"
  end

  def setup_patterns
    [["b", 1], ["a", 1,], ["c", 3], ["k", 1], ["f", 2]].map do |k, v|
      pt = RedisScanner::Pattern.new(k)
      pt.total = v
      pt
    end
  end
end
