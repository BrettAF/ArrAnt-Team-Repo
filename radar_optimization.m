% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 % radar_optimizaton Function Definition
 % This function generates a population of pareto optimal solutions, each 
 % representing one sparse radar array.
 % It receives parameters from the main_live_script and uses cost_function.m
 % and loop_gain.m to calculate the cost and gain of its members. 
 % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 % Parameters
 % styles: % A style is a group of congruent radar arrays. 
           % They share the same diameter, power, and type (see type on line 18).
 %
 % min_T_styles: Minimum number of styles of transmitters in the array
 % min_R_styles: Minimum number of styles of receivers in the array
 % min_quantity: Minimum number of antennas of one style
 % max_quantity: Maximum number of antennas of one style
 % min_diameter: Minimum diameter (meters) of the antenna of one style
 % max_diameter: Maximum diameter (meters) of the antenna of one style
 % min_power: Minimum power (watts) to each transmitter of one style
 % max_power: Maximum power (watts) to each transmitter of one style
 % year: Year array will be built
 % include_monostatic: % If allow_monostatic is set to "T", each style has either
                             % transmitter, reciever, or monostatic types of antennas
                             % If allow_monostatic is set to "F", each style has 
                             % transmitter or reciever types of antennas. 
 % k: Efficiency of antennas
 % lambda: Wavelength (meters)
 % maximum_elements: Maximum number of antennas in the entire array
 % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 % Return
 % x: matrix of pareto optimal solutions containing type, quantity,
 % diameter and power for each antenna style
 % fval: matrix of values of objective functions (cost and gain)
 % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


 function [x,fval] = radar_optimization(num_styles, min_t_styles,min_r_styles,min_quantity,max_quantity,min_diameter,max_diameter,min_power,max_power,year_built,include_monostatic,k,nu,max_antennas)
    
    num_parameters = 4; % currently four parameters: type, quantity, diameter, and power
    num_vars = num_parameters*num_styles; % number of variables used for the matrix x
    % options for gamultiobj
    options = optimoptions('gamultiobj', 'FunctionTolerance',1e-4,'PopulationSize', 150, 'MaxGenerations', 150);

    %speed of light = wavelength*frequency
    %speed of light in a vacuum, which decreases based on the density
    %of the medium
    c = physconst('LightSpeed');
    %the livescript has an input of Gigahertz, so iGHz = 10^9 Hz
    %calculating the wavelength in meters to be used in the loop gain
    nuHZ = nu*10^9;
    %function
    lambda = c/nuHZ;
    
  
    
    % A matrix is used to ensure that the maximum_elements is not exceeded
    A = [];
    
        % For loop to make a linear constraint for the number of antennas.
        % The sum of all of the antennas must be less than or equal to the
        % maximum_elements (b vector).
        for j = 1:num_styles
            A = [A,0,1,0,0]; 
        end
    
    % bounding vector
    b = [max_antennas];

    % equality contraints (not presently used)
    Aeq = [];
    beq = [];
    
    
    % calls bounding function to set lower and upper bounds of each parameter
    [lb,ub] = bounding(num_parameters,num_styles,min_diameter,max_diameter,min_power,max_power,min_quantity,max_quantity,min_t_styles,min_r_styles);
    
    % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    % gamultiobj is a built in function in Matlab that uses a genetic algorithm
    % to solve multi-variable minimization optimization problems with various
    % constraints. This program uses gamultiobj to find a pareto curve of
    % solutions for radar array design.
    % for more information about the gamultiobj function see: 
    % https://www.mathworks.com/help/gads/gamultiobj-algorithm.html#mw_c77c838e-b703-437f-9d91-a26d5927d65b
    % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
   
    
    % calls the gamultiobj function
    [x,fval] = gamultiobj(@objectives, num_vars, A, b, Aeq, beq, lb, ub, options);


        % nested function that calls the objective functions to calculate cost
        % and gain. 
        % needed by gamultiobj

        function f = objectives(x)
            [f(1),f(2)] = get_objectives_function(x,year_built,num_styles,k,lambda); % cost and gain
        end % end function f = ojectives(x)


    % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    % bounding Function Definition
    % creates the upper and lower bound for variables in 
    % the array. most of these are arguments passed from the main_live_script.
    % The exception being type. 
    % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    % Parameters
    % parameters: currently four parameters: type, quantity, diameter, and power
    % all others: see radar_optimization function for other parameters
    % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    % Return
    % lb: matrix of minimim values for each parameter in the x matrix
    % ub: matrix of maximim values for each parameter in the x matrix
    % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

     function [lb,ub ] = bounding(num_parameters,num_styles,min_diameter, ...
            max_diameter,min_power,max_power,min_quantity,max_quantity, ...
            min_t_styles,min_r_styles)

        % If/Else statement: removes the possibility of a monostatic array if
        % they are not permitted in the arguments.
        % lower and upper are set based on these rules to constrain the x
        % matrix appropriately
        % if allow_monostatic = "T" then type follows the following rules
        % Transmitters: 0 < t < 1
        % Monostatic:   1 < t < 2
        % Receivers:    2 < t < 3
        % if allow_monostatic = "F" then type follows the following rules
        % Transmitters: 0 < t < 1.5
        % Receivers:    1.5 < t < 3

        if strcmp(include_monostatic,"T")
            upper = 2;
            lower = 1;
        else 
            upper = 1.5;
            lower = 1.5;
        end

        % Lower and upper bounds for the parameters in the matrix
        % initialized to 0
        lb = zeros(1, num_parameters*num_styles);
        ub = zeros(1, num_parameters*num_styles);

        % For loop to add lower and upper values to each item in the lb
        % and ub list
        for i = 1:num_styles
            
            % Setting values for Type columns
            step = num_parameters-1; 
            % Transmitters are controlled on upper bound starting from left
            % to right. 
            % For example: if min_T_styles = 2, the left most two type columns
            % are set to hold only transmitters numbers less than the
            % upper variable
            if i <= min_t_styles
                ub(num_parameters*i-step) = upper;
            else ub(num_parameters*i-step) = 3;
            end % end if/else transmitters
            
            % Recievers are controlled on lower bound starting from right
            % to left.
            % For example: if min_R_styles = 2, the right most two type columns 
            % are set ti hold only receiver numbers greater than the lower
            % variable
            
            if i <= min_r_styles
                lb(num_styles*num_parameters-i*num_parameters+1) = lower;
            end % end if receivers


            % Setting lower and upper values for Quantity columns
            % Received as arguments to the bounding function from
            % the radar optimization function.
            % Received as arguments to the radar_optimization
            % function from the main_live_script (set by user).
            step = num_parameters-2;
            lb(num_parameters*i-step) = min_quantity;
            ub(num_parameters*i-step) = max_quantity;


            % Setting lower and upper values for Diameter columns
            % Received as arguments to the bounding function from
            % the radar optimization function.
            % Received as arguments to the radar_optimization
            % function from the main_live_script (set by user).
            step = num_parameters-3;
            lb(num_parameters*i-step) = min_diameter;
            ub(num_parameters*i-step) = max_diameter;
           
            % Setting lower and upper values for Power columns
            % Received as arguments to the bounding function from
            % the radar optimization function.
            % Received as arguments to the radar_optimization
            % function from the main_live_script (set by user).
            step = num_parameters-4;
            lb(num_parameters*i-step) = min_power;
            ub(num_parameters*i-step) = max_power;
    
        end % end for i = 1:number_of_styles

    end %function [lb,ub ]= bounding()


    % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    % objectiveFunction Definition
    % Prepares the elements of the population for the cost and gain function.
    % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    % Parameters
    % x: population matrix
    % year: year array will be built
    % styles: % A style is a group of congruent radar arrays. 
               % They share the same diameter, power, and type (see type on line 18).
    % lambda: Wavelength (meters)
    % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    % Return
    % C: matrix of values of cost objective functions 
    % G: matrix of values of gain objective functions
    % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
     function [C, G] = get_objectives_function(x,year_built,num_styles,k,lambda)

        % Create matrices of parameters initialized to 0
        diameters = zeros(1, num_styles); % diameters
        powers = zeros(1, num_styles); % powers
        quantity = zeros(1, num_styles); % quantities
        receivers = zeros(1, num_styles); % recievers
        transmitters = zeros(1,num_styles); % transmitters
    
        % For loop to populate the parameter matrices from the x matrix
        for i = 1:num_styles
            diameters(i) = x(num_parameters*i-1);   % diameters of each style of antenna
            powers(i) = x(num_parameters*i-0);   % transmitter power of each stle of antenna
            quantity(i) = floor(x(num_parameters*i-2));   %  quantity of each style of antenna
    
    
            % if/else statement depending on include_monostatic is 'T' or 'F'
            if strcmp(include_monostatic,"T")
                % if/else statement to populate R and T matrices
                % if floor of type does not equal 0 it is considered a receiver
                % if floor of type does not equal 2 it is a transmitter
                % recievers: a boolean vector (1 = reciever, 0 = transmitter)
                % transmitters: a boolean vector (1 = transmitter, 0 = receiver)
                if floor(x(num_parameters*i-3)) ~= 0      
                    receivers(i) = 1;
                end
                
                if floor(x(num_parameters*i-3)) ~= 2     
                    transmitters(i) = 1;
                end
            else
                % if/else statement to populate R and T matrices
                % if floor of type is less than 1.5 it is considered a receiver
                % if floor of type is greater or equal to 1.5 it is a transmitter
                % recievers: a boolean vector (1 = reciever, 0 = transmitter)
                % transmitters: a boolean vector (1 = transmitter, 0 = receiver)
                if x(num_parameters*i-3) >= 1.5
                receivers(i) = 1; 
                end
                if x(num_parameters*i-3) < 1.5
                transmitters(i) = 1; 
                end
            end
        end
    
        % Using matrix multiplication to set power to all the receivers to equal 0  
        powers = powers.*transmitters;
    
        % This calls the cost function from the cost_function.m file. 
        C = cost_function(quantity,diameters,powers,receivers,transmitters,year_built);
        
        % This calls the gain function from the loop_gain_function.m file. 
        % Gain is negative because it is being minimized. 
        % The gain will be multiplied by -1 after the last generation of the GA to make it positive.
        G = -loop_gain_function(quantity,diameters,powers,receivers,transmitters,k,lambda); 
   
    end % end objectiveFunction()  

end % radar_optimization()



