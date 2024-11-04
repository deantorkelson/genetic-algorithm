# frozen_string_literal: true

# typed: true

require 'pry'

$debug = false
$print_delay = 0.00

class Director
  ROUNDS = 100
  # Turns per round
  TURNS = 20

  attr_accessor :rows, :cols, :num_agents, :num_food

  def initialize(rows:, cols:, num_agents:, num_food:)
    @rows = rows
    @cols = cols
    @num_agents = num_agents
    @num_food = num_food
  end

  def run
    round = 1
    # seeds holds the top genes from the previous round. used as seeds for the next generation
    seeds = [{ genes: { sight: 2, speed: 100 }, score: 1 }]
    ROUNDS.times do
      puts "New seeds #{seeds.map{|seed_option| seed_option[:genes]}}"
      sleep(3)
      field = ::Entities::Field.new(rows: rows, cols: cols, num_agents: num_agents, num_food: num_food, seed_genes_options: seeds)
      puts "--ROUND #{round} STARTING--"
      puts field
      turn = 1
      TURNS.times do
        field.turn
        puts "--TURN #{turn}--"
        puts field
        sleep($print_delay)
        turn += 1
      end
      all_agents = (field.agents + field.dead_agents).sort.reverse
      top_agents = all_agents.first(3)
      seeds = top_agents.map { |agent| { genes: agent.genes, score: agent.score }}
      puts "--ROUND #{round} OVER!--"
      puts "Top Agents : Score : Genes"
      puts all_agents.map { |agent| "#{agent.name} : #{agent.score} : #{agent.genes}"}
      sleep(3) if $debug
      puts "Winning genes + score #{seeds}"
      sleep(2) if $debug
      round += 1
    end
  end
end
