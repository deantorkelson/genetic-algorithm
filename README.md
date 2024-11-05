https://github.com/user-attachments/assets/d05280b7-7981-422f-9cc5-3e8699be949d

# genetic-algorithm
This genetic algorithm simulates generational evolution on a micro scale.

## What is it?
This tool creates a grid of tiles, some of which are populated by agents and some of which have food on them.
Each turn, each living agent scans its surroundings and makes a choice based on what's around.
The area it can check is determined by its `sight`.
Agents can fight each other, eat food on the ground, or just move in a random direction. 
Agents earn "score" by staying alive and eating food. The highest-scoring agents at the end of each round
pass on their genes to the next generation. Right now, those genes include "sight" (distance seen) and "speed" (turn order).

## What makes it generational?
At the end of each round, the "fittest" agents pass on their genes to the next generation, with a slight mutation.
Fitness is determined by:
- time spent alive
- food consumed

Eventually these genes will come with a cost, but right now there is no drawback to either so 
it is expected that sight will trend upwards until it plateaus at the size of the grid, and speed
will continue to grow unbounded.
