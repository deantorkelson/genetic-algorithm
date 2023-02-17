require 'colorize'
require_relative './tile'

module Entities
  class Agent < Tile
    COLORS = [:red, :green, :light_green, :yellow, :blue, :magenta, :light_magenta, :cyan, :light_cyan]

    attr_accessor :name, :color, :genes

    def initialize(name:, genes: { sight: 1 })
      @name = name
      @color = COLORS[rand(COLORS.size)]
      @genes = genes
      # eventually this should have sight (view distance)
      # also speed (turn priority)
    end

    def to_s
      # use modes (:bold, :italic, :underline, :blink, :swap) to display energy?
      @name.colorize(@color)
    end
  end
end