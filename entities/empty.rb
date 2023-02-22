# typed: true
require_relative './tile'

module Entities
  class EmptySquare < Tile
    def to_s
      # track how many agents "see"
      # this square and print background brightness based off that?
      super(' ')
    end
  end
end