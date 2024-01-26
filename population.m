classdef population
    properties
        pop_size;        % The size of the population

        number_of_types; % The number of distinct styles of radar array element that are permitted in our array

        min_diameter;    % The minimum diamater of any given element in an array in meters
        max_diameter;  
          
        min_quantity;    % The minimum quantity of elements of a given type in an array
        max_quantity;  
        
        min_distance;    % The minimum distance between elements of the same type in an array
        max_distance; 
          
        matrix;          % The matrix that holds all the genetic information for the population
        
    end
    methods(Static)
        function print_header()
            fprintf("\t\tType 1\t\t\tType2\n")
            fprintf("Qty \tDiameter \tPower \tType")
        end

        function obj=generate_population(pop_size, number_of_types, min_diameter, max_diamater, min_quantity, max_quantity, min_power, max_power)
            obj.pop_size = pop_size;
            
            obj.number_of_types =number_of_types;

            obj.min_diameter    =min_diameter;
            obj.max_diameter    =max_diamater;
            
            obj.min_quantity    =min_quantity;
            obj.max_quantity    =max_quantity;
            
            obj.min_power       =min_power;
            obj.max_power       =max_power;
            

            
    % element type is an integer between 0 and 2:
        % 0=reciever
        % 1=transmitter
        % 2=transmitter and reciever

    %the number of colums in the matrix is:
        % 4 paramaters times the number of types plus 3 for the
        % Gain, Cost and Total Rank calculations
        
            obj.matrix=zeros(pop_size, 3*number_of_types+3);
            
            for member =1:pop_size
                n = 1;
                while n <=number_of_types
                    obj.matrix(member,3*n-2)=randi([obj.min_quantity,obj.max_quantity]);
                    obj.matrix(member,3*n-1)=(obj.max_diameter-obj.min_diameter)*rand(1)-obj.min_diameter;
                    obj.matrix(member,3*n)=(obj.max_power-obj.min_power)*rand(1)-obj.min_power;
                    n = n+1;
                end
            
            end
            obj.matrix
        end


    end
end

