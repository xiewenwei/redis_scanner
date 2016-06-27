require 'test_helper'

class EnginePatternTest < Minitest::Test
  def test_sort
    patterns = []
    [["b", 1], ["a", 1,], ["c", 3], ["k", 1], ["f", 2]].each do |k, v|
      p = RedisScanner::Pattern.new(k)
      p.total = v
      patterns << p
    end
    result = patterns.sort.map(&:to_s)
    assert_equal ["c 3", "f 2", "a 1", "b 1", "k 1"], result
  end
end