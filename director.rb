# frozen_string_literal: true

# typed: true

require 'sorbet-runtime'
require 'pry'
require 'zeitwerk'

loader = Zeitwerk::Loader.new
loader.push_dir("#{__dir__}/src")
loader.setup

TURNS = 100
$debug = false
$print_delay = 1

class Director
  def initialize(rows:, cols:, num_agents:, num_food:)
    field = ::Entities::Field.new(rows: rows, cols: cols, num_agents: num_agents, num_food: num_food)
    puts '--INITIAL--'
    puts field
    turn = 1
    TURNS.times do
      field.turn
      puts "--TURN #{turn}--"
      puts field
      sleep($print_delay)
      turn += 1
    end
  end
end

Director.new(rows: 10, cols: 20, num_agents: 30, num_food: 20)
# Director.new(rows: 1, cols: 5, num_agents: 1, num_food: 0)
puts 'done'
