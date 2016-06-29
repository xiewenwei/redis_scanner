require "terminal-table"

module RedisScanner
  class Formatter
    def initialize(options)
      @options = options
    end

    def format(patterns)
      if @options[:format] == "simple"
        simple patterns
      else
        table patterns
      end
    end

    private

    def touch_limit?(count)
      @options[:limit] &&
        @options[:limit].to_i > 0 &&
        count >= @options[:limit].to_i
    end

    def simple(patterns)
      ret = ""
      count = 0
      patterns.each do |pattern|
        ret << pattern.to_s
        ret << "\n"
        count += 1
        break if touch_limit?(count)
      end
      ret
    end

    def table(patterns)
      with_detail = @options[:detail]
      rows = []
      count = 0

      patterns.each do |pattern|
        if with_detail
          pattern.sorted_items.each do |item|
            rows << [pattern.name, item.type, item.count, item.size, item.avg_size]
          end
        else
          rows << [pattern.name, pattern.total]
        end
        count += 1
        break if touch_limit?(count)
      end


      if with_detail
        headings = %w(Key Type Count Size AvgSize)
      else
        headings = %w(Key Count)
      end

      table = Terminal::Table.new headings: headings, rows: rows

      if with_detail
        4.times {|i| table.align_column(i+2, :right) }
      else
        table.align_column(1, :right)
      end

      table.to_s
    end
  end
end