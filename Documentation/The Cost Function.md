# The Cost Function
The cost function used within this directory is a .m file calculating the total cost of a receiving, transmitting and/or a monostatic array. The total cost calculated using this function is then used as one of the parameters in radar_optimization.m to find optimal solution points along the Pareto front.

The cost function combines parametric and analogous cost estimation techniques to estimate the cost of major components which are then added to create the total cost. These major components include the receivers, the transmitters, the antennae, the concrete, and the trenching. Escalation is then applied to the summation of major component costs.

## Calling the Function
While the function is designed to be unobtrusive, never being called on in the main live script, it is a working function called on by radar_optimization.m and can be called by other scripts or by the command window. 

Inputs (vectors and scalars):
* `Quantity` : vector input with each index indicating the number of antennae for each style
* `Diameters` : vector input with each index indicating the antenna diameter in meters for each style
* `Powers` : vector input with each index indicating each individual antenna's transmitting power in Watts, for each style
* `Receivers` : logical input vectors, with every index containing values indicating the antenna type (1: receiver, 0: not a receiver).
* `Transmitters` : logical input vectors, with every index containing values indicating the antenna type (1: transmitter, 0: not a transmitter).
* `year_built` : scalar value indicating the expected construction date of the antenna array, which is then used to apply escalation
(For examples and distinction of style vs type, please see the Styles and Type documentation.)

Output:
* `total_cost` : total cost calculation as a scalar quantity in US dollars.

The cost function is called as:
```
function [total_cost] = cost_function(quantity,diameters,powers,receivers,transmitters,year_built)

%The cost_function outputs the total cost to build antenna arrays based on the number, diameter, and power. This cost includes both the
%transmitting and receiving arrays
```

