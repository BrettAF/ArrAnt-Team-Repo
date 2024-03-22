% Optimization_output script that displays a table and graph of optimal
% solutions
%      

function table = optimization_output(x,styles,operative_values, include_monostatic,desired_loop_gain)

    include_monostatic

     % create column names
     col_names = [];
     for i = 1:styles
         col_names = [col_names,"Type "+i,"Quantity "+i, "Diameter "+i+ " (m)","Power "+i + " (W)"];
     end % end for loop
 
 % These two lines add the cost and gain values to the table
 col_names = [col_names,"Cost ($M)","Gain (dB)"];
 x(:,(4*styles+1):(4*styles+2)) = operative_values;
 x(:,(4*styles+2)) = -x(:,(4*styles+2));
 
 % create a table using the x matrix and column names
 table = array2table(x,'VariableNames',col_names);

 % sort the table based on the gain column
 table = sortrows(table,'Gain (dB)');

 % change cost column to be in millions
 table.("Cost ($M)") = round(table.("Cost ($M)")/ 1e6, 3);
 
 % dynamically adjust values in the table 
 for i = 1:(styles)

     % change type columns to have have 0, 1 or 2 values (instead of float)
     if strcmp(include_monostatic,"T")
         % Transmitters - 0
         % Monostatic - 1
         % Receivers - 2
         table.(4*i-3) = floor(table.(4*i-3)); % Type
     else
         % Transmitter < 1.5
         % Reciever >= 1.5
         %Logical indexing to change values
         table.(4*i-3)(table.(4*i-3) >= 1.5) = 2;  % if greater than or equal to 1.5 it is a reciever
         table.(4*i-3)(table.(4*i-3) < 1.5) = 0; % if less than 1.5 it is considered a transmitter
     end % end if/else strcmp
     
     % change quantity columns to integer (instead of float)
     table.(4*i-2) = floor(table.(4*i-2)); % quantity

     % change reciever power to 0
     table.(4*i)(table.(4*i-3)==2)=0; % receiver

     % change type column to have text instead of integer   
     colName = "Type " + string(i); 
     table.(colName) = floor(table.(colName));
     table.(colName) = arrayfun(@(x) say_type(x), table.(colName), 'UniformOutput', false); % converts column to a string 

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

 function type = say_type(t)
    t = floor(t);
    if t == 0
        type='Transmitter';
    elseif t== 1
        type='Monostatic';
    elseif t== 2
        type='Receiver';
    else 
        type='error';
    end
 end % end say_type function
 


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



function t_output_graph(table,desired_loop_gain)
    
    % variables to hold the upper and lower line values 
    upper_line = desired_loop_gain*1.1;
    lower_line = desired_loop_gain*.9;    

    % Create scatter of table.Cost and table.Gain
    s = scatter(table,"Cost ($M)","Gain (dB)");
    
    % Add xlabel, ylabel, title, legend and lower and upper gain lines
    xlabel("Cost ($M)")
    ylabel("Gain (dB)")
    title("Gain vs. Cost")
    yline(upper_line,'-.g')
    yline(lower_line,'-.g')

    % Customizing data tips
    dcm = datacursormode(gcf); % Get the data cursor mode object for the current figure
    set(dcm, 'UpdateFcn', @(obj,event_obj) customDataTip(obj, event_obj, table));

    
end % t_output_graph function

% create a data tip so user can click on a data point and get more
% information
function txt = customDataTip(~, event_obj, table)

    % Get the position of the clicked point
    pos = event_obj.Position; 

    % Find the index (row number) of the closest point based on Euclidean distance
    distances = hypot(table.("Cost ($)") - pos(1), table.("Gain (dB)") - pos(2));
    [~, row] = min(distances);

    % Create the data tip text showing the row number
    txt = {['Solution: ', num2str(row)], ...
            ['Cost ($M)', num2str(table.("Cost ($M)")(row))], ...
            ['Gain: ', num2str(table.("Gain (dB)")(row)), ' dB']};
end % end custumDataTip

function saveCSV(parameters, table)

        labels = ["k";"Lambda";"number_of_styles"; "minimum_recievers_styles"; "minimum_transmitter_styles"; "min_diameter";"max_diameter";
            "min_quantity" ;"max_quantity";"min_power" ;"max_power"; "maximum_elements"; "loop_gain_desired"; "year";"include_monostatic"];
        
        parameters = parameters.';
        dictionary = array2table(parameters, 'RowNames', labels);
        %dictionary = table(horzcat(labels, parameters));
        t = datetime('now','TimeZone','local','Format','d_MMM_y_HH_mm_ss');
        t=string(t);
        filename = strcat("arraySolutions_",t,".xlsx");

        % Write the dictionary to the 'Parameters' sheet
        writetable(dictionary, filename, 'WriteRowNames', true, 'Sheet', 'Input Parameters');
    
        % Write the provided table to the 'Output Table' sheet
        writetable(table, filename, 'Sheet', 'Output Table');
 
end % end of saveCSV

% display output graph
t_output_graph(table,desired_loop_gain)

end % function table = optimization_output(x,styles,operative_values, include_monostatic, desired_loop_gain)