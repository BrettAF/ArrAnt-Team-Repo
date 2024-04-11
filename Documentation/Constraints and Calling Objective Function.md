# Constraints and Calling Objective Function
The parameters for optimization are passed to the RadarOptimization function( on the script of the same name) They are then passed to the bounding function to create constraints for the x-matrix. The A-matrix is also created to achieve these constraints. The output of these and the objective function itself are passed to the gamultobj function to perform the optimization. To learn more about gamultobj, see the Gamultobj and its Hyperparameters documentation.
## The Bounding Function
The bounding function constrains the minimum and maximum for the four parameters which are:
* Type
* Quantity
* Diameter
* Power
Minimum quantity, maximum quantity, minimum diameter, maximum diameter minimum power, and maximum power are received as arguments to the function. They were originally entered on the main live script. Type is not entered on the main live script, but minimum receiver styles and minimum transmitter styles are, and these two numbers are used to create the upper bounds and lower bounds for the optimization. 
lb: the upper bound vector contains all of the maximum values the array solutions are allowed to contain. 
ub: the lower bound vector contains all of the minimum values the radar array solutions are allowed to have.  
These two vectors are the length of the four parameters times the number of styles.
> For example:
> if a radar array had 3 styles, lb would be a vector 12 indices long, as would ub

## The A Matrix for Maximum Arrays
## The Objective Function
The loop gain function and the cost function expect to receive parameters in the form of vectors. They each receive the following vectors:
* transmitters
* 
*
