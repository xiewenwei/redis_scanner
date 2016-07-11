# -*- encoding : utf-8 -*-

module RedisScanner
  class Rule
    PRESET_RULES = [
      [/(:\d+:)/, ":<id>:"],
      [/(:\w{8}-\w{4}-\w{4}-\w{4}-\w{12}:)/, ":<uuid>:"],
      [/(:\d{4}-\d{2}-\d{2}:)/, ":<date>:"],
      [/(:\d+)$/, ":<id>"],
      [/(:\w{8}-\w{4}-\w{4}-\w{4}-\w{12})$/, ":<uuid>"],
      [/(:\d{4}-\d{2}-\d{2})$/, ":<date>"]
    ]

    def initialize
      @rules = PRESET_RULES
    end

    def extract_pattern(key)
      key = force_valid_key(key)
      @rules.each do |rule, replacer|
        if m = rule.match(key)
          key = key.sub(m[1], replacer)
          break
        end
      end
      key
    end

    private

    def force_valid_key(key)
      if key.valid_encoding?
        key
      else
        key.size.times do |index|
          unless key[index].valid_encoding?
            key[index] = "?"
          end
        end
        key
      end
    end
  end
end