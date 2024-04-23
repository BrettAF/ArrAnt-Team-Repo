# Loop Gain Function

## Description
The `loop_gain_function` is a MATLAB script used to calculate the loop gain of an antenna array. Finding the loop gain is important as it is the performance metric used in the cost vs performance optimization. It evaluates the total EIRP and gain of the array, including both transmitters and receivers, considering various parameters such as quantity, diameters, power, efficiency, and wavelength.

## Usage
```matlab
function loop_gain = loop_gain_function(quantity,diameters,power,receivers,transmitters,k,lambda)
```

## Inputs
- `quantity`: A vector indicating the quantity of each type of antenna.
- `diameters`: A vector specifying the diameters of each type of antenna.
- `power`: Transmitter power received as a vector.
- `receivers`: A Boolean vector with 1 for a receiver and 0 for a transmitter.
- `transmitters`: A Boolean vector with 1 for transmitters and 0 for receivers.
- `k`: Efficiency of the antenna.
- `lambda`: Wavelength as GHz/10cm.

## Outputs
- `loop_gain`: The loop gain of the antenna array.

## Internal Functions

### `gain_all_transmitters`
This function calculates the total gain of all transmitters in the array.

```matlab
function eirp_array_dB = gain_all_transmitters(k,num_transmitters,diameters,lambda,power)
```

#### Inputs
- `k`: Efficiency of the antenna.
- `num_transmitters`: A vector indicating the number of transmitters for each style.
- `diameters`: A vector specifying the diameters of each type of antenna.
- `lambda`: Wavelength of the signal.
- `power`: Power to the arrays in watts, with 0 for receivers.

#### Output
- `eirp_array_dB`: The total EIRP (Effective Isotropic Radiated Power) of all transmitters in dB, found using both the power of the transmitters and gain of the transmitters in the array.

### `gain_all_recievers`
This function calculates the total gain of all receivers in the array.

```matlab
function receiver_gain_dB = gain_all_receivers(k,num_receivers,diameters,lambda)
```

#### Inputs
- `k`: Efficiency of the antenna.
- `num_receivers`: A vector indicating the number of receivers for each style.
- `diameters`: A vector specifying the diameters of each type of antenna.
- `lambda`: Wavelength of the signal.

#### Output
- `receiver_gain_dB`: The total gain of all receivers in dB.
```

