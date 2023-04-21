# frozen_string_literal: true

require_relative '../spec_helper'

describe Entities::Agent do
  describe '.action' do
    let(:agent) { Entities::Agent.new(name: 'A', genes: genes) }
    let(:genes) { { sight: 1, move: 1 } }
    let(:grid) { Array.new(3) { Array.new(3) { Entities::EmptySquare.new } } }

    context 'when agent is dead' do
      it 'does nothing' do
        agent.eliminate
        expect(agent.alive).to eq(false)
      end
    end

    context 'when next tile is a Food' do
      let(:food) { Entities::Food.new }

      it 'eats the food' do
        allow(Entities::Field).to receive(:get_neighbors).and_return([Entities::EmptySquare.new, food])
        expect(agent).to receive(:eat)
        expect(agent.action([], 0, 0)).to be(food)
      end
    end

    context 'when next tile is another Agent' do
      let(:other) { Entities::Agent.new(name: 'Z') }

      it 'fights the agent' do
        allow(Entities::Field).to receive(:get_neighbors).and_return([Entities::EmptySquare.new, other])
        expect(agent).to receive(:fight).with(other)
        expect(agent.action([], 0, 0)).to eq('Z')
      end
    end

    context 'when next tile is self' do
    end

    context 'when there is no action to be taken' do
    end
  end
end
