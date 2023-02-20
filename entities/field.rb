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
        # how do we iterate down a list of agents sorted by speed but also get their coordinates?
        # we know the fastest, so iterate until we find the fastest one and let it move
        # go to next agent, repeat
        @grid.each_with_index do |current_row, row_idx|
          current_row.each_with_index do |_, col_idx|
            next unless grid[row_idx][col_idx] == agent
            agent.action(grid, row_idx, col_idx)
            # steps that will happen
            #   each agent will look around and decide on an action (needs grid and adjacent items (needs self))
            #   each agent will perform that action, which needs to update grid state
            mark_seen(col_idx, row_idx, agent.sight)
          end
        end
      end
      # need to clear "seen" value for all tiles
    end

    def mark_seen(col, row, radius)
      # this snippet suggested by ChatGPT (...with significant modifications to make it work)
      (col - radius .. col + radius).each do |x|
        (row - radius .. row + radius).each do |y|
          # calculate distance between current cell and center point
          distance = Math.sqrt((col - x)**2 + (row - y)**2)

          # only include cell if distance is less than or equal to radius and is in grid
          if distance <= radius && x >= 0 && x < grid.length && y >= 0 && y < grid[x].length
            grid[y][x].seen
          end
        end
      end

      # original
      # def iterate_neighbors_within_radius(array, x, y, n)
      #   neighbors = []
      #
      #   # iterate over cells within square area enclosing circle with radius n
      #   (x - n .. x + n).each do |i|
      #     (y - n .. y + n).each do |j|
      #       # calculate distance between current cell and center point
      #       distance = Math.sqrt((x - i)**2 + (y - j)**2)
      #
      #       # only include cell if distance is less than or equal to n
      #       if distance <= n && i >= 0 && i < array.length && j >= 0 && j < array[i].length
      #         neighbors << array[i][j]
      #       end
      #     end
      #   end
      #
      #   return neighbors
      # end
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