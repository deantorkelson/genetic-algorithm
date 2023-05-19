# frozen_string_literal: true

# typed: true

require 'sorbet-runtime'
require 'pry'
require 'zeitwerk'

loader = Zeitwerk::Loader.new
loader.push_dir("#{__dir__}/src")
loader.setup

TURNS = 6

class Director
  def initialize(rows:, cols:, num_agents:, num_food:)
    field = ::Entities::Field.new(rows: rows, cols: cols, num_agents: num_agents, num_food: num_food)
    puts '--INITIAL--'
    puts field
    turn = 1
    TURNS.times do
      field.turn
      puts "--TURN #{turn}--"
      turn += 1
      puts field
    end
  end
end

Director.new(rows: 9, cols: 9, num_agents: 1, num_food: 6)
puts 'done'
