# -*- encoding : utf-8 -*-

require 'test_helper'

class PatternTest < Minitest::Test
  def test_increment
    pt = RedisScanner::Pattern.new("test")
    pt.increment
    assert_equal 1, pt.total
    pt.increment
    assert_equal 2, pt.total
  end

  def test_increment_with_type_and_size
    pt = RedisScanner::Pattern.new("test")
    pt.increment "string", 10
    pt.increment "string", 6
    pt.increment "hash", 8
    assert_equal 3, pt.total
    items = pt.sorted_items
    assert_equal 2, items.size
    assert_equal "string", items.first.type
  end

  def test_sort
    result = setup_patterns.sort.map(&:to_s)
    assert_equal ["c 3", "f 2", "a 1", "b 1", "k 1"], result
  end
end
