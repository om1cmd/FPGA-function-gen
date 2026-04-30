# FPGA function generator
This is a project for BPC-DE1 digital electronics course on BUT FEEC.
### Brief project summary
This project is a function generator implemented on an Nexys A7 50T FPGA development board. It has following functions:
1. #### Ability to generate 4 different waveforms
    - Square
    - Sawtooth
    - Triangular
    - Sinusoidal

2. #### Ability to generate signals of 4 different frequencies.
    - See *Problems* in the full description for more information.

3. #### Ability to select 4 different output amplitudes
    - Output amplitude is limited to 3.3 V and final amplitude control block can devide it by 2, 4 or 8 times, giving us 4 different amplitudes.

The output is routed to Pmod headers and converted to analog voltages using external R-2R ladder DAC.

## Use of AI
LLMs were used during work on this project mainly to help us troubleshoot issues. AI was not used to generate complete blocks, but rather as a tool to discover new possibilities of implementation. All of the generated code was reviewed by us and we only used it, if we understood it.

Only exception to this is a sinusoidal waveform generator who's code was taken from the internet and modified with a help from AI to fit into our project. More information can be found in the individual block description below.

## Block diagram
![Block diagram](images/block_diagram.png)

## [Function gen top](vivado_project/function_gen_top/function_gen_top.srcs/sources_1/new/function_gen_top.vhd)
#### **Inputs**
- **btnu**: top button
- **btnd**: bottom button
- **btnl**: left button
- **btnr**: right button
- **btnc**: center button (reset)
- **sw**: first 2 switches

#### **Outputs**
- **seg**: 7 bit long vector with data for individual 7 segment displays
- **anode**: 8 bit long vector with only one bit low at a time, selecting 1 seven segment display at a time.

### Description

First, all buttons, except btnc which is wired directly into reset of all blocks, are passed through a *debouncer* block.

Top and bottom buttons are then wired into *counter_sig_select*, which is a bidirectional 2 bit counter who's current value is used to select an output waveform type.

Left and right buttons are connected to a *counter_per_select* which is again a 2 bit bidirectional counter but this one holds information about currently selected period.

Current state of those counters is fed into *sig_name_encoder* which then outputs 56 bit long vector of data for *display_driver_direct_data* which displays it on all 8 available 7 segment displays, showing currently selected waveform type and signal frequency.

Four *clock_enable* blocks are used to generate 4 different frequencies and a multiplexer is used to select between them. This enable signal (sig_en) is then fed into all four signal generator blocks. Then another multiplexor selects an output signal that is passed into *ampl_ch* block that can divide the data by 2, 4, 8 or just pass straight through unchanged signal. This way we can select 4 different output amplitudes. In analog voltages those are 3.3 V, 1.65 V, 0.83 V, 0.41 V.

### Problems
This design by far not perfect. It's biggest problem is that each signal generator block takes a different amount of clock cycles to complete one period. For example a square signal changes state each clock cycle (when enable is high), taking 2 clock cycles to complete a period. But a triangle generator takes 256 cyckles to count up and another 256 cycles to count down, meaning it is 256 times slower than a square generator.

We realized that this is a problem only after we started testing with hardware and we couldn't fix this in time. We tried slowing down *gen_sqr* by using an internal 8 bit counter, but for some reason our implementation did not work. Since we didn't have any more time we decided to leave this issue in. Current *clock_enable* values are set so that triangular wave (the slowest one) runs at the correct frequencies of 1 kHz, 10 kHz, 100 kHz and 200 kHz. All other blocks will run on different frequencies and the displayed frequency it therefore invalid for them.

### Resource usage
|Type|Used|
|---|---|
|LUTs|112|
|FFs|179|

## New components
### 1. [Bidirectional counter](vivado_project/function_gen_top/function_gen_top.srcs/sources_1/new/bidir_counter.vhd)
Bidirectional counter is a synchronous counter with configurable length.

#### **Generics**
- **G_BITS**: counter length in bits

#### **Inputs**
- **clk**: 100 MHz clock
- **up**: Count up if high
- **down**: Count down if high
- **rst**: Reset to zero if high
- **en**: Enable

#### **Outputs**
- **cnt**: Current ounter value

#### **Simulation**
![bidir_counter_sim](images/simulations/bidir_counter.png)

### 2. [Multiplexer](vivado_project/function_gen_top/function_gen_top.srcs/sources_1/new/mux.vhd)
Multiplexer is just that. A simple 4 to 1 multiplexer. It takes in an input vector that selects which input is routed to its output.

#### **Generics**
- **G_LENGTH**: Selects the length of vectors that will be multiplexed

#### **Inputs**
- **a**: First input
- **b**: Second input
- **c**: Third input
- **d**: Fourth input
- **sel**: 2 bit control signal

