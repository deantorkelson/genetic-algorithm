require_relative './tile'

module Entities
  class Tile
    attr_accessor :seen_count
    BACKGROUNDS = [:default, :light_black, :white, :light_white]

    def initialize
      @seen_count = 0
    end

    def seen
      @seen_count += 1
    end

    def to_s(str = '')
      str.colorize(:background => BACKGROUNDS[[@seen_count, 4].min])
    end
  end
end