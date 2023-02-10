require 'colorize'

require_relative './agent'
require_relative './food'

module Entities
  class Field
    attr_accessor :grid, :agents
    NAME_START_INDEX = 64

    def initialize(rows:, cols:, num_agents:, num_food:)
      @grid = Array.new(rows) { Array.new(cols) }
      @agents = []
      initialize_agents(num_agents)
      initialize_food(num_food)
    end

    def initialize_agents(num_agents)
      while num_agents > 0 do
        row, col = rand(grid.count), rand(grid[0].count)
        if grid[row][col].nil?
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
        if grid[row][col].nil?
          food = Food.new
          grid[row][col] = food
          num_food -= 1
        end
      end
    end

    def turn
      grid.each do |row|
        row.each do |element|
          # come up with some OOP-y solution
          #
          # element.action(grid)
          # should eventually just iterate over agents in list of speed
        end
      end
    end

    def to_s
      vertical_edge = "+#{'- ' * (grid.size)}+"
      str = vertical_edge + "\n"
      grid.each do |row|
        row_s = "|"
        row.each do |element|
          if element.nil?
            row_s << " "
          else
            row_s << element.to_s
          end
          row_s << " "
        end
        row_s << "|\n"
        str << row_s
      end
      str << vertical_edge << "\n"
    end
  end
end