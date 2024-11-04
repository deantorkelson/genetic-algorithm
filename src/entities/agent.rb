# frozen_string_literal: true
require 'colorize'
MUTATION_FACTOR = 0.3


module Entities
  class Agent < Tile
    COLORS = %i[red green light_green yellow blue magenta light_magenta cyan light_cyan].freeze

    attr_accessor :alive, :name, :color, :genes, :score

    def initialize(name:, seed_genes: nil)
      seed_genes ||= { sight: 2 }
      @alive = true
      @name = name
      @color = COLORS[rand(COLORS.size)]
      @score = 0
      initialize_genes(seed_genes)
      super()
      # eventually this should have sight (view distance)
      # also speed (turn priority)
    end

    def initialize_genes(seed_genes)
      @genes = mutate_seeds(seed_genes)
      # TODO - add energy, this will enable eat and fight
    end

    def mutate_seeds(seed)
      mutations = [1 + MUTATION_FACTOR, 1 - MUTATION_FACTOR]
      seed.transform_values { |value| (value * mutations.sample).round(4) }
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
      @score += 1
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
      @score += 5
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

    def <=>(other)
      score <=> other.score
    end
  end
end
