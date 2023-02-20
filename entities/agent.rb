require 'colorize'
require_relative './tile'

module Entities
  class Agent < Tile
    COLORS = [:red, :green, :light_green, :yellow, :blue, :magenta, :light_magenta, :cyan, :light_cyan]

    attr_accessor :name, :color, :genes

    def initialize(name:, genes: { sight: 1, move: 1 })
      @name = name
      @color = COLORS[rand(COLORS.size)]
      @genes = genes
      super()
      # eventually this should have sight (view distance)
      # also speed (turn priority)
    end

    def sight
      @genes[:sight]
    end

    def action(grid, row, col)
      # agent will look around and decide on an action
      # MVP: moves in a random direction
      # MVP: update grid state after moving
    end

    def to_s
      # use modes (:bold, :italic, :underline, :blink, :swap) to display energy?
      super(@name.colorize(@color))
    end

    def ==(other)
      @name == other.name
    end
  end
end