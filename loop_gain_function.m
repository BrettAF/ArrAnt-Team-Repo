function loop_gain = loop_gain_function(quantity,diameters,power,receivers,transmitters,k,lambda)
    % This function calculates loop gain.
    %
    % quantity: a vector of the quantity of each type of antenna
    % diameters: a vector of the diameters of each type of antenna
    % power: Transmitter power received as a vector
    % recievers: a Boolean vector with 1 for a reciever and 0 for a
    %   transmitter
    % transmitters: a Boolean vector with 1 for transmitters and 0 for
    %   recievers
    % k: efficiency of the antenna
    % lambda: wavelength as GHz/10cm
    
    % num_transmitters: A vector of the number of transmitters with 0 for
    %   the receivers
    num_transmitters = quantity.*transmitters;
    
    % num_recievers: A vector of the number of recievers in each style with
    %   0 for transmitters
    num_receivers = quantity.*receivers;
    
    % power_transmitters: Transmitter power recieved as a vector with 0 for
    %   recievers
    power_transmitters = power.*transmitters;
    
    % EIRP of the array
    EIRP = gain_all_transmitters(k,num_transmitters,diameters,lambda,power_transmitters);
    
    % array_gain_receiver : total gain of the recievers in the array
    array_gain_receiver = gain_all_receivers(k,num_receivers,diameters,lambda);

    % Loop Gain Equation
    % EIRP of the array = (number of transmitters)(power of transmitters) * (number of tramsitters)(gain of transmitters)
    % array_gain_receiver = number of recievers * gain of receivers
    % loop_gain = eirp of the array + gain of receivers;
    % loop_gain = EIRP + array_gain_receiver
    loop_gain = EIRP + array_gain_receiver;

    function eirp_array_dB = gain_all_transmitters(k,num_transmitters,diameters,lambda,power) % EIRP
        % Calculate transmitter gain for the array
        % This function calculates parabolic gain.
        % 
        % diameter: Diameter of the antennas, recieved as a vector
        % lambda: Wavelength of the signal
        % power: power to the arrays in watts, an array with 0 for recievers
        % k: effencency of the arrays

        % returns the parabolic array of one antenna of each style of the
        % radar array, returns an vector
        gain_transmitter = k * (pi * (diameters ./ lambda)).^2; 
        
        % returns the sum gain of all of the antennas of each style of the array
        %array_gain_transmitter = num_transmitters .* parabolic_gain;
        
        array_gain_transmitter = num_transmitters.^2.*power.*gain_transmitter;
        total_gain_transmitter=sum(array_gain_transmitter);
        eirp_array_dB = 10 * log10(total_gain_transmitter);
    end

    function receiver_gain_dB = gain_all_receivers(k,num_receivers,diameters,lambda) 
        % Calculate total reciever gain for the array
        % This function calculates parabolic gain.
        % diameter: Diameter of the antennas, recieved as a vector
        % lambda: Wavelength of the signal

        % returns the parabolic array of one antenna of each style of the
        % radar array, returns an vector
        gain_receiver = k * (pi * (diameters ./ lambda)).^2;
       
        % returns the gain of all of the antennas of each style of the array
        array_gain_receiver = num_receivers .* gain_receiver;
        total_gain_receiver=sum(array_gain_receiver);
        receiver_gain_dB = 10 * log10(total_gain_receiver);
    end

end


% an example for running the loop_gain_function in the command line:
% loop_gain_function(number, diameters, power,receivers, transmitters, k,lambda)
% lg = loop_gain_function([2,3], [30,40], [1000,9000],[0,1], [1,0], .6,.1)
