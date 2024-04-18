# Saving the file

## The saveFile function 
Arguments: <br />
list_parameters, disp_table

Variables:<br />
labels_parameters = list of the label names <br />
dict_parameters = table of labels and values of parameters<br />
current_time = accessing the current date and time in string format<br />
filename = creating the file name to be saved


The code takes the list of parameter values and the display table and saves them to 2 excel spreadsheets. The first sheet
is the input iable of the input parameters from the main script. The second sheet is the display table of the optimal solutions.
     
## Calling the saveFile Function in Main Script
The save function is called in the main script with the dot operator for the optimization output class in the optimization output script. <br> <br>
`disp_obj.output.saveFile(list, disp_table)`;<br> <br>
disp_obj: an instance of the optimization_output class <br>
.saveFile: the safeFile function in the class <br>
(list, disp_table): the arguments to be sent to the saveFile function


