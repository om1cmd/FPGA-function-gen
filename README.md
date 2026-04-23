# FPGA function generator
### Our function generator has following functions:
1. #### Ability to generate 4 different waveforms
    - sawtooth
    - triangle
    - square
    - sin

2. #### Ability to generate signals of 4 different frequencies.
    - 1 kHz
    - 10 kHz
    - 100 kHz
    - 1 MHz

3. #### Push buttons on Nexys A7 50T board are used to control the generator:
    - Center button is wired to reset
    - Left and right buttons change between available frequencies
    - Up and down buttons change between available signals

The output is routed to Pmod headers and converted to analog voltages using external R-2R ladder DAC.

## Block diagram
![Block diagram](images/block_diagram.png)
