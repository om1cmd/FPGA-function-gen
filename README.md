# FPGA function generator
### Our function generator has following functions:
1. #### Ability to generate 4 different waveforms
    - sawtooth
    - triangle
    - square
    - sin

2. #### Ability to generate signals of 4 different frequencies.

3. #### Ability to select output amplitude

3. #### Push buttons on Nexys A7 50T board are used to control the generator:
    - Center button is wired to reset
    - Left and right buttons change between available frequencies
    - Up and down buttons change between available signals

The output is routed to Pmod headers and converted to analog voltages using external R-2R ladder DAC.

## Block diagram
![Block diagram](images/block_diagram.png)

## New components
### Bidirectional counter
Bidirectional counter is a synchronous counter with configurable length.

#### Generics
- G_BITS: counter length in bits

#### Inputs
- clk: 100 MHz clock
- up: Count up if high
- down: Count down if high
- rst: Reset to zero if high
- en: Enable

#### Outputs
- cnt: Counter value

#### Simulation
![bidir_counter_sim](images/simulations/bidir_counter.png)