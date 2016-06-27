module RedisScanner
  class PatternItem
    attr_reader :type, :count, :size

    def initialize(type)
      @type = type
      @count = 0
      @size = 0
    end

    def increment(size)
      @count += 1
      @size += size
    end

    def <=>(other)
      if @count == other.count
        @type <=> other.type
      else
        other.count <=> @count
      end
    end

    def avg_size
      @count > 0 ? (@size * 1.0 / @count).round(2) : nil
    end

    def to_s
      "#{type} #{count} #{size} #{avg_size}"
    end
  end

  class Pattern
    attr_reader :name
    attr_accessor :total
    attr_reader :items

    def initialize(name)
      @name = name
      @total = 0
      @items = Hash.new {|hash, key| hash[key] = PatternItem.new(key) }
    end

    def increment(key, type = nil, size = nil)
      @total += 1
      if type && size
        @items[type].increment(size)
      end
    end

    def <=>(other)
      if @total == other.total
        @name <=> other.name
      else
        other.total <=> @total
      end
    end

    def to_a
      [name, total]
    end

    def to_s
      ret = "#{name} #{total}"
      if @items.size > 0
        sorted_items.each do |item|
          ret << "\n  #{item}"
        end
      end
      ret
    end

    def sorted_items
      @items.values.sort
    end
  end
end
