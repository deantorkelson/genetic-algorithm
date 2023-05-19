# frozen_string_literal: true

# typed: true
require 'colorize'

module Entities
  class Field

    attr_accessor :grid, :agents

    NAME_START_INDEX = 64

    def initialize(rows:, cols:, num_agents:, num_food:)
      @grid = Array.new(rows) { Array.new(cols) { EmptySquare.new } }
      @agents = []
      initialize_agents(num_agents)
      initialize_food(num_food)
      initialize_seen
    end

    def initialize_agents(num_agents)
      while num_agents.positive?
        row = rand(grid.count)
        col = rand(grid[0].count)
        next unless grid[row][col].is_a? EmptySquare

        agent = Agent.new(name: (num_agents + NAME_START_INDEX).chr)
        agents << agent
        grid[row][col] = agent
        num_agents -= 1
      end
    end

    def initialize_food(num_food)
      while num_food.positive?
        row = rand(grid.count)
        col = rand(grid[0].count)
        next unless grid[row][col].is_a? EmptySquare

        food = Food.new
        grid[row][col] = food
        num_food -= 1
      end
    end

    def initialize_seen
      agents.each do |agent|
        row, col = find(agent)
        mark_seen(row, col, agent.sight)
      end
    end

    def turn
      agents.each do |agent|
        # iterating over agents sorted by fastest, so we need to find where it is on the grid
        row_idx, col_idx = find(agent)

        agent_new_tile = agent.action(grid, row_idx, col_idx)

        # move Agent to new tile, eliminating whatever's there
        new_row_idx, new_col_idx = find(agent_new_tile)
        agent_new_tile.eliminate
        clear(row_idx, col_idx)
        grid[new_row_idx][new_col_idx] = agent

        # mark new tiles as seen, unmark old tiles
        mark_seen(new_row_idx, new_col_idx, agent.sight)
        unmark_old_seen(row_idx, col_idx, agent.sight)

        puts "---After agent #{agent.name}'s turn---"
        puts to_s
        sleep(1)
      end
    end

    # clears out a tile while keeping its "seen" value
    def clear(row, col)
      grid[row][col] = EmptySquare.new(seen_count: grid[row][col].seen_count)
    end

    def find(tile)
      grid.each_with_index do |row, row_idx|
        row.each_with_index do |_, col_idx|
          next unless tile == grid[row_idx][col_idx]

          return row_idx, col_idx
        end
      end
      raise StandardError("Tile not found: #{tile}")
    end

    def mark_seen(row, col, radius)
      Field.get_neighbors(grid, row, col, radius).map(&:seen)
    end

    def unmark_old_seen(row, col, radius)
      Field.get_neighbors(grid, row, col, radius).map(&:unsee)
    end

    # gets neighbors in a plus/diamond shape, not square
    def self.get_neighbors(grid, row, col, radius)
      # this snippet suggested by ChatGPT (...with significant modifications to make it work)
      neighbors = []
      (col - radius..col + radius).each do |x|
        (row - radius..row + radius).each do |y|
          # calculate distance between current cell and center point
          distance = Math.sqrt((col - x)**2 + (row - y)**2)

          # only include cell if distance is less than or equal to radius and is in grid
          neighbors << grid[y][x] if distance <= radius && x >= 0 && x < grid.length && y >= 0 && y < grid[x].length
        end
      end
      neighbors
    end

    def to_s
      spaced_dashes = Array.new(grid.size) { '-' }.join(' ')
      vertical_edge = "+#{spaced_dashes}+\n"
      printed_grid = grid.map { |row| "|#{row.map(&:to_s).join(' ')}|\n" }.join
      "#{vertical_edge}#{printed_grid}#{vertical_edge}"
    end
  end
end
