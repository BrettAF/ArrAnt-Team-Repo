# The Table of Solutions

## Decription
The create table function is nested in the optimization_output script and used to create a table of the optimal solutions in the main script. It is also saved as the second sheet, called "Output Table" in a .xlxs file.

## Usage
``` MATLAB
function disp_table = create_table(x,num_styles,operative_values, include_monostatic)
```
## Inputs
- `x`: matrix of optimal solutions
- `num_styles`: number of styles
- `operative_values`: cost and gain output values
- `include_monostatic`: String to determine if optimization includes Monostatic antennas

## Outputs
- `disp_table`: a table of the optimal solutions

## Explanation of Code
1. Create the column names
   -  Use a for loop to create a list of "Type", "Quantity" "Diameter" and "Power" repeated for the number of styles inputed.
   -  Add the cost and gain column names
2. Add the cost and gain objective values to the x matrix 
3. Create  the table
4. Format the values in the table
   - Change the cost value to millions
   - Sort the table by increasing gain
   - Use a for loop to dynamically change values for Type, Quantity, Diameter and Power as the number of columns will depend on the number of styles (for ex: 1 style = 4 columns, 2 styles = 8 columns, 3 columns = 12 columns)
5. Move the gain and cost columns to the beginning of the table.  

## Nested sayType Function

### Description
This function is used in the create_table function to change the 0, 1, 2 int value to either "transmitter", "receiver", or "monostatic" using if/else statement

### Usage
``` MATLAB
function type_string = say_type(type_int)
```
### Inputs
- `type_int`: type of antenna as an int of either 0, 1 or 2

### Outputs
- `type_string`: type of antenna as a string of either "transmitter", "receiver", or "monostatic"


