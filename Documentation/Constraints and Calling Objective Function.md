# Constraints and Calling Objective Function
The parameters for optimization are passed to the RadarOptimization function( on the script of the same name) They are then passed to the bounding function to create constraints for the x-matrix. The A-matrix is also created to achieve these constraints. The output of these and the objective function itself are passed to the gamultobj function to perform the optimization. To learn more about gamultobj, see the Gamultobj and its Hyperparameters documentation.
## The Bounding Function
The bounding function constrains the minimum and maximum for the four parameters which are:
* Type
* Quantity
* Diameter
* Power  
Minimum quantity, maximum quantity, minimum diameter, maximum diameter minimum power, and maximum power are received as arguments to the function. They were originally entered on the main live script. They are used to create the upper and lower bounds for the population created in the genetic algorithm. Type is not entered on the main live script, but includes monostatic, minimum receiver styles, and minimum transmitter styles are. These two numbers and the boolean flag are used to create the upper bounds and lower bounds for type. 
lb: the upper bound vector contains all of the maximum values the array solutions are allowed to contain. 
ub: the lower bound vector contains all of the minimum values the radar array solutions are allowed to have.  
These two vectors are the length of the four parameters times the number of styles.
> For example:  
> If a radar array had 3 styles, lb would be a vector 12 indices long, as would ub.
    
For each style in both vectors, the indices pertaining to quantity, diameter, and power will be the same.
Type represents whether a style is a transmitter, a receiver, or a monostatic. To learn more about styles see the Styles and Types documentation. How types are added to the vectors depends on whether include monostatic is true. if it is, the program will proceed with the following logic:
* Transmitters: 0 < t < 1
* Monostatic:   1 < t < 2
* Receivers:    2 < t < 3  
if allow_monostatic = "F" then the type follows the following rules
* Transmitters: 0 < t < 1.5
* Receivers:    1.5 < t < 3  
In order to give the user control over the sort of outputs the program will generate, minimum transmitter styles and minimum receiver styles were added. Minumum transmitters styles are controlled on the upper bound vector starting from the left and going to the right.  
> For Example:
> If the parameters are set such that solutions have three styles, and two of those styles must be transmitters,
> The first (leftmost) two styles in each solution will be transmitters. monostatic antennas are considered transmitters and receivers, so they may also appear here.      
Receivers are controlled on the lower bound vector. They start at the right side of the vector and work left.  
> For example:
> If the parameters are set such that solutions have three styles, and two of those styles must be receivers.
> The last (rightmost ) two styles will be receivers.  
If The array is set such that these overlap then the overlapping styles will result in monostatic antennas.  
> For Example:
> If the parameters are set such that solutions have three styles, two of those styles must be transmitters and two of those styles must be receivers.
> Then the central style of the three is constrained to be both a transmitter and a receiver. This will force it to be monostatic if that option is available.  
If a style is forced to be a transmitter and a receiver, but monostatic arrays are not allowed, the program will default to producing receivers.

## The Objective Function
The loop gain function and the cost function expect to receive parameters in the form of vectors. They each receive the following vectors:
* transmitters
* 
*
