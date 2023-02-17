require_relative './tile'

module Entities
  class Food < Tile
    def to_s
      "."
    end
  end
end