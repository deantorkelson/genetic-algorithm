# typed: true

require 'sorbet-runtime'
require 'pry'
require_relative './entities/field'

class Director
  def initialize(rows:, cols:, num_agents:, num_food:)
    field = ::Entities::Field.new(rows: rows, cols: cols, num_agents: num_agents, num_food: num_food)
    puts '--INITIAL--'
    puts field
    field.turn
    puts '--TURN 1--'
    puts field
  end
end

director = Director.new(rows: 3, cols: 3, num_agents: 1, num_food: 1)

