# frozen_string_literal: true

module Entities
  class Tile
    attr_accessor :seen_count

    BACKGROUNDS = %i[default light_black white light_white].freeze

    def initialize
      @seen_count = 0
    end

    def eliminate; end

    def seen
      @seen_count += 1
    end

    def unsee
      puts 'Tile marked with negative seen' if @seen_count.zero?
      @seen_count -= 1
    end

    def to_s(str = '')
      str.colorize(background: BACKGROUNDS[[@seen_count, 4].min])
    end
  end
end
