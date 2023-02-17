require_relative './tile'

module Entities
  class EmptySquare < Tile
    def action

    end

    def to_s
      # track how many agents "see"
      # this square and print background brightness based off that?
      ' '
    end
  end
end