# Displaying the Output Graph

## Description
The create_graph function is nested in the optimization_output script and used to create a scatterplot of the optimal solutions with the x-axis as the Cost and the y-axis as the Gain. 

## Usage
```MATLAB
function create_graph(disp_table,loop_gain_desired)
```

## Inputs
- `disp_table`: Table of optimal solutions
- `loop_gain_desired`: The desired loop gain (dB) for the array
## Outputs

`scatter_graph`: scatterplot of the optimal solutions

## Explanation of Code
1. Use the desired loop gain argument to create the horizontal gain constraint lines
2. Create the graph.
3. Add interactive clicking on points to gain more info
   
## Nested customDataTip Function
This function uses the position of the mouse click to display info to the create_graph function



The output_graph function uses the data form the disp_table and creates a scatterplot of the optimal solutions. The x axis is the cost of the array and the y axis is the gain of the array. The 2 horizontal green lines are created and placed on the graph by calculating 10% +/- of the loop_gain_desired value.


