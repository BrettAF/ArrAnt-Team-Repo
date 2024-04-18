# Loop Gain Calculation Example

## Inputs
- `number`: [2, 3] (quantity of each antenna type)
- `diameters`: [30, 40] (diameters of each antenna type in m)
- `power`: [1000, 9000] (transmitter power in watts)
- `receivers`: [0, 1] (boolean vector, 0 for transmitter, 1 for receiver)
- `transmitters`: [1, 0] (boolean vector, 1 for transmitter, 0 for receiver)
- `k`: 0.6 (antenna efficiency)
- `lambda`: 0.1 (wavelength in m)

## 1. Separating Transmitter and Receiver Information
- `Num_transmitters (N)`: [2, 0]
- `Num_receivers (M)`: [0, 3]
- `power_transmitters`: [1000, 0]

## 2. Calculations within `gain_all_transmitters`
- Parabolic gain for each antenna:
  - Antenna 1: 0.6 * (pi * (30 / 0.1))^2 ≈ 532,959
  - Antenna 2: (transmitter power is 0, so gain doesn't matter here)
- Single transmitter gain: ≈ 532,959
- EIRP of the array: ≈ 2,131,836,000 (dB: ≈ 93.2875 dB)

## 3. Calculations within `gain_all_receivers`
- Parabolic gain for each antenna:
  - Antenna 1: (doesn't matter here since the number of receivers is 0)
  - Antenna 2: 0.6 * (pi * (40 / 0.1))^2 ≈ 947,482
- Single receiver gain: ≈ 947,482
- Total array receiver gain: ≈ 2,842,446 (dB: ≈ 64.5369 dB)

## 4. Loop Gain Calculation
- Loop Gain: 93.2875 dB (EIRP) + 64.5369 dB (Receiver Gain) = 157.8245 dB
