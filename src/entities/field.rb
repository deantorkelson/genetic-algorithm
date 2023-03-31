# typed: true
require 'colorize'

module Entities
  class Field
    extend T::Sig

    attr_accessor :grid, :agents
    NAME_START_INDEX = 64

    sig do
      params(
        rows: Integer,
        cols: Integer,
        num_agents: Integer,
        num_food: Integer).void
    end
    def initialize(rows:, cols:, num_agents:, num_food:)
      @grid = Array.new(rows) { Array.new(cols) { EmptySquare.new } }
      @agents = []
      initialize_agents(num_agents)
      initialize_food(num_food)
    end

    sig { params(num_agents: Integer).void }
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

    sig { params(num_food: Integer).void }
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

    sig { void }
    def turn
      agents.each do |agent|
        # iterating over agents sorted by fastest, so we need to find where it is on the grid
        grid.each_with_index do |current_row, row_idx|
          current_row.each_with_index do |_, col_idx|
            next unless grid[row_idx][col_idx] == agent
            agent_new_tile = agent.action(grid, row_idx, col_idx)
            eliminate(agent_new_tile)
            new_row_idx, new_col_idx = find(agent_new_tile)
            grid[row_idx][col_idx] = EmptySquare.new
            grid[new_row_idx][new_col_idx] = agent
            mark_seen(new_row_idx, new_col_idx, agent.sight)
            unmark_old_seen(row_idx, col_idx, agent.sight)

            puts "---After agent #{agent.name}'s turn---"
            self.to_s
            sleep(3)
          end
        end
      end
      # need to clear "seen" value for all tiles
    end

    def eliminate(tile)
      row_idx, col_idx = find(tile)
      tile.eliminate
      grid[row_idx][col_idx] = EmptySquare.new
    end

    def find(tile)
      grid.each_with_index do |row, row_idx|
        row.each_with_index do |_, col_idx|
          next unless tile == grid[row_idx][col_idx]
          return row_idx, col_idx
        end
      end
      raise StandardError("Tile not found: #{tile.to_s}")
    end

    sig { params(row: Integer, col: Integer, radius: Integer).returns(T::Array[Tile]) }
    def mark_seen(row, col, radius)
      Field.get_neighbors(grid, row, col, radius).map(&:seen)
    end

    sig { params(row: Integer, col: Integer, radius: Integer).returns(T::Array[Tile]) }
    def unmark_old_seen(row, col, radius)
      Field.get_neighbors(grid, row, col, radius).map(&:unsee)
    end

    def self.get_neighbors(grid, row, col, radius)
      # this snippet suggested by ChatGPT (...with significant modifications to make it work)
      neighbors = []
      (col - radius .. col + radius).each do |x|
        (row - radius .. row + radius).each do |y|
          # calculate distance between current cell and center point
          distance = Math.sqrt((col - x)**2 + (row - y)**2)

          # only include cell if distance is less than or equal to radius and is in grid
          if distance <= radius && x >= 0 && x < grid.length && y >= 0 && y < grid[x].length
            neighbors << grid[y][x]
          end
        end
      end
      neighbors
    end

    sig { returns(String) }
    def to_s
      vertical_edge = "+#{'- ' * (grid.size)}+"
      str = vertical_edge + "\n"
      grid.each do |row|
        row_s = "|"
        row.each { |element| row_s << element.to_s << " " }
        row_s << "|\n"
        str << row_s
      end
      str << vertical_edge << "\n"
    end
  end
end