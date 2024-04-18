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
A save function is called in the main script. The save function is called with the dot operator from the optimization output class in the script of the same name `output.saveFile(list, table)`.
