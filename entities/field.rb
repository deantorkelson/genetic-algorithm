require 'colorize'

require_relative './agent'
require_relative './empty'
require_relative './food'

module Entities
  class Field
    attr_accessor :grid, :agents
    NAME_START_INDEX = 64

    def initialize(rows:, cols:, num_agents:, num_food:)
      @grid = Array.new(rows) { Array.new(cols) { EmptySquare.new } }
      @agents = []
      initialize_agents(num_agents)
      initialize_food(num_food)
    end

    def initialize_agents(num_agents)
      while num_agents > 0 do
        row, col = rand(grid.count), rand(grid[0].count)
        if grid[row][col].is_a? EmptySquare
          agent = Agent.new(name: (num_agents + NAME_START_INDEX).chr)
          agents << agent
          grid[row][col] = agent
          num_agents -= 1
        end
      end
    end

    def initialize_food(num_food)
      while num_food > 0 do
        row, col = rand(grid.count), rand(grid[0].count)
        if grid[row][col].is_a? EmptySquare
          food = Food.new
          grid[row][col] = food
          num_food -= 1
        end
      end
    end

    def turn
      agents.each do |agent|
        agent.action(grid)
        # should eventually look at list sorted by speed
      end
    end

    def to_s
      vertical_edge = "+#{'- ' * (grid.size)}+"
      str = vertical_edge + "\n"
      grid.each do |row|
        row_s = "|"
        row.each do |element|
          row_s << element.to_s << " "
        end
        row_s << "|\n"
        str << row_s
      end
      str << vertical_edge << "\n"
    end
  end
end