## Changable Parameters
The cost function was designed to have no hard coded parameters. Part of this design is the changable parameters positioned immediately after the function. The parameters are positioned here in order for a user to open the funtions .m file and change the parameters values as needed.  Changeable parameters are based on estimated values. <br>
These parameters are:
* `cost_per_receiver` : the individual cost, in US dollars, for each cryogenically cooled receiver, with each receiver antenna having one receiver
* `trenching_per_m3` : the estimated cost, in US dollars, to install a cubic meter of trenching. This value should be adjusted based on the intended terrain and required excavation tools
* `trenching_depth` : the depth of the trenching in inches. This value should be adjusted based on the codes and standards particular to the area the antenna arrays will be built
* `trenching_width` : the width of the trenching in inches. This value should be based on codes, standards, and safety requirements
* `spacing_by_diameter` : this value is used to estimate the distance between antennas. The equation used is [n^1.6 = A*r](https://ieeexplore.ieee.org/abstract/document/1140131) where r is the radial distance of the antenna from the center of the array and A is a chosen constant. Data from the design of the [VLA](https://ieeexplore.ieee.org/document/1457033) was used in conjunction with the previously defined equation to solve for an estimated value of A. A was then divided by the diameter to calculate the spacing_by_diameter. This value should be changed based on the intended size of the antenna array
* `trenching_scale` : a unitless value indicating the length and difficulty required to complete the trenching and should also be changed based on the soil and rocks located at the intended build site
* `misc_costs` : miscellaneous costs, in US dollars, required to build the antenna, such as permits. At the current moment there is no estimated micellaneous cost resulting in a value of 0, so the value should be adjusted as necessary
* `interest` : the inflation or escalation of monetary value from year to year. The initial rate is a modest 1.5% and should be adjusted based on current or expected rates
```
cost_per_receiver = 400000; %$
trenching_per_m3 = 50; %$
trenching_depth = 44; %in
trenching_width = 24; %in
spacing_by_diameter=0.000082;
trenching_scale = 1;
misc_costs = 0; %$
interest = 1.5; % %interest, or %inflation
```
## Cost per Component
After the changable parameters have been set, individual components of the arrays are calculated for cost. These function use both the changable parameters and curve fits to determine these values.
### Trenching
The cost of trenching uses the [n^1.6 = A*r](https://ieeexplore.ieee.org/abstract/document/1140131) equation and the trenching_per_m3 to calculate the total cost of the trenching for the antenna arrays. The trenching_per_m3 cost is used to calculate the cost to trench per meter based on the required depth and width of the trenching.
1. The width and depth are converted from inches to meters then multiplied to the trenching_per_m3.
2. By multiplying the cost to dig a cubic meter by the two dimensions we calculate the cost to dig trenching per meter, stored as trenching_per_m.
3. The trenching_per_m is then used multiplied by the [n^1.6 = A*r](https://ieeexplore.ieee.org/abstract/document/1140131) equation. In this case n is the Quantity vector, summed to find the total number of antennas used in the arrays, then divided by 3 to find the number of antenna per branch. The A variable in this equation is the spacing_by_diameter parameter multiplied by the maximum diameter present within the arrays found within the diameters vector.
4. Once the cost per branch is calculated the cost is multiplied by 3 to account for the expected Y shape the arrays will take.
5. The scalar cost, in US dollars, for the total trenching is stored in the total_trenching_cost variable.
```
trenching_depth = trenching_depth*0.0254;%trenching depth from in to m
trenching_width = trenching_width*0.0254;%trenching width from in to m
trenching_per_m = trenching_per_m3*trenching_depth*trenching_width;
total_trenching_cost = trenching_scale*trenching_per_m*(sum(quantity,'all')/3)^1.6/(spacing_by_diameter*max(diameters)*1000)*3;
```
### Receivers
The receiver cost is a simple calculation. The cost is calculated by multiplying the scalar cost_per_receiver by the quantity vector and the logical receivers vector. The receiver vector is a logical vector indicating the antenna is either a transmitter or receiver so transmittering antennae are not included into the receivers cost. The output, receiver_cost_per_style, is a vector for the cost, in US dollars, for the total number of receivers, with each index being the same style in the quantity vector. It is assumed that there is only 1 receiver per receive antenna, though this can be modified using a scalar.
```
receiver_cost_per_style = quantity.*receivers*cost_per_receiver; %$
```
### Transmitters
The transmitter function calculates the cost for the transmitters based on the quantity of transmitting antenna and the power of each transmitter. The equation to estimate the transmitter cost was curve fitted using previous data, shown below.

![image](https://github.com/BrettAF/ArrAnt-Team-Repo/assets/166050829/20594ab9-817f-4358-9060-44368f145b98)

The data was used to create a linear curve fit, which had a R = 0.9934. The numerical values within the equation below are the result of the linear curve fit. The linear equation is a funciton of power in kilowatts. The cost per transmitter is calculated using the powers vector within the linear equation, then multiplying that resultant vector by the quantity and the transmitter vectors to calculate the total cost of the transmitters, transmitter_cost_per_style, with each index being a style. The powers is input as Watts, but the linear curve fit is in units of kW, so to prevent error the powers vector is divided by 1000 to convert from Watts to kW. Dot multiplication is used to ensure individual styles are not mixed. The transmitters vector is a logical vector indicating the antenna is either a transmitter or reciever so that the receivers are not included into the transmitters cost.

If additional data is provided, this equation, particularly the portion (0.0227*(powers/1000)+1.1523)*1E6, can be simply changed or updated based on the optimimal fit so long as power remains the independant variable.
```    
transmitter_cost_per_style = quantity.*transmitters.*(0.0227*(powers/1000)+1.1523)*1E6; %$
```
### Concrete
The concrete function calculates the cost for the concrete pad based on the quantity and diameter of the antennae. The equation to estimate the concrete cost was curve fitted using data from previous projects, shown below.

![image](https://github.com/BrettAF/ArrAnt-Team-Repo/assets/166050829/2acafbeb-ae3e-436a-b44c-76ca6a820e91)

The data was used to create a quadratic curve fit. A linear curve fit had an R = 0.9913, while a quadratic curve fit had an R = 0.9983. This is likely due to additional rebar and gradual pour required for thicker pads. The numerical values within the equation below are the result of the quadratic curve fit. The quadratic equation is a function of antenna diameter in meters. The cost per antenna pad is calculated using the diameter vector within the quadratic equation, then multiplying that resultant vector by the quantity vector. The concrete_cost_per_style vector is a vector containing the total cost, in US dollars, for the concrete antenna pads, with each index representing a style. The Dot multiplication is used to ensure individual styles are not mixed.

If additional data is provided, this equation, particularly the portion (1E4*(0.0706* diameters.^2+2.2827*diameters-4.4419)), can be simply changed or updated based on the optimimal fit so long as diameters remains the independant variable.
``` 
concrete_cost_per_style = quantity.*(1E4*(0.0706*diameters.^2+2.2827*diameters-4.4419)); %$
```
### Antenna
The antenna function calculates the cost for the antennae themselves based on the quantity and diameter of the antennae. The equation to estimate the antenna cost was curve fitted using data from previous projects, shown below.

![image](https://github.com/BrettAF/ArrAnt-Team-Repo/assets/166050829/1346489e-5654-490c-8380-0a04a4f52acb)

The data provided was used to create an exponential curve fit. The equation was initially calculated by members of Northrop Grumman, but the equation was verified to be the most accurate equation in comparison to quadratic, quartic, and Fourier series fit, among others. The numerical values within the equation below are the result of the exponential curve fit. Tha antenna cost is calculated using the diameters vector within the expontential equation, with the resultant vector being multiplied by the quantity vector. The antenna_cost_per_style vector is the total antenna cost, in US dollars, with each index representing a style. Dot multiplication is used to ensure individual styles are not mixed.

If additional data is provided this equation, particularly the portion (254283*exp(diameters.*0.1555)), can be simply changed or updated based on the optimimal fit so long as diameters remains the independant variable.
```
antenna_cost_per_style = quantity.*(254283*exp(diameters.*0.1555)); %$
```
## Total Cost
Once the cost of all major components have been calculated, the total cost is simply the summation of the calculated component vectors as well as the calculated trenching scalar and the miscellaneous cost parameter. The sum of each vector is individually calculated first to ensure that no value is accidentally added multiple times. Summation for component cost is calculated here, not after each of the above equations for multiple reasons. When analyzing and calculating the cost of the arrays, individual styles are kept together as the same index in the antenna_cost_per_style, transmitter_cost_per_style, concrete_cost_per_style, and receiver_cost_per_style vectors. This allows individual component costs based on diameter, power, and quantity to be kept with their same styles, allowing error calculation as well as modification to individual styles and analysis. After the sum of each vector is calculated the scalar total_trenching_cost and misc_costs are added to result in the total cost unadjusted for inflation, in US dollars.
Once the cost is calculated, interest is applied. All the models used data from 2023, so to accurately calculate future building projects, the cost is appropriately adjusted. Interest is calculated using the compound interest formula. The total_cost is the total project cost for the antenna arrays in US dollars for the year in which the project is built.
```
unadjusted_cost = sum(antenna_cost_per_style)+sum(transmitter_cost_per_style)+sum(concrete_cost_per_style)+sum(receiver_cost_per_style)+total_trenching_cost+misc_costs;

total_cost = unadjusted_cost*(1+interest/100)^(yearBuilt-2023);

```
