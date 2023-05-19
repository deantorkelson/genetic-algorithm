# frozen_string_literal: true

require_relative '../spec_helper'

describe Entities::Field do
  let(:field) { Entities::Field.new(rows: 3, cols: 3, num_agents: 0, num_food: 0) }

  describe '.eliminate' do
    let(:field) { Entities::Field.new(rows: 3, cols: 3, num_agents: 1, num_food: 0) }
    let(:agent) { field.agents.first }

    it 'eliminates the tile and clears it' do
      expect(agent).to receive(:eliminate)
      field.eliminate(agent)
      expect(field.grid.flatten).to all(be_a(Entities::EmptySquare))
    end
  end

  describe '.mark_seen' do
    let(:field) { Entities::Field.new(rows: 3, cols: 3, num_agents: 0, num_food: 0) }

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
    let(:field) { Entities::Field.new(rows: 3, cols: 3, num_agents: 0, num_food: 0) }

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
end
