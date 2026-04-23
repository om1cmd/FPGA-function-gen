# FPGA function generator
Our function generator has following functions:
1. Ability to generate 4 different waveforms
    - sawtooth
    - triangle
    - square
    - sin

2. Ability to generate signals of 4 different frequencies.
    - 1 kHz
    - 10 kHz
    - 100 kHz
    - 1 MHz

The output is routed to Pmod headers and converted to analog voltages using external R-2R ladder DAC.

## Block diagram
![Block diagram](images/block_diagram.png)
