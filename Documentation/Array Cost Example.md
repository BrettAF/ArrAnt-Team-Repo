# Cost Calculation Example
To explain and demonstrate the function of the cost function, here is an example and step-by-step calculation for the below inputs. These inputs are the same inputs used in the Loop Gain Example.

## Inputs
* `quantity`: [2, 3] (quantity of each antenna style)
  * Style 1: 2 antenna within the arrays
  * Style 2: 3 antenna within the arrays
* `diameters`: [30, 40] (diameters of each antenna style in m)
  * Style 1: The antenna for style 1 both have diameters of 30 meters
  * Style 2: The antenna for style 2 all have diameters of 40 meters
* `powers`: [1000, 9000] (transmitter power in watts of each antenna style)
  * Style 1: The antenna for style 1 both have a transmitter power of 1000 Watts
  * Style 2: The antenna for style 2 all have a transmitter power of 9000 Watts
    * If you look at the transmitter vector you will see Style 2 are receiving antennae and have no transmitters. This value input here will help demonstrate how the function accounts for the separation of transmitting and receiving antenna.
* `receivers`: [0, 1] (Boolean vector, 0 for transmitter, 1 for receiver)
  * Style 1: The antenna for style 1 are not receiver antenna and have no receivers
  * Style 2: The antenna for style 2 are receiver antenna and have receivers
* `transmitters`: [1, 0] (Boolean vector, 1 for transmitter, 0 for receiver)
  * Style 1: The antenna for style 1 are transmitter antenna and have transmitters
  * Style 2: The antenna for style 2 are not transmitter antenna and do not have transmitters
* `year_built`: 2027
  * the year in which the antenna array will begin construction is 2027

## Calculating Trenching Cost
There are numerous variables for trenching which can be changed based on the terrain and size the arrays will be located. These variables are not inputs in the function handle but within the code located at the top. For this example the default values are used.

    trenching_per_m3 = 50; %$
    %estimated cost of trenching installation per m^3
    trenching_depth = 44; %in
    %trenching depth, insert as inches as it is later converted to meters
    trenching_width = 24; %in
    %trenching width, insert as inches as it is later converted to meters
    spacing_by_diameter=0.000082;
    %n^1.6 = A*r where r is radial position and A is some chosen constant
    %VLA maximum of 21km has a A of approximately 2.066 1/km ~> A = 0.000082 for
    %25m dishes
    trenching_scale = 1;
    %the trenching scale is a unitless value indicating how long and arduous
    %excavations will be based on the soil type and rock hardness/size
Using these values the size of the trenching (with the length equal to 1 meter) is calculated. First the width and depth are converted into meters, then the cost to install trenching per meter cubed is multiplied to the size of the trench in order to calculate the cost to install trenching per meter in length.

$depth_{m} = depth_{in}* 0.0254$<br />
$depth_{m} = 44* 0.0254$<br />
depth = 1.1176 m<br />

$width_{m} = width_{in}* 0.0254$<br />
$width_{m} = 24* 0.0254$<br />
width = 0.6096 m<br />

$trenching_{m} = trenching_{m^3}* depth* width$<br />
$trenching_{m} = 50* 1.1176* 0.6096$<br />
trenching per meter = 34.06448<br />


$trenching = trenching scale* trenching_{m}* \frac{(\frac{\sum(quantity)}{3})^{1.6}}{spacing by diameter* max(diameters)* 1000)}* 3$<br />
$trenching = 1* 34.06448 * \frac{(\frac{\sum(2+3)}{3})^{1.6}}{0.000082* 40*1000)}*3$<br />
trenching = $ 759.0228696738

## Calculating Receivers Cost
There is a variable for receiver cost which can be changed based on the kind of receivers the arrays will be using. This variable is not an input in the function handle but within the code located at the top. For this example the default value is used.

    cost_per_receiver = 400000; %$
    %this is the cost ($) per reciever for each antenna as estimated by NG
$receiver = quantity.* receivers* cost per receiver$<br />
$receiver = [2, 3].* [0, 1]* 400000$<br />
$receiver = [2* 0* 400000, 3* 1* 400000]$<br />
$receiver = [0, 1200000]$

These values are in US dollars.

## Calculating Transmitters Cost
There are no additional variables located within the function for calculating the transmitter costs. The equation is the result of a curve fit from previous projects.

$transmitter = quantity.* transmitters.* (0.0227* \frac{powers}{1000} +1.1523)* 10^6 $<br />
$transmitter = [2, 3].* [1, 0].* (0.0227* \frac{[1000, 9000]}{1000}+1.1523)* 10^6$<br />
$transmitter = [2* 1* (0.0227* \frac{1000}{1000}+1.1523)* 10^6, 3* 0* (0.0227* \frac{9000}{1000}+1.1523)* 10^6]$<br />
$transmitter = [2350000, 0]$

These values are in US dollars.

## Calculating Concrete Cost
There are no additional variables located within the function for calculating the concrete costs. The equation is the result of a curve fit from previous projects.

$concrete = quantity.* 10^4*(0.0706* diameters.^2+ 2.2827* diameters-4.4419)$<br />
$concrete = [2, 3].* 10^4*(0.0706* [30, 40].^2+ 2.2827* [30, 40] -4.4419)$<br />
$concrete = [2* 10^4* (0.0706* 30^2 +2.2827* 30 - 4.4419), 3* 10^4* (0.0706* 40^2 +2.2827* 40 - 4.4419)]$<br />
$concrete = [2551582, 5994783]$

These values are in US dollars.

## Calculating Antenna Cost
There are no additional variables located within the function for calculating the antenna costs. The equation is the result of a curve fit from previous projects.

$antenna = quantity.* (254283* e^{diameters.* 0.1555})$<br />
$antenna = [2, 3].* (254283* e^{[30, 40].* 0.1555})$<br />
$antenna = [2* (254283* e^{30* 0.1555}), 3* (254283* e^{40* 0.1555})]$<br />
$antenna = [53992207.013996, 383486657.84337]$

These values are in US dollars.

## Calculating the Final Cost
There are two variables for the total cost which can be changed, the miscellaneous costs expected and the expected interest throughout the years. These variables are not inputs in the function handle but within the code located at the top. For this example the default values are used.

    misc_costs = 0; %$
    %in the future you may wish to add miscellaneous known costs not included
    %within the provided equations
    interest = 1.5; % %interest, or %inflation
    %the expected interest or increase in cost per year after 2023

$unadjusted cost = \sum(antenna)+\sum(transmitter)+\sum(concrete)+\sum(receiver)+trenching+misc$<br />
$unadjusted cost = \sum([53992207.013996, 383486657.84337])+\sum([2350000, 0])+\sum([2551582, 5994783])+\sum([0, 1200000])+759.0228696738+0$<br />
$unadjusted cost = 437489964.85737+2350000+8546365+1200000+759.0228696738+0$<br />
Unadjusted cost = 449587088.88024
Unadjusted cost = $449587088.88  -or-  $M 449.59

$total cost = unadjusted cost* (1+ \frac{interest}{100})^{yearBuilt-2023}$<br />
$total cost = 449587088.88024* (1+ \frac{1.5}{100})^{2027-2023}$<br />
Total adjusted cost = 477175348.96909

**Total Adjusted Cost = $477175348.97  -or-  $M 477.18**
