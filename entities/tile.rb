require_relative './tile'

module Entities
  class Tile
    attr_accessor :seen_count

    def initialize
      @seen_count = 0
    end

    def seen
      @seen_count += 1
    end

    def to_s(str = '')
      if @seen_count > 0
        return str.colorize(:background => :red)
      end
      str
    end
  end
end