#### **Outputs**
- **output**: Mux output

#### **Simulation**
![mux_sim](images/simulations/mux.png)

### 3. [sig_name_encoder](vivado_project/function_gen_top/function_gen_top.srcs/sources_1/new/sig_name_encoder.vhd)
This block generates a 56 bit long vector with data for 7 segment displays. Each output bit coresponds to one segment of 8 available 7 segment displays. It looks at current selected signal and period and outputs the name of the selected signal and selected period to be displayed by display_driver_direct_data.

#### **Inputs**
- **cnt_sig**: Data from signal select counter
- **cnt_per**: Data from period select counter

#### **Outputs**
- **data**: 56 bit output vector

#### **Simulation**
![sig_name_encoder_sim](images/simulations/sig_name_encoder.png)

### 4. [display_driver_direct_data](vivado_project/function_gen_top/function_gen_top.srcs/sources_1/new/display_driver_direct_data.vhd)
This is a display driver block that works on a similar principle as display_driver writen on computer excercises. It was modified to take a 56 bit long input vector where each bit coresponds to 1 segment of all 8 seven segment displays. This allows us light up arbitrary segments, which is useful, because we need to display a lot of different letters that are not available in the original display_driver.

#### **Inputs**
- **clk**: 100 MHz clock
- **rst**: Active high reset
- **data**: 56 bit long input vector

#### **Outputs**
- **seg**: 7 bit long vector with data for individual 7 segment displays
- **anode**: 8 bit long vector with only one bit low at a time, selecting 1 seven segment display at a time

![display_driver_direct_data_sim](images/simulations/display_driver_direct_data.png)

### 5. [gen_sqr](vivado_project/function_gen_top/function_gen_top.srcs/sources_1/new/gen_sqr.vhd)
This block generates a square wave. It alternates between 2 states, all zeros and all ones.

#### **Inputs**
- **clk**: 100 MHz clock
- **rst**: Active high reset
- **en**: Active high enable

#### **Outputs**
- **dac_out**: 8 bit long output vector for DA subsequent conversion

![gen_sqr_sim](images/simulations/gen_sqr.png)
Simulation does not show an analog waveform, because vivado would just connect individual points, making it look like a triangular waveform instead of a square one.

### 6. [gen_tri](vivado_project/function_gen_top/function_gen_top.srcs/sources_1/new/gen_tri.vhd)
This block generates a triangular wave. It has an internal bidirectional 8 bit counter that starts counting up and once it reaches 255 direction flips and it starts counting down. At 0 it flips again.

#### **Inputs**
- **clk**: 100 MHz clock
- **rst**: Active high reset
- **en**: Active high enable

#### **Outputs**
- **dac_out**: 8 bit long output vector for DA subsequent conversion

![gen_tri_sim](images/simulations/gen_tri.png)

### 7. [gen_saw](vivado_project/function_gen_top/function_gen_top.srcs/sources_1/imports/modules/counter.vhd)
This is not a new block, but we wanted to have all waveforms simulated. Gen_saw is a simple up counter.

#### **Inputs**
- **clk**: 100 MHz clock
- **rst**: Active high reset
- **en**: Active high enable

#### **Outputs**
- **dac_out**: 8 bit long output vector for subsequent  DA conversion

![gen_saw_sim](images/simulations/gen_saw.png)

### 8. [gen_sin](vivado_project/function_gen_top/function_gen_top.srcs/sources_1/new/gen_sin.vhd)
This block generates a sinusoidal wave. This is the only code that was not written by us, because we didn't really know how to approach this. So instead we found [this code](https://surf-vhdl.com/how-to-generate-sine-samples-in-vhdl/) and modified it slightly to work with out setup. AI was used to help with this task.

#### **Inputs**
- **clk**: 100 MHz clock
- **rst**: Active high reset
- **en**: Active high enable

#### **Outputs**
- **dac_out**: 8 bit long output vector for DA subsequent conversion

![gen_sin_sim](images/simulations/gen_sin.png)

### 9. [ampl_ch](vivado_project/function_gen_top/function_gen_top.srcs/sources_1/new/ampl_ch.vhd)
This block allows for changing output amplitude. It simply divides the 8 bit output signal by bitshifting it to the right by 1, 2 or 3 bits based on a current value comming from switches on the board.

#### **Inputs**
- **sw**: 2 bit vector, current value on switches
- **data_in**: 8 bit vector, input data to be devided

#### **Outputs**
- **data_out**: 8 bit vector, devided data

![ampl_ch](images/simulations/ampl_ch.png)
It is not immediately obvious, since vivado shows both waveforms as having the same amplitude, but the top waveform is devided by 2. This can be verified by looking at current value at the cursor.