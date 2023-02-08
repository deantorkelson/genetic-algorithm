# genetic-algorithm
grid of spaces, containing agents and food
each agent has a set of characteristics and energy
each agent performs an action in turn order
actions:
- move
    - costs energy
    - do agents move randomly or towards food?
    - do agents have a stat for making sure they move around as opposed to in circles (part of sight?)
    - encounter food: gain energy
        - does food continue spawning or only at the start?
    - encounter other agent - agent with higher energy wings
        - do agents consume other agent’s energy?
- stay still

fittest agents reproduce at the end and create new generation
fitness determined by:
- time spent alive
- other agents defeated
    - is this considered by them consuming energy?
- food consumed
take these top-performing agents and randomize their stats a little
- agents with the "highest" stats shouldn’t always win - gaining one stat should have a little bit of a drawback, otherwise 9999 everything is the best

should have a UI where user can watch each generation explore the grid and whatnot, should accept input to either go automatically or step by step ( or agent by agent), user should be able to speed up or slow down the simulation.
grid should display agents (each has unique hue, saturation displays energy levels? and food sources), and ideally also each agent’s sight


Slightly randomize costs/benefits for things to see how it affects final agents?
