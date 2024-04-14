# Genetic Algorithms, Gamultobj(), and its Hyperparameters
## Genetic Algorithms
Genetic algorithms are heuristic algorithms based on evolutionary selection. The process follows the following steps:
1. Initial population
1. Fitness function
1. Selection
1. Crossover
1. Mutation  

The population is initially filled within randomly generated numbers (within constraints). The set of numbers that represent an individual is usually called a chromosome. The population is then tested with one or more functions called the fitness functions to determine which members of that population are most optimal.  
A new population is then generated based on members from the previous generation, with more fit ( higher scoring members on the fitness function) members being more likely to be selected to reproduce offspring. Two parents are selected to produce two offspring.  A random location is picked along the length of the chromosomes of the parents and everything after that point (called the crossover point) is swapped to generate the two offspring. This process is repeated until the new population is filled to the appropriate number of members.   
A small amount of random mutation is then applied to the chromosomes to prevent the population getting stuck in a local minima.
This process will be completed until the new population is not meaningfully better than the previous, or until a maximum number of iterations is reached.  
For more information about genetic algorithms, visit [Geeks for Geeks, Genetic Algorithms](https://www.geeksforgeeks.org/genetic-algorithms/) or [Matlab, Genetic Algorithms](https://www.mathworks.com/help/gads/what-is-the-genetic-algorithm.html)

### Multi-objective values and pareto fronts
A Pareto front is a set of points that have points that have no superior values on both objectives.
### Gamultobj() 
Gamultiobj uses a controlled, elitist genetic algorithm based on a variant of NSGA-II. This function ranks its population primarily by their distance from the pareto front and secondarily by their distance from each other. This incentivizes answers which are not only close to the pareto front but also spread along it.  
For more information about gamultobj see [Matlab, gamultobj()](https://www.mathworks.com/help/gads/gamultiobj.html)

## Hyperparameters

