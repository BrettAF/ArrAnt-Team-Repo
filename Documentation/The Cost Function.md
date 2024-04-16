Note: Do the uniform variables tomorrow, then just CTRL+F
# The Cost Function
The cost function used within this directory is a .m file used to calculate the total cost of a receiving and transmitting array, or a monostatic array. The total cost calculated using this function is then used as a parameter in radar_optimization.m to find points along the pareto front comparing total array cost and loop gain.

The function combines paremetric and analogous cost estimation techniques to estimate major components which then add to the total cost. These major components include the receivers, transmitters, the antennae, the concrete, and the trenching. Escalation is then applied to the summation of major component costs.

## Calling the Function
While the function is designed to be unobtrusive, never being called on in the main live script, it is a working function called on by radar_optimization.m and can be called by other scripts or by the command window. 

The inputs to the cost function are vectors and scalars. 
* Quantity: vector input with each index indicating the number of antennae for a unique style
* Diameters: vector input with each index indicating the antenna diameter in meters, with each index having the same style as quantity
* Power: vector input with every index indicating each individual antenna's transmitting power in Watts, with each index having the same style as quantity and diameter
* Receivers and transmitters: logical input vectors, with every index has the same styles as quantity, diameter, and power. Values indicat the antenna type, with a 1 being true.
* yearBuilt: scalar value indicating the expected construction date of the antenna array, which is then used to apply escalation
For examples and distinction of style vs type, please see the Styles and Type documentation. The cost function output is a scalar quantity in US dollars.

The cost function is called as:
```
function [total_cost] = cost_function(quantity,diameters,power,receivers,transmitters,yearBuilt)

%The cost_function outputs the total cost to build antenna arrays based
%on the number, diameter, and power. This cost includes both the
%transmitting and receiving arrays
```

## Changable Parameters
The cost function was designed to have no hard coded parameters. Part of this design is the changable parameters positioned immediately after the function. The parameters are positioned here in order for a user to open the funtions .m file and change the parameters to a values to a more suitable value, these changable parameters are based on estimated values. These parameters are:
* cost_receiver: the individual cost, in US dollars, for each soild state receiver, with each receiver antenna having one receiver
* trenching_per_m3: the estimated cost, in US dollars, to install a cubic meter of trenching. This value should be adjusted based on the intended terrain and required excavation tools
* depth: the depth of the trenching in inches. This value should be adjusted based on the codes and standards particular to the area the antenna arrays will be built
* width: the width of the trenching in inches. This value should be based on code, standards, and safety requirements
* spacing_by_diameter: this value is used to estimate the distance between antennas. The equation used is [n^1.6 = A*r](https://ieeexplore.ieee.org/abstract/document/1140131) where r is the radial distance of the antenna from the center of the array and A is a chosen constant. Data from the design of the [VLA](https://ieeexplore.ieee.org/document/1457033) was used in conjunction with the previously defined equation to solve for an estimated value of A, the spacing_by_diameter. This value should be changed based on the intended size of the antenna array
* trenching_scale: a unitless value indicating the length and difficulty required to complete the trenching of the tertain and should also be changed based on the soil and rock located at the intended build site
* misc_costs: miscellaneous costs, in US dollars, required to build the antenna, such as permits. At the current moment there is no estimated micellaneous cost resulting in a value of 0, so the value should be adjusted as necessary
* interest: the inflation or escalation of monetary value from year to year. The initial rate is a modest 1.5% and should be adjusted based on current or expected rates
```
cost_receiver = 400000; %$
trenching_per_m3 = 50; %$
depth = 44; %in
width = 24; %in
spacing_by_diameter=0.000082;
trenching_scale = 1;
misc_costs = 0; %$
interest = 1.5; % %interest, or %inflation
```
## Cost per Component
```  
    %% Cost per Component
    
    depth = depth*0.0254;%trenching depth from in to m
    width = width*0.0254;%trenching width from in to m
    trenching_per_m = trenching_per_m3*depth*width;
    %converted cost of trenching per meter^3 to trenching per meter based on 
    %depth and width
    trenching = trenching_scale*trenching_per_m*(sum(quantity,'all')/3)^1.6/(spacing_by_diameter*max(diameters)*1000)*3;
    %calculated by determining the number of antenna used in the array, using
    %this value to calculate N^1.6 * the unitless constant * the maximum 
    %diameter used in the array in m
    %the unitless constant spacing_by_diameter is initially defined using data
    %obtained for the VLA
    
    receiverC = quantity.*receivers*cost_receiver; %$
    %the total cost for the recievers for every diameter size, Receivec is a
    %vector with each index being the cost for the style of the same index
    
    % the below Cost per Component equations were determined using data and
    % curvefits, DO NOT change numerical values without reason as these are the
    % results of the curvefits
    
    transmitterC = quantity.*transmitters.*(0.0227*(power/1000)+1.1523)*1E6; %$
    %coefficient values were determined using a linear fit of data provided by
    %NG
    %Transmitterc is a vector with each index being the cost for the style of 
    %the same index
    %the /1000 converts the power from W to kW, the radar optimization inserts
    %the equation as W, this is because the linear fit used kW data
    
    concrete = quantity.*(1E4*(0.0706*diameters.^2+2.2827*diameters-4.4419)); %$
    %coefficient values were determined from data provided by NG using a
    %quadratic fit instead of a linear fit, as the quadratic better fit the 
    %provided data as well as the general trend
    %Concrete is a vector with each index being the cost for the style of the 
    %same index
    
    antenna = quantity.*(254283*exp(diameters.*0.1555)); %$
    %Estimated antenna cost function determined by NG, determined using an
    %exponential fit to NG data
    %Antenna is a vector with each index being the cost for the style of the 
    %same index
```
## Total Cost
```
    Total Cost
    cost = sum(antenna)+sum(transmitterC)+sum(concrete)+sum(receiverC)+trenching+misc_costs;
    % the total cost for the both the transmitting and receiving antenna
    % arrays, calculated by first summing up all the calculated vectors then
    % adding the trenching cost and miscellaneous cost since Trenching and
    % Misc_costs are both scalar values
    %if Trenching and Misc_costs are added before summing each component cost
    %it will result in error
    
    total_cost = cost*(1+interest/100)^(yearBuilt-2023);
    %total_cost is the cost of the total antenna array accounting for compound
    %interest/inflation, the interest variable can be changed to account for
    %bidding prices and escalation, this will calculate the estimated cost in
    %the the year of building
end 
```
