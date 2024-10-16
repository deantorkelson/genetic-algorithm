# frozen_string_literal: true

# typed: true
require 'colorize'

module Entities
  class Field

    attr_accessor :grid, :agents

    NAME_START_INDEX = 65

    def initialize(rows:, cols:, num_agents:, num_food:, seed_genes: nil)
      @grid = Array.new(rows) { Array.new(cols) { EmptySquare.new } }
      @agents = []
      # TODO rectangular grids don't work
      initialize_agents(num_agents, seed_genes)
      initialize_food(num_food)
      initialize_seen
    end

    def initialize_agents(num_agents, seed_genes)
      index = 0
      while num_agents.positive?
        row = rand(grid.count)
        col = rand(grid[0].count)
        if grid[row][col].is_a? EmptySquare
          agent = Agent.new(name: (index + NAME_START_INDEX).chr, seed_genes: seed_genes)
          agents << agent
          grid[row][col] = agent
          index += 1
          num_agents -= 1
        end
      end
    end

    def initialize_food(num_food)
      while num_food.positive?
        row = rand(grid.count)
        col = rand(grid[0].count)
        if grid[row][col].is_a? EmptySquare

          food = Food.new
          grid[row][col] = food
          num_food -= 1
        end
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
        next unless agent.alive

        # iterating over agents sorted by fastest, so we need to find where it is on the grid
        row_idx, col_idx = find(agent)

        agent_new_tile = agent.action(grid, row_idx, col_idx)
        move_agent(agent, {row: row_idx, col: col_idx}, agent_new_tile) if agent_new_tile != agent

        if $debug
          puts "---After agent #{agent.name}'s turn---"
          puts to_s
          sleep($debug_delay)
        end
      end
      if $debug
        puts '---End of turn---'
        puts "living agents: #{agents.select(&:alive).map(&:name).join(', ')}"
        puts "killed agents: #{agents.reject(&:alive).map(&:name).join(', ')}"
      end
      @agents = agents.select(&:alive)
    end

    def move_agent(agent, from, destination_tile)
      # empty out destination
      new_row_idx, new_col_idx = find(destination_tile)
      destination_tile.eliminate
      if destination_tile.is_a? Agent
        unmark_old_seen(new_row_idx, new_col_idx, destination_tile.sight)
      end
      clear(from[:row], from[:col])

      # move agent to destination
      agent.seen_count = destination_tile.seen_count
      grid[new_row_idx][new_col_idx] = agent

      # update seen values
      unmark_old_seen(from[:row], from[:col], agent.sight)
      mark_seen(new_row_idx, new_col_idx, agent.sight)
    end

    # clears out a tile while keeping its seen value
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
      raise StandardError, "Tile not found: #{tile}"
    end

    def mark_seen(row, col, radius)
      Field.get_neighbors(grid, row, col, radius).map(&:seen)
    end

    def unmark_old_seen(row, col, radius)
      Field.get_neighbors(grid, row, col, radius).map(&:unsee)
    end

    # gets neighbors within `radius` units, using Euclidean distance
    def self.get_neighbors(grid, row, col, radius)
      neighbors = []
      (col - radius..col + radius).each do |x|
        (row - radius..row + radius).each do |y|
          # calculate distance between current cell and center point
          distance = Math.sqrt((col - x)**2 + (row - y)**2)

          # only include cell if distance is less than or equal to radius and is in grid
          if (distance <= radius && y >= 0) && (y < grid.length) && (x >= 0) && (x < grid[y].length)
            neighbors << grid[y][x]
          end
        end
      end
      neighbors
    end

    def to_s
      spaced_dashes = Array.new(grid[0].size) { '-' }.join(' ')
      vertical_edge = "+#{spaced_dashes}+\n"
      printed_grid = grid.map { |row| "|#{row.map(&:to_s).join(' ')}|\n" }.join
      "#{vertical_edge}#{printed_grid}#{vertical_edge}"
    end
  end
end
