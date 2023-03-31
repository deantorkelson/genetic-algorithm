# frozen_string_literal: true

# typed: true
require 'colorize'

module Entities
  class Agent < Tile
    COLORS = %i[red green light_green yellow blue magenta light_magenta cyan light_cyan].freeze

    attr_accessor :alive, :name, :color, :genes

    def initialize(name:, genes: { sight: 2, move: 1 })
      @name = name
      @color = COLORS[rand(COLORS.size)]
      @genes = genes
      @alive = true
      super()
      # eventually this should have sight (view distance)
      # also speed (turn priority)
    end

    def sight
      genes[:sight]
    end

    def eliminate
      @alive = false
    end

    def action(grid, row, col)
      return unless alive

      # agent will look around and decide on an action
      # MVP: moves in a random direction
      # MVP: update grid state after moving
      # eventual: would be cool to move in a less random way so it doesn't just go in circles until it dies
      neighbors = Field.get_neighbors(grid, row, col, sight)
      chosen_tile = nil
      neighbors.each do |tile|
        next if tile.is_a? EmptySquare

        chosen_tile = tile
        case tile
        when Food
          eat
        when Agent
          fight(tile)
        else
          pp "Got unexpected tile: #{tile}"
        end
      end
      chosen_tile
    end

    def eat
      # TODO
    end

    def fight(other)
      # TODO
    end

    def to_s
      super(@name.colorize(color: @color, mode: :bold))
    end

    def ==(other)
      return false unless other.is_a? Agent

      @name == other.name
    end
  end
end
