# -*- encoding : utf-8 -*-

require 'test_helper'

class RuleTest < Minitest::Test
  def setup
    @rule = RedisScanner::Rule.new
  end

  def test_pattern_id
    [
      ["user:123:name", "user:<id>:name"],
      ["user:1", "user:<id>"],
      ["p:012:ok", "p:<id>:ok"]
    ].each do |key, pattern|
      assert_equal pattern, @rule.extract_pattern(key)
    end
  end

  def test_pattern_uuid
    [
      ["user:ddfaf606-d710-11e1-aab4-782bcb6589d5:name", "user:<uuid>:name"],
      ["user:ddfaf606-d710-11e1-aab4-782bcb6589d5", "user:<uuid>"],
      ["p:ddfaf606-d710-11e1-aab4-782bcb6589d5:ok", "p:<uuid>:ok"]
    ].each do |key, pattern|
      assert_equal pattern, @rule.extract_pattern(key)
    end
  end

  def test_pattern_date
    [
      ["user:2015-04-03:name", "user:<date>:name"],
      ["user:2016-04-03", "user:<date>"],
      ["p:2015-05-03:ok", "p:<date>:ok"]
    ].each do |key, pattern|
      assert_equal pattern, @rule.extract_pattern(key)
    end
  end

  def test_no_defined_pattern
    [
      ["user", "user"],
      ["user1", "user1"],
      ["12ok", "12ok"]
    ].each do |key, pattern|
      assert_equal pattern, @rule.extract_pattern(key)
    end
  end

  def test_invalid_byte_sequence
    key = "\xAB\xC1ok\xD6\xF7\xD3"
    assert_equal "??ok???", @rule.extract_pattern(key)
  end
end
