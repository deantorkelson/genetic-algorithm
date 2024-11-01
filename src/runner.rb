require_relative '../config/zeitwerk_loader'

Director.new(rows: 10, cols: 20, num_agents: 10, num_food: 30).run
# Director.new(rows: 1, cols: 5, num_agents: 1, num_food: 0)
puts 'done'
