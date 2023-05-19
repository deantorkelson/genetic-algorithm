# frozen_string_literal: true

# typed: true

module Entities
  class EmptySquare < Tile
    def initialize(seen_count: 0)
      @seen_count = seen_count
    end

    def to_s
      # track how many agents "see"
      # this square and print background brightness based off that?
      super(' ')
    end
  end
end
