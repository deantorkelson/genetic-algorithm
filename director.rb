# frozen_string_literal: true

# typed: true

require 'sorbet-runtime'
require 'pry'
require 'zeitwerk'

loader = Zeitwerk::Loader.new
loader.push_dir("#{__dir__}/src")
loader.setup

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

Director.new(rows: 3, cols: 3, num_agents: 1, num_food: 1)
puts 'done'
