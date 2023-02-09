require_relative './entities/field'

class Director
  def initialize(rows:, cols:, num_agents:, num_food:)
    field = ::Entities::Field.new(rows: rows, cols: cols, num_agents: num_agents, num_food: num_food)
    puts field
  end
end

director = Director.new(rows: 8, cols: 8, num_agents: 5, num_food: 10)
