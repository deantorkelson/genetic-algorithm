# frozen_string_literal: true
require 'colorize'

module Entities
  class Agent < Tile
    COLORS = %i[red green light_green yellow blue magenta light_magenta cyan light_cyan].freeze

    attr_accessor :alive, :name, :color, :genes

    def initialize(name:, seed_genes: { sight: 2 })
      @alive = true
      @name = name
      @color = COLORS[rand(COLORS.size)]
      initialize_genes(seed_genes)
      super()
      # eventually this should have sight (view distance)
      # also speed (turn priority)
    end

    def initialize_genes(seed_genes)
      @genes = seed_genes
      # TODO - add energy, this will enable eat and fight
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
      # MVP: update grid state after moving (handled by field)
      neighbors = Field.get_neighbors(grid, row, col, sight)
      chosen_tile = nil
      neighbors.each do |tile|
        next if tile.is_a?(EmptySquare) || tile == self

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
      if chosen_tile.nil?
        # eventual: would be cool to move in a less random way so it doesn't just go in circles until it dies
        chosen_tile = neighbors.sample
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
