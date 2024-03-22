function saveFile(number_of_styles, minimum_transmitter_styles, minimum_recievers_styles, min_quantity, max_quantity,min_diameter, max_diameter, min_power, max_power,year,include_monostatic,k,nu,maximum_elements,loop_gain_desired,table)

        labels = ["k";"nu";"number_of_styles"; "minimum_recievers_styles"; "minimum_transmitter_styles"; "min_diameter";"max_diameter";
            "min_quantity" ;"max_quantity";"min_power" ;"max_power"; "maximum_elements"; "loop_gain_desired"; "year";"include_monostatic"];
        
        parameters = [k,nu,number_of_styles,minimum_recievers_styles,minimum_transmitter_styles,min_diameter,max_diameter,min_quantity,max_quantity,min_power,max_power,maximum_elements,loop_gain_desired,year,include_monostatic];

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
 
end 