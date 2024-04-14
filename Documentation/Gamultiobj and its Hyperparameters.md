# Genetic Algorithms, Gamultobj(), and its Hyperparameters
## Genetic Algorithms
Genetic algorithms are heuristic algorithms based on evolutionary selection. 
for more information about genetic algorithms, visit [Geeks for Geeks, Genetic Algorithms](https://www.geeksforgeeks.org/genetic-algorithms/) or [Matlab, Genetic Algorithms](https://www.mathworks.com/help/gads/what-is-the-genetic-algorithm.html)

### Multi-objective values and pareto fronts
A Pareto front is a set of points that have points that have no superior values on both objectives.
### Gamultobj() 
Gamultiobj uses a controlled, elitist genetic algorithm based on a variant of NSGA-II. This function ranks its population primarily by their distance from the pareto front and secondarily by their distance from each other. This incentivizes answers which are not only close to the pareto front but also spread along it.  
For more information about gamultobj see [Matlab, gamultobj()](https://www.mathworks.com/help/gads/gamultiobj.html)

## Hyperparameters

