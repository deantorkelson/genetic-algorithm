# typed: true

module Entities
  class Food < Tile
    def to_s
      super('·')
    end
  end
end