require_relative '../spec_helper'

describe ::Entities::Agent do
  describe '.action' do
    let(:agent) { ::Entities::Agent.new(name: 'A', genes: genes) }
    let(:genes) { { sight: 1, move: 1} }
    let(:grid) { Array.new(3) { Array.new(3) { EmptySquare.new } } }

    context 'when agent is dead' do
      it 'does nothing' do
        agent.eliminate
        expect(agent.alive).to eq(false)
      end
    end

    context 'when next tile is a Food' do
      it 'eats the food' do
        allow(Field).to receive(:get_neighbors).and_return([EmptySquare.new, Food.new])
        expect(agent).to receive(:eat)
        expect(agent.action([], 0, 0))
      end

    end

    context 'when next tile is another Agent' do

    end

    context 'when next tile is self' do

    end

    context 'when there is no action to be taken' do

    end
  end
end