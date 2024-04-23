function optimization_output(x,num_styles,operative_values, include_monostatic,loop_gain_desired,min_t_styles,min_r_styles,min_quantity,max_quantity,min_diameter,max_diameter,min_power,max_power,year_built,k,nu,max_antennas)

    function disp_table = create_table(x,num_styles,operative_values,include_monostatic)
         % Number of Parameters (type, quantity, diameter, power)
         num_parameters = 4;

         % Create the Column Names
         col_names = [];
         for i = 1:num_styles
             col_names = [col_names,"Type "+i,"Quantity "+i, "Diameter "+i+ " (m)","Power "+i + " (W)"];
         end 
         
         col_names = [col_names,"Cost ($M)","Gain (dB,dBW)"];

         % Add the cost and gain objective values to the x matrix
         x(:,(num_parameters*num_styles+1):(num_parameters*num_styles+2)) = operative_values;
         x(:,(num_parameters*num_styles+2)) = -x(:,(num_parameters*num_styles+2));
       
        
         % create a table using the x matrix and column names
         table = array2table(x,'VariableNames',col_names);
                   
         % sort the table based on the gain column
         table = sortrows(table,'Gain (dB,dBW)');
        
         % change cost column to be in millions
         table.("Cost ($M)") = round(table.("Cost ($M)")/ 1e6, 3);
         
         % dynamically adjust values in the table 
         for i = 1:(num_styles)
        
             % change type columns to have have 0, 1 or 2 values (instead of float)
             if strcmp(include_monostatic,"T")
                 % Transmitters - 0
                 % Monostatic - 1
                 % Receivers - 2
                 table.(num_parameters*i-3) = floor(table.(num_parameters*i-3)); % Type
             else
                 % Transmitter < 1.5
                 % Reciever >= 1.5
                 %Logical indexing to change values
                 table.(num_parameters*i-3)(table.(num_parameters*i-3) >= 1.5) = 2;  % if greater than or equal to 1.5 it is a reciever
                 table.(num_parameters*i-3)(table.(num_parameters*i-3) < 1.5) = 0; % if less than 1.5 it is considered a transmitter
             end % end if/else strcmp
             
             % change quantity columns to integer (instead of float)
             table.(num_parameters*i-2) = floor(table.(num_parameters*i-2)); % quantity
        
             % change reciever power to 0
             table.(num_parameters*i)(table.(num_parameters*i-3)==2)=0; % receiver
        
             % change type column to have text instead of integer   
             col_name_type = "Type " + string(i); 
             table.(col_name_type) = floor(table.(col_name_type));
             table.(col_name_type) = arrayfun(@(int) say_type(int), table.(col_name_type), 'UniformOutput', false);
        
              numCols = width(table);
        
            % Move the Gain and Cost values to the beginning of the table
            disp_table = [table(:, numCols), table(:, numCols-1), table(:, 1:numCols-2)];
         end % end for i = 1:styles
 % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        % say_type Function Definition
        % inputs an integer representation of antennae and outputs a text 
        % representation of antennae 
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        % Parameters
        % t = the integer representation of antennae (0, 1 or 2)
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        % Return
        % type = text representation of antennae (Transmitter, Receiver,
        % Monostatic)
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   

       function type_string = say_type(type_int)
            type_int = floor(type_int);
            if type_int == 0
                type_string='Transmitter';
            elseif type_int== 1
                type_string='Monostatic';
            elseif type_int== 2
                type_string='Receiver';
            else 
                type_string='error';
            end
         end % end say_type function
    end

       
     

    % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    % output_graph Function Definition
    % create a scatterplot to represent cost and gain optimized solutions
    % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    % Parameters
    % table = table of optimized solution
    % desired_loop_gain: input from user in main_life_script to determine
    % the upper and lower horizontal lines.
    % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    % Return
    % displayed scatterplot graph
    % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


    function create_graph(disp_table,loop_gain_desired)
        
        % variables to hold the upper and lower line values 
        upper_line = loop_gain_desired*1.1;
        lower_line = loop_gain_desired*.9;    
    
        % Create scatter of table.Cost and table.Gain
        scatter_graph = scatter(disp_table,"Cost ($M)","Gain (dB,dBW)");
        
        % Add xlabel, ylabel, title, legend and lower and upper gain lines
        xlabel("Cost ($M)")
        ylabel("Gain (dB,dBW)")
        title("Gain vs. Cost")
        yline(upper_line,'-.g')
        yline(lower_line,'-.g')
    
    % Customizing data tips
        dcm = datacursormode(gcf);
        set(dcm, 'UpdateFcn', @(src, event_obj) customDataTip(event_obj, disp_table));
        datacursormode on;  % Turn on the data cursor mode
    
        % Inner function for custom data tip text
        function txt = customDataTip(event_obj, disp_table)
            pos = event_obj.Position;
    
            % Find the index (row number) of the closest point
            distances = hypot(disp_table.("Cost ($M)") - pos(1), disp_table.("Gain (dB,dBW)") - pos(2));
            [~, row] = min(distances);
    
            % Create the data tip text
            txt = {['Solution: ', num2str(row)], ...
                   ['Cost ($M)', num2str(disp_table.("Cost ($M)")(row))], ...
                   ['Gain: ', num2str(disp_table.("Gain (dB,dBW)")(row)), ' dB, dBW']};
        end
            
        end % t_output_graph function

        function saveFile(disp_table)

            list_parameter_names = ["Number of Styles"; "Minimum Transmitter Styles"; "Minimum Recievers Styles";"Minimum Quantity";"Maximum Quantity";"Minimum Diameter";"Max Diameter"; "Minimum Power" ;"Maximum Power"; "Year to be Built"; "Include Monostatic"; "k"; "nu"; "Maximum Number of Antennas"; "Desired Loop Gain"];            
            list_parameters = [num_styles;min_t_styles;min_r_styles;min_quantity;max_quantity;min_diameter;max_diameter;min_power;max_power;year_built;include_monostatic;k;nu;max_antennas;loop_gain_desired];
            list_parameter_units = ["";"";"";"";"";"m";"m";"W";"W";"";"";"";"GHz";"";"dB, dBW"];

            % Create the table
            param_table = table(list_parameter_names, list_parameters, list_parameter_units, 'VariableNames', {'Parameter', 'Value', 'Unit'});
            
            current_time = datetime('now','TimeZone','local','Format','y_MMM_d_HH_mm_ss');
            current_time = string(current_time);
            filename = strcat("arraySolutions_",current_time,".xlsx");
    
            % Write the dictionary to the 'Parameters' sheet
            writetable(param_table, filename, 'WriteRowNames', true, 'Sheet', 'Input Parameters');
        
            % Write the provided table to the 'Output Table' sheet
            writetable(disp_table, filename, 'Sheet', 'Output Table');
 
        end
% display output graph
disp_table = create_table(x,num_styles,operative_values, include_monostatic)
create_graph(disp_table,loop_gain_desired)
saveFile(disp_table)

end % function optimization_output(x,styles,operative_values, include_monostatic, desired_loop_gain)


