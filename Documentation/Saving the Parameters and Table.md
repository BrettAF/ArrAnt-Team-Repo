# Saving the file

## Description
The saveFile function is nested in the optimization_output script and used to save the input parameters and the output table to an .xlsx file.

## Usage
```MATLAB
function saveFile(disp_table)
```

## Inputs
`disp_table`: Table of optimal solutions

## Outputs
no variable outputs

## Explaining the Code
1. Create columns for the input sheet
   - `list_parameter_names`: list of the names of the input parameters
   - `list_parameters`: list of the values of the input parameters
   - `list_parameter_units`: list of the units of the input parameters
2. Create the parameter table
3. Create the filename using the current time
4. Write the parameter table and the display table to the excel file





     



