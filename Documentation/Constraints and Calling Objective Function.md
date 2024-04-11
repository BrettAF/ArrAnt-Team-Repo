# Constraints and Calling Objective Function
The parameters for optimization are passed to the RadarOptimization function( on the script of the same name) They are then passed to the bounding function to create constraints for the x-matrix. The A-matrix is also created to achieve these constraints. The output of these and the objective function itself are passed to the gamultobj function to perform the optimization. To learn more about gamultobj, see the Gamultobj and its Hyperparameters documentation.
## The Bounding Function
The bounding function constrains the minimum and maximum for the 

## The A Matrix for Maximum Arrays
## The Objective Function
The loop gain function and the cost function expect to receive parameters in the form of vectors. They each receive the following vectors:
* transmitters
* 
*
