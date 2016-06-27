module RedisScanner
  class Pattern
    attr_reader :name
    attr_accessor :count

    def initialize(name)
      @name = name
      @count = 0
    end

    def increment
      @count += 1
    end

    def <=>(other)
      if @count == other.count
        @name <=> other.name
      else
        other.count <=> @count
      end
    end

    def to_a
      [name, count]
    end

    def to_s
      "#{name} #{count}"
    end
  end
end
