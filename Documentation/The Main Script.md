# The MATLAB Main Script
The main_script.mlx file is the MATLAB file in which the user enters all the parameters, performs the optimization and  receives all output results. The file is a live script, allowing the user to easily change the values of the input variables. <br><br>
There are three sections to the live script:
- Input Parameters:
- Run the Radar Optimization
- Print and Save the Radar Optimization Output

## Input Parameters
The live script allows for the user to have clear fields indicating where the user should insert the input and how that input can be changed. A view of the live input is shown in the image below.

![Live Inputs](https://github.com/BrettAF/ArrAnt-Team-Repo/assets/166050829/7be6d7e7-70c1-431a-98ce-229830bc958b)

* `k` is the expected efficiency of the antennae used within the arrays. The value is a double with a default value of 0.6. This value, being the effiency, should to any value between 0 and 1. This value is used within the loop gain function.
  * Do not set the expected efficiency above 1. The code will still run, but it won't be able to produce any viable results. Ensure that the input value is between 0 and 1 for the code to operate correctly.
* `nu` is the operating frequency of the transmitting and receiving antennae in GHz. This input is a double with a default value of 3 GHz, corresponding to a 10 cm wavelength. The code converts the frequency to wavelength within the radar optimization function.
  * Do not enter the wavelength, as the radar optimization converts the frequency to wavelength. Entering the wavelenght will produce results for the incorrect wavelength. Ensure that the input is the frequency.
  * Do not enter the wavelength in a value other than GHz. The radar optimization converts the frequency in GHz to Hz to calculate the required wavelenght. Ensure that the input frequency is converted into GHz. 
* `num_styles` is the number of different distinct styles the radar optimization will use in order to calculate point along the Pareto front. The value has a default value of 3, but can be input with any natural number within the range of 1 to 20. You can manually input the value or hit the adjacent arrow keys to change this value.
  * Do not change this value to 1 without also changing `include_monostatic` to true. Attempting this will result in error, as the loop gain function requires both a transmitting antenna and a receiving antenna at minimum to be present. There will be no results displayed.
* `min_r_styles` is the minimum number of distinct receiver styles which should be used within the radar optimization. The value has a default value of 1 but can be input with any natural number between 1 and 20. You can manually input the value or hit the adjacent arrow keys to change this value.
  * Do not change `min_r_styles` to a value greater than `num_styles`. This will cause similar errors within the loop gain function as changing `num_styles` to 1 without also changing `include_monostatic` to true. There will be solutions completely comprised of receiver antennae, resulting in a negative infinite gain.
* `min_t_styles` is the minimum number of distinct transmitter styles which should be used within the radar optimization. The value has a default value of 1, but can be input with any natural number between 1 and 20. You can manually input the value or hit the adjacent arrow keys to change this value. 
  * Do not change `min_t_styles` to a value greater than `num_styles`. This will cause the same error as with changing `min_r_styles` to a value greater than `num_styles`, resulting in negative infinite gain.
  * `min_t_styles` and `min_r_styles` do not need to add up to `num_styles`. The only constraint is that each individual value is less than `num_styles`.
* `min_diameter` is the minimum antenna diameter allowed to be used within the receiving or transmitting arrays. This input is a double with a default value of 1. This value is in meters.
  * Do not enter the `min_diameter` in inches, feet, etc. This will result in values are may be unintended, as both the loop gain function and the cost function require the diameter input to be in meters. Convert values to meters if necessary.
  * Do not enter a negative value. This will result in errors within both the loop gain function and the cost function, even though it may not initially appear so.
  * Do not enter a value such that `min_diameter` is greater than `max_diameter`.
* `max_diameter` is the maximum antenna diameter allowed to be used within the receiving or transmitting arrays. This input is a double with a default value of 40. This value is in meters.
  * Do not enter the `max_diameter` in inches, feet, etc. This will result in the same error as entering `min_diameter` in such a form.
  * Do not enter a negative value. This will result in errors within both the loop gain function and the cost function, even though it may not initially appear so.
  * Do not enter a value such that `min_diameter` is greater than `max_diameter`.
* `min_quantity` is the minimum number of antennae for an individual style. The value has a default value of 1, but can be input with any natural number between 1 and 100. You can manually input the value or hit the adjacent arrow keys to change this value.
  * Do not set `min_quantity` to be greater than `max_quantity`. This will result in an error code and failure to run.
* `max_quantity` is the maximum number of antennae used for an individual style. The value has a default value of 1, but can be input with any natural number between 1 and 200. You can manually input the value or hit the adjacent arrow keys to change this value.
  * Do not set `min_quantity` to be greater than `max_quantity`. This will result in an error code and the failure to run.
* `min_power` is the minimum power in Watts to be used in a singular transmitting antenna. The input is a double with a default value of 100. The value is in Watts.
  * Do not enter a negative value. This will result in errors within both the loop gain function and the cost function such that there is no output.
  * Do not enter a value such that `min_power` is greater than `max_power`.
* `max_power` is the maximum power in Watts to be used in a singular transmitting antenna. The input is a double with a default value of 5000000. The value is in Watts, so the maximum by default is 5 MW.
  * Do not enter a negative value. This will result in errors within both the loop gain function and the cost function such that there is no output.
  * Do not enter a value such that `min_power` is greater than `max_power`.
* `max_antenna` is different from `max_quantity`. `max_antenna` is the maximum total number of antennae, the sum of all transmitting and receiving antenna. The function will still operate normally if `max_antenna` is less than `max_quantity`, but the maximum number of antenna will instead be constrained by `max_antenna` instead of `max_quantity`. The value has a default value of 400, but can be input with any natural number between 1 and 1000. You can manually input the value or hit the adjacent arrow keys to change this value.
  * Do not enter a value such that `max_antenna` is less than `min_quantity`. This will result in an error code and the failure to run.
* `loop_gain_desired` is the loop gain desired by the solution. This input is a double with a default of 200. This value is in dB.
  * Do not enter this value in as dBm, this will result in incorrect solutions.
  * Do not enter a negative number, there will be no solutions within this desired range.
* `yearBuilt` is the year in which the construction is expected to begin for the chosen solution. This year should be in the Gregorian calendar.
  * Do not use years based on other calendars. The cost function uses the year to apply escalation, so inputing an incorrect year will result in incorrect cost values.
* `include_monostatic` is a dropdown tool allowing the user to determine whether the solution should include monostatic arrays or not. The default selection "False" will prevent monostatic arrays from being included in the Pareto front. "True" allows monostatic arrays to be included. To change the selection click on the text, which will then produce a dropdown of the two options. Click on the desired selection.
  * Do not change `num_styles` to 1 without also changing `include_monostatic` to true. Attempting this will result in error, as the loop gain function requires both a transmitting antenna and a receiving antenna at minimum to be present. There will be no results displayed.

In order to change the input variables to their default values, right click on the control then select "Restore Default Value". If the user desires to expand solutions beyond current bounds, first deterimine the desired controls that need to be changed. Individually right click each control, then select "Configure Control". Once the control menu is visible, change the minimum, maximum, and default values to the desired values.

A plain .m version of the live script code:
```
 k= 0.6; % efficiency of attenae
 nu = 3;  % frequency (GHz) which is converted to meters for the loop gain
  
 num_styles = 3; % The number of distinct styles of radar array antennas that are permitted in the array  
 min_r_styles = 1; % the minimum number of styles that must to be recievers
 min_t_styles = 1; % the minimum number of styles that must to be transmitters

 min_diameter = 1;
 max_diameter = 40; % The maximum diamater (meters) of any given antenna in the array
    
 min_quantity =  1;
 max_quantity = 80; % The maximum quantity of antennas of one style in the array
      
 min_power = 100;
 max_power = 500000; % The maximum power (watts) for each antenna in the array
 
 max_antennas = 400; % The maximum total number of antennas in the array

 loop_gain_desired = 200; % The desired loop gain (dB) for the array
 
 year_built = 2030; % the year the array intends to be built

 include_monostatic = "F"; % change to a T to include monostatic antennas, change to a F to exclude monostatic antennas
```

## Run the Radar Optimization
```MATLAB
[x, operative_values] = radar_optimization(num_styles,min_t_styles,min_r_styles,min_quantity,max_quantity,min_diameter,max_diameter,min_power,max_power,year_built,include_monostatic,k,nu,max_antennas);
```
This code calls the radar_optimization script using the input parameters. It returns the x matrix and the operative_values (cost and gain)


## Print and Save the Radar Optimization Output
```MATLAB
optimization_output(x,num_styles,operative_values, include_monostatic,loop_gain_desired, min_t_styles,min_r_styles,min_quantity,max_quantity,min_diameter,max_diameter,min_power,max_power,year_built,k,nu,max_antennas)
```
This code calls the optimization_output script to display a table of optimal solutions, a scatterplot and save the input parameters and output table as a .xlsx file. The .xlsx file is saved in the current directly. More info on the create_table function, the create_graph function and the saveFile function can be found in its own documentation section.
