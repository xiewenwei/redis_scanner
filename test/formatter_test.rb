# -*- encoding : utf-8 -*-

require 'test_helper'

class FormatterTest < Minitest::Test
  def test_format_simple
    formatter = RedisScanner::Formatter.new format: "simple"
    result = formatter.format(setup_patterns)
    assert_match /b\s1/, result
  end

  def test_format_table
    formatter = RedisScanner::Formatter.new format: "table"
    result = formatter.format(setup_patterns)
    assert_match /\|\sKey\s\|\sCount\s\|/, result
    assert_match /\|\s*b\s*\|\s*1\s*\|/, result
  end
end
