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
          rows << [pattern.name, pattern.total, "", ""]
          pattern.sorted_items.each do |item|
            rows << [" > #{item.type}", item.count, item.size, item.avg_size]
          end
        else
          rows << [pattern.name, pattern.total]
        end
        count += 1
        break if touch_limit?(count)
      end

      headings = ['Key', 'Count']
      if with_detail
        headings << "Size"
        headings << "AvgSize"
      end

      table = Terminal::Table.new headings: headings, rows: rows
      table.align_column(1, :right)
      if with_detail
        table.align_column(2, :right)
        table.align_column(3, :right)
      end

      table.to_s
    end
  end
end