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
There are 3 parameters used in the gamultiobj function: FunctionTolerance, PopulationSize and MaxGenerations. They are entered as options in the beginning of the radar_optimization script so that they can be easy to find.
```MATLAB
options = optimoptions('gamultiobj', 'FunctionTolerance',1e-4,'PopulationSize', 400, 'MaxGenerations', 150);
```
- Function Tolerance: sets the tolerance on the fitness function, and it serves as one of the stopping criteria for the optimization process.
- Population Size: refers to how many candidates are in each generation.
- MaxGenerations: sets the number of iterations the optimization will run.
### Sensivity Analysis of Hyperparameters
A sensitity analysis was done to determine the optimal settings for these hyperparameters. 

This analysis concluded that the optimal values are:
- Function Tolerance: 1e-4
- Population Size: 400
- MaxGenerations: 150

