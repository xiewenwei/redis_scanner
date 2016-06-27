require 'test_helper'

class EngineResolvePatternTest < Minitest::Test
  def setup
    @engine = RedisScanner::Engine.new(nil, {})
  end

  def test_sort
    stat = {"b" => 1, "a" => 1, "c" => 3, "k" => 1, "f" => 2}
    result = @engine.send(:convert_to_sorted_array, stat)
    assert_equal [["c", 3], ["f", 2], ["a", 1], ["b", 1], ["k", 1]], result
  end
end