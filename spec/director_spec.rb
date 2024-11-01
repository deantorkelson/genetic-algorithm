# frozen_string_literal: true

require_relative './spec_helper'

describe Director do
  describe '.mutate_seeds' do
    before do
      srand(0)
    end

    it 'should randomly mutate the seeds by MUTATION_FACTOR' do
      director = Director.new(rows: 0, cols: 0, num_agents: 0, num_food: 0)
      seeds = [{sight: 1, height: 10}, {sight: 0}, {sight: 10, speed: 0, aggression: -1000}]

      mutated_seeds = director.mutate_seeds(seeds)

      expect(mutated_seeds[0]).to eq({sight: 1.3, height: 7.0})
      expect(mutated_seeds[1]).to eq({sight: 0.0})
      expect(mutated_seeds[2]).to eq({sight: 13, speed: 0.0, aggression: -700})
    end
  end
end
