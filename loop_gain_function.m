function loop_gain = loop_gain_function(number, diameters, power,receivers, transmitters, k,lambda)
    % This function calculates loop gain.
    %
    % number: a vector of the quantity of each type of antenna
    % diameters: a vector of the diameters of each type of antenna
    % power: Transmitter power recieved as a vector
    % recievers: a boolean vector with 1 for a reciever and 0 for a
    %   transmitter
    % transmitters: a boolean vector with 1 for transmitters and 0 for
    %   recievers
    % k: efficiency of the antenna
    % lambda: wavelength as GHz/10cm
    
    % num_transmitters: A vector of the number of transmitters with 0 for
    %   the recievers
    num_transmitters = number.*transmitters;
    
    % num_recievers: A vector of the number of recievers in each style with
    %   0 for transmitters
    num_recievers = number.*receivers;
    
    % power_transmitters: Transmitter power recieved as a vector with 0 for
    %   recievers
    power_transmitters = power.*transmitters;
    
    % EIRP of the array
    EIRP = gain_all_transmitters(k,num_transmitters,diameters,lambda,power_transmitters);
    
    % MGr : total gain of the recievers in the array
    MGr = gain_all_recievers(k,num_recievers,diameters,lambda);

    % Loop Gain Equation
    % eirp_a = NPt * NGt;
    % MGr = M * Gr
    % loop_gain = eirp of the array + array gain of recievers;
    % loop_gain = EIRP + MGr
    loop_gain = EIRP + MGr;



    function EIRP_A_dB = gain_all_transmitters(k,num_transmitters,diameters,lambda,power) % EIRP
        % Calculate transmitter gain for the array
        % This function calculates parabolic gain.
        % 
        % diameter: Diameter of the antennas, recieved as a vector
        % lambda: Wavelength of the signal
        % power: power to the arrays in watts, an array with 0 for
        %   recievers
        % k: effencency of the arrays

        % returns the parabolic array of one antenna of each style of the
        % radar array, returns an vector
        G_t = k * (pi * (diameters ./ lambda)).^2; 
        
        % returns the sum gain of all of the antennas of each style of the array
        %array_gain_t = num_transmitters .* parabolic_gain;
        %^^^ I think the issue is here. EIRP of the transmit is
        %log10(N^2*P*G), for each individual style, then summed together
        
        array_gain_t = num_transmitters.^2.*power.*G_t;
        %correct form
        total_gain=sum(array_gain_t);
        EIRP_A_dB = 10 * log10(total_gain);
    end

    function reciever_gain_dB = gain_all_recievers(k,num_recievers,diameters,lambda) %MGr
        % Calculate total reciever gain for the array
        % This function calculates parabolic gain.
        % diameter: Diameter of the antennas, recieved as a vector
        % lambda: Wavelength of the signal

        % returns the parabolic array of one antenna of each style of the
        % radar array, returns an vector
        G_r = k * (pi * (diameters ./ lambda)).^2;
       
        % returns the gain of all of the antennas of each style of the array
        array_gain_r = num_recievers .* G_r;
        total_gain=sum(array_gain_r);
        reciever_gain_dB = 10 * log10(total_gain);
    end

end




% an example for running the loop_gain_function in the command line:
% loop_gain_function(number, diameters, power,recievers, transmitters, k,lambda)
% lg = loop_gain_function([2,3], [30,40], [1000,9000],[0,1], [1,0], .6,.1)

