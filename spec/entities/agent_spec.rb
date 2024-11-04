# frozen_string_literal: true

require_relative '../spec_helper'

describe Entities::Agent do
  describe '.action' do
    let(:genes) { { sight: 1, move: 1 } }
    let(:agent) { Entities::Agent.new(name: 'A', seed_genes: genes) }
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
        chosen_tile = agent.action([], 0, 0)
        expect(chosen_tile).to eq(other)
      end
    end

    context 'when encountering self' do
      it 'moves to a random tile within range' do
        tiles = [Entities::EmptySquare.new, agent]
        allow(Entities::Field).to receive(:get_neighbors).and_return(tiles)
        expect(agent).not_to receive(:fight)
        chosen_tile = agent.action([], 0, 0)
        expect(tiles.include?(chosen_tile)).to be_truthy
      end
    end

    context 'when there is no action to be taken' do
      it 'moves to a random tile within range' do
        tiles = Array.new(9) { Entities::EmptySquare.new }
        allow(Entities::Field).to receive(:get_neighbors).and_return(tiles)
        expect(agent).not_to receive(:fight)
        chosen_tile = agent.action([], 1, 1)
        expect(tiles.include?(chosen_tile)).to be_truthy
      end
    end
  end

  # describe '.mutate_seeds' do
  #   before do
  #     srand(0)
  #   end

  #   it 'should randomly mutate the seeds by MUTATION_FACTOR' do
  #     director = Director.new(rows: 0, cols: 0, num_agents: 0, num_food: 0)
  #     seeds = [{sight: 1, height: 10}, {sight: 0}, {sight: 10, speed: 0, aggression: -1000}]

  #     mutated_seeds = director.mutate_seeds(seeds)

  #     expect(mutated_seeds[0]).to eq({sight: 1.3, height: 7.0})
  #     expect(mutated_seeds[1]).to eq({sight: 0.0})
  #     expect(mutated_seeds[2]).to eq({sight: 13, speed: 0.0, aggression: -700})
  #   end
  # end
end
