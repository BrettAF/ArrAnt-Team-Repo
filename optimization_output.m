classdef optimization_output
    methods
        function disp_table = create_table(obj,x,num_styles, operative_values, include_monostatic,loop_gain_desired)
             include_monostatic
             num_parameters = 4;

             % create column names
             col_names = [];
             for i = 1:num_styles
                 col_names = [col_names,"Type "+i,"Quantity "+i, "Diameter "+i+ " (m)","Power "+i + " (W)"];
             end % end for loop
             
             % These two lines add the cost and gain values to the table
             col_names = [col_names,"Cost ($M)","Gain (dB)"];

             x(:,(num_parameters*num_styles+1):(num_parameters*num_styles+2)) = operative_values;
             x(:,(num_parameters*num_styles+2)) = -x(:,(num_parameters*num_styles+2));
             
            
             % create a table using the x matrix and column names
             table = array2table(x,'VariableNames',col_names);
             
                       
             % sort the table based on the gain column
             table = sortrows(table,'Gain (dB)');
            
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
                 table.(col_name_type) = arrayfun(@(int) say_type(int), table.(col_name_type), 'UniformOutput', false); % converts column to a string 
            
                  numCols = width(table);
            
                % Create the new table
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

        function txt = customDataTipCallback(obj, event_obj, table)
           disp("is CDT working?")
            % Get the position of the clicked point
            pos = event_obj.Position; 
        
            % Find the index (row number) of the closest point based on Euclidean distance
            distances = hypot(table.("Cost ($M)") - pos(1), table.("Gain (dB)") - pos(2));
            [~, row] = min(distances);
        
            % Create the data tip text showing the row number
            txt = {['Solution: ', num2str(row)], ...
                   ['Cost ($M)', num2str(table.("Cost ($M)")(row))], ...
                   ['Gain: ', num2str(table.("Gain (dB)")(row)), ' dB']};

        end

        function output_graph(obj, loop_gain_desired, table)
            %disp('output_graph method called on the object:');
            %disp(obj);
            % Create scatter of table.Cost and table.Gain
            scatter_graph = scatter(table.("Cost ($M)"), table.("Gain (dB)"));
            
            % Add xlabel, ylabel, title, legend and lower and upper gain lines
            xlabel("Cost ($M)")
            ylabel("Gain (dB)")
            title("Gain vs. Cost")
            yline(loop_gain_desired * 1.1, '-.g');
            yline(loop_gain_desired * 0.9, '-.g');
            
            % Customizing data tips
            dcm_obj = datacursormode(gcf); % Get the data cursor mode object for the current figure
            set(dcm_obj, 'UpdateFcn', @(src, event) customDataTipCallback(obj, event, table));
            
       end

       

        function saveFile(obj, list_parameters, table)

            labels_parameters = ["k";"Lambda";"number_of_styles"; "minimum_recievers_styles"; "minimum_transmitter_styles"; "min_diameter";"max_diameter";
            "min_quantity" ;"max_quantity";"min_power" ;"max_power"; "maximum_elements"; "loop_gain_desired"; "year";"include_monostatic"];            
            
            list_parameters = list_parameters.';
            dict_parameters = array2table(list_parameters, 'RowNames', labels_parameters);
            current_time = datetime('now','TimeZone','local','Format','d_MMM_y_HH_mm_ss');
            current_time = string(current_time);
            filename = strcat("arraySolutions_",current_time,".xlsx");
    
            % Write the dictionary to the 'Parameters' sheet
            writetable(dict_parameters, filename, 'WriteRowNames', true, 'Sheet', 'Input Parameters');
        
            % Write the provided table to the 'Output Table' sheet
            writetable(table, filename, 'Sheet', 'Output Table');
 
        end
    end
end
