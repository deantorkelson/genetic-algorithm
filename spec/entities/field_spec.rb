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
end
