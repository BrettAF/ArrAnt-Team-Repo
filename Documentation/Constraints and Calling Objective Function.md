# Constraints and Calling Objective Function
Optimization constraints are needed in this program to set the upper and lower bounds of the parameters that will be used during the optimization. The user enters the parameter limits in the main script. These optimization parameters are then passed to the radar_optimization function to be used in the nested bounding function. The bounding function uses the parameters to create the constraints for the x-matrix and the A-matrix. The output of these matrices and the objective functions are passed to the gamultobj function to perform the optimization. (To learn more about gamultobj, see the "Gamultobj and its Hyperparameters" documentation)
## The Bounding Function
The bounding function constrains the minimum and maximum values for the four parameters:
* Type
* Quantity
* Diameter
* Power
 <br>
The minimum and maximum values for quantity, diameter, and power, entered in the main live script, are received as arguments to the bounding function. These min/max values are used to create the upper and lower bounds for the population created in the genetic algorithm. <be>

lb: the upper bound vector contains all of the maximum values the array solutions are allowed to contain. 
ub: the lower bound vector contains all of the minimum values the radar array solutions are allowed to have.  
These two vectors are the length of the four parameters times the number of styles. 
<br>
> For example:  
> If a radar array had 3 styles, lb and ub would be vectors with 12 indices.
<br>
    
*******The indices pertaining to quantity, diameter, and power will be the same, for each style, in both lb and ub vectors*****.
Type is recorded differently the other parameters in the main live script. Type constraints are determined by the including_monostatic variable, and the min_r_styles (minimum receiver styles), and min_t_styles (minimum transmitter styles) variables. These two numbers and the boolean flag are used to create the upper bounds and lower bounds for type. Type represents whether a style is a transmitter, a receiver, or a monostatic antenna. To learn more about styles see the Styles and Types documentation. How types are added to the vectors depends on whether the include_monostatic variablei is true or false. 
If allow_monostatic = "T", type uses the following rules:
* Transmitters: 0 < t < 1
* Monostatic:   1 < t < 2
* Receivers:    2 < t < 3
<br>
if allow_monostatic = "F",  type uses the following rules
<br>

* Transmitters: 0 < t < 1.5  
* Receivers:    1.5 < t < 3  
<br>

In order to give the user control over the sort of outputs the program will generate, minimum transmitter styles and minimum receiver styles were added. Minimum transmitter styles are controlled on the upper bound vector starting from the left and going to the right.  
> For Example:
> If the parameters are set such that solutions have three styles, and two of those styles must be transmitters.
> The upper bound vector will be set in the first two indices that control type to force the desired type.
> The first (leftmost) two styles in each solution will be transmitters. monostatic antennas are considered transmitters and receivers, so they may also appear here.
<br>         

Receivers are controlled on the lower bound vector. They start at the right side of the vector and work left.
<br>

> For example:
> If the parameters are set such that solutions have three styles, and two of those styles must be receivers.
> The last (rightmost ) two styles will be receivers.
<br>

If The array is set such that these overlap then the overlapping styles will result in monostatic antennas.
<br>   

> For Example:
> If the parameters are set such that solutions have three styles, two of those styles must be transmitters and two of those styles must be receivers.
> Then the central style of the three is constrained to be both a transmitter and a receiver. This will force it to be monostatic if that option is available.
<br>
  
If a style is forced to be a transmitter and a receiver, but monostatic arrays are not allowed, the program will default to producing receivers.

## The A Matrix
The parameter maximum total antennas is passed from the Main live script. This parameter is the only one that is global to the entire array solution, and not just one style of the solution. The bounding function does not handle this parameter, it is instead dealt with in the A matrix. The A matrix simply places the constraint that the sum of the quantity of antennas in each of the styles must be less than the maximum. to learn more about constrained optimization see [Constrained Optimization with Linear Algebra](https://medium.com/@nayla.khaleel202/constrained-optimization-and-linear-algebra-7ba3d5ee0643). 
## The Objective Function
The loop gain function and the cost function expect to receive parameters in the form of vectors. They each receive the following vectors:
* transmitters: a boolean vector that has 1 for every style that is a transmitter including monostatic antennas.
* Receivers: a boolean vector that has 1 for every style that is a receiver including monostatic antennas.
* Powers: A boolean vector that has the power of each style. The power of receiver antennas is made to be 0 in this vector with the following code.
```Matlab
powers = powers.*transmitters;
```


