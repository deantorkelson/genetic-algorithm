# frozen_string_literal: true

require_relative '../spec_helper'

describe Entities::Field do
  let(:field) { Entities::Field.new(rows: 3, cols: 3, num_agents: 0, num_food: 0) }

  describe '.initialize' do
    context 'with square grid' do 
      let(:field) { Entities::Field.new(rows: 3, cols: 3, num_agents: 1, num_food: 1) }

      it 'creates a grid of empty squares with specified amounts of food and agents' do
        expect(field.grid.flatten.select { |tile| tile.is_a?(Entities::EmptySquare) }.count).to eq(7)
        expect(field.grid.flatten.select { |tile| tile.is_a?(Entities::Agent) }.count).to eq(1)
        expect(field.grid.flatten.select { |tile| tile.is_a?(Entities::Food ) }.count).to eq(1)
      end
    end

    context 'with rectangular grid' do 
      let(:field) { Entities::Field.new(rows: 3, cols: 10, num_agents: 1, num_food: 1) }

      it 'creates a grid of empty squares with specified amounts of food and agents' do
        expect(field.grid.flatten.select { |tile| tile.is_a?(Entities::EmptySquare) }.count).to eq(28)
        expect(field.grid.flatten.select { |tile| tile.is_a?(Entities::Agent) }.count).to eq(1)
        expect(field.grid.flatten.select { |tile| tile.is_a?(Entities::Food ) }.count).to eq(1)
      end
    end
  end

  describe '.mark_seen' do
    it 'marks all neighbors as seen' do
      expect(field.grid.flatten.map(&:seen_count)).to all(eq(0))

      field.mark_seen(1, 1, 1)
      expected_seen = [[0, 1], [1, 0], [1, 1], [1, 2], [2, 1]]
      expected_not_seen = [[0, 0], [0, 2], [2, 0], [2, 2]]
      expected_seen.each do |coord|
        expect(field.grid[coord.first][coord.last].seen_count).to eq(1)
      end
      expected_not_seen.each do |coord|
        expect(field.grid[coord.first][coord.last].seen_count).to eq(0)
      end
    end

    it 'respects field boundaries' do
      expect(field.grid.flatten.map(&:seen_count)).to all(eq(0))

      field.mark_seen(0, 0, 1)
      expected_seen = [[0, 0], [0, 1], [1, 0]]
      expected_not_seen = [[1, 1], [0, 2], [1, 2], [2, 0], [2, 1], [2, 2]]
      expected_seen.each do |coord|
        expect(field.grid[coord.first][coord.last].seen_count).to eq(1)
      end
      expected_not_seen.each do |coord|
        expect(field.grid[coord.first][coord.last].seen_count).to eq(0)
      end
    end
  end

  describe '.unmark_old_seen' do
    before do
      field.grid.flatten.each do |tile|
        tile.seen_count = 1
      end
    end

    it 'marks all neighbors as unseen' do
      expect(field.grid.flatten.map(&:seen_count)).to all(eq(1))

      field.unmark_old_seen(1, 1, 1)
      expected_not_seen = [[0, 1], [1, 0], [1, 1], [1, 2], [2, 1]]
      expected_seen = [[0, 0], [0, 2], [2, 0], [2, 2]]
      expected_not_seen.each do |coord|
        expect(field.grid[coord.first][coord.last].seen_count).to eq(0)
      end
      expected_seen.each do |coord|
        expect(field.grid[coord.first][coord.last].seen_count).to eq(1)
      end
    end
  end

  describe '.neighbors' do
    it 'returns all neighbors' do
      neighbors = Field.get_neighbors(field, 1, 1, 2)
      expect(neighbors.count).to eq(8)
      expect(neighbors).to include(field.grid[0][0])
      expect(neighbors).to include(field.grid[0][1])
      expect(neighbors).to include(field.grid[0][2])
      expect(neighbors).to include(field.grid[1][0])
      expect(neighbors).to include(field.grid[1][2])
      expect(neighbors).to include(field.grid[2][0])
      expect(neighbors).to include(field.grid[2][1])
      expect(neighbors).to include(field.grid[2][2])
    end

    it 'respects field boundaries' do
      neighbors = field.neighbors(0, 0)
      expect(neighbors.count).to eq(3)
      expect(neighbors).to include(field.grid[0][1])
      expect(neighbors).to include(field.grid[1][0])
      expect(neighbors).to include(field.grid[1][1])
    end
  end

  describe '.turn' do
    before do
      srand(10)
    end

    it 'moving an agent handles updating seen values' do
      field = Entities::Field.new(rows: 3, cols: 3, num_agents: 1, seed_genes_options: [{ sight: 1 }], num_food: 0)
      agent = field.agents.first
      target_tile = field.grid[0][0]
      allow(agent).to receive(:action).with(field.grid, 1, 1).and_return(target_tile)
      
      expect(field.grid[0][1].seen_count).to eq(1)
      expect(field.grid[1][0].seen_count).to eq(1)
      expect(field.grid[2][1].seen_count).to eq(1)
      expect(field.grid[1][2].seen_count).to eq(1)
      
      expect(target_tile).to receive(:eliminate)
      field.turn
      expect(field.grid[0][0]).to eq(agent)
      expect(field.grid[0][0].seen_count).to eq(1)
      expect(field.grid[0][1].seen_count).to eq(1)
      expect(field.grid[1][0].seen_count).to eq(1)

      expect(field.grid[1][1].seen_count).to eq(0)
      expect(field.grid[2][1].seen_count).to eq(0)
      expect(field.grid[1][2].seen_count).to eq(0)
    end

    it 'handles field updates when one agent eliminates another' do
      field = Entities::Field.new(rows: 2, cols: 2, num_agents: 2, seed_genes_options: [{ sight: 2 }], num_food: 0)
      living_agent = field.agents[0]
      dying_agent = field.agents[1]

      field.turn
      
      expect(field.grid[1][0]).to eq(living_agent)
      expect(field.grid[1][1]).to be_a(Entities::EmptySquare)
      expect(field.agents).to eq([living_agent])
      expect(field.dead_agents).to eq([dying_agent])
    end
  end

  describe '.to_s' do
    let(:field) { Entities::Field.new(rows: 1, cols: 2, num_agents: 0, num_food: 0) }
    it 'returns a string representation of the field' do
      expect(field.grid[0][0]).to be_a(Entities::EmptySquare)
      expect(field.grid[0][1]).to be_a(Entities::EmptySquare)
      expect(field.to_s.uncolorize).to eq("+- -+\n|   |\n+- -+\n")
    end
  end
end
