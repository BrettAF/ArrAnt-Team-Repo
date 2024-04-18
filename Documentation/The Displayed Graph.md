# Displaying the Output Graph

## The ouput_graph Function

Arguments: <br>
loop_gain_desired, disp_table <br><br>
The function uses the desired loop gain argument to create the horizontal gain constraint lines and uses the disp_table to as the data for the graph.

The output_graph function uses the data form the disp_table and creates a scatterplot of the optimal solutions. The x axis is the cost of the array and the y axis is the gain of the array. The 2 horizontal green lines are created and placed on the graph by calculating 10% +/- of the loop_gain_desired value.

## Calling the output_graph Function in the Main Script
The graph function is called in the main script with the dot operator for the optimization output class in the optimization output script of the same name. <br> <br>
disp_obj.output_graph(loop_gain_desired, disp_table);<br> <br>
disp_obj: an instance of the optimization_output class <br>
.output_graph: the output graph function in the class <br>
(loop_gain_desired, disp_table): the arguments to be sent to the function
