# FPGA function generator
Our functino generator has following functions:
1. Ability to generate 3 different waveforms
    - sawtooth
    - triangle
    - square

2. Ability to change signal frequency in steps of 1 kHz, 10 kHz and 100 kHz

The output is routed to Pmod headers and converted to analog voltages using external DAC.

## Block diagram
![Block diagram](images/block_diagram.jpg)