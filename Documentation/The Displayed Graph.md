# The Graph Function

Arguments: <br>
loop_gain_desired, disp_table <br>
The function takes in the desired loop gain argument to create the horizontal gain constraint lines and uses the disp_table to as the data for the graph.

The output_graph function uses the disp_table and creates a scatterplot of the optimal solutions. The x axis is the cost of the array and the y axis is the gain of the array. The 2 horizontal green lines are created and placed on the graph by calculating 10% +/- of the loop_gain_desired value.
