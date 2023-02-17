require_relative './tile'

module Entities
  class Tile
    attr_accessor :seen_count

    def initialize
      @seen_count = 0
    end

    def see
      @seen_count += 1
    end

    def to_s
      # figure out how to convert seen_count to a bg on the printout
      # .colorize(:color => :light_blue, :background => :red)
    end
  end
end