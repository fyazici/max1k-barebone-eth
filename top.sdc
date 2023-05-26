## Generated SDC file "top.sdc"

## Copyright (C) 2019  Intel Corporation. All rights reserved.
## Your use of Intel Corporation's design tools, logic functions 
## and other software and tools, and any partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Intel Program License 
## Subscription Agreement, the Intel Quartus Prime License Agreement,
## the Intel FPGA IP License Agreement, or other applicable license
## agreement, including, without limitation, that your use is for
## the sole purpose of programming logic devices manufactured by
## Intel and sold by Intel or its authorized distributors.  Please
## refer to the applicable agreement for further details, at
## https://fpgasoftware.intel.com/eula.


## VENDOR  "Altera"
## PROGRAM "Quartus Prime"
## VERSION "Version 19.1.0 Build 670 09/22/2019 Patches 0.02std,0.09std SJ Lite Edition"

## DATE    "Tue Mar 02 02:38:15 2021"

##
## DEVICE  "10M08SAU169C8GES"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {CLK12M} -period 83.333 -waveform { 0.000 41.666 } [get_ports {CLK12M}]


#**************************************************************
# Create Generated Clock
#**************************************************************

create_generated_clock -name {ethclk_inst|altpll_component|auto_generated|pll1|clk[0]} -source [get_pins {ethclk_inst|altpll_component|auto_generated|pll1|inclk[0]}] -duty_cycle 50/1 -multiply_by 25 -divide_by 12 -master_clock {CLK12M} [get_pins {ethclk_inst|altpll_component|auto_generated|pll1|clk[0]}] 
create_generated_clock -name {ethclk_inst|altpll_component|auto_generated|pll1|clk[1]} -source [get_pins {ethclk_inst|altpll_component|auto_generated|pll1|inclk[0]}] -duty_cycle 50/1 -multiply_by 125 -divide_by 12 -master_clock {CLK12M} [get_pins {ethclk_inst|altpll_component|auto_generated|pll1|clk[1]}] 


#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************

set_clock_uncertainty -rise_from [get_clocks {ethclk_inst|altpll_component|auto_generated|pll1|clk[1]}] -rise_to [get_clocks {ethclk_inst|altpll_component|auto_generated|pll1|clk[1]}]  0.070  
set_clock_uncertainty -rise_from [get_clocks {ethclk_inst|altpll_component|auto_generated|pll1|clk[1]}] -fall_to [get_clocks {ethclk_inst|altpll_component|auto_generated|pll1|clk[1]}]  0.070  
set_clock_uncertainty -fall_from [get_clocks {ethclk_inst|altpll_component|auto_generated|pll1|clk[1]}] -rise_to [get_clocks {ethclk_inst|altpll_component|auto_generated|pll1|clk[1]}]  0.070  
set_clock_uncertainty -fall_from [get_clocks {ethclk_inst|altpll_component|auto_generated|pll1|clk[1]}] -fall_to [get_clocks {ethclk_inst|altpll_component|auto_generated|pll1|clk[1]}]  0.070  
set_clock_uncertainty -rise_from [get_clocks {ethclk_inst|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {ethclk_inst|altpll_component|auto_generated|pll1|clk[1]}]  0.070  
set_clock_uncertainty -rise_from [get_clocks {ethclk_inst|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {ethclk_inst|altpll_component|auto_generated|pll1|clk[1]}]  0.070  
set_clock_uncertainty -rise_from [get_clocks {ethclk_inst|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {ethclk_inst|altpll_component|auto_generated|pll1|clk[0]}]  0.070  
set_clock_uncertainty -rise_from [get_clocks {ethclk_inst|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {ethclk_inst|altpll_component|auto_generated|pll1|clk[0]}]  0.070  
set_clock_uncertainty -fall_from [get_clocks {ethclk_inst|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {ethclk_inst|altpll_component|auto_generated|pll1|clk[1]}]  0.070  
set_clock_uncertainty -fall_from [get_clocks {ethclk_inst|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {ethclk_inst|altpll_component|auto_generated|pll1|clk[1]}]  0.070  
set_clock_uncertainty -fall_from [get_clocks {ethclk_inst|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {ethclk_inst|altpll_component|auto_generated|pll1|clk[0]}]  0.070  
set_clock_uncertainty -fall_from [get_clocks {ethclk_inst|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {ethclk_inst|altpll_component|auto_generated|pll1|clk[0]}]  0.070  


#**************************************************************
# Set Input Delay
#**************************************************************



#**************************************************************
# Set Output Delay
#**************************************************************



#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************



#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************

set_max_delay -from [get_clocks {ethclk_inst|altpll_component|auto_generated|pll1|clk[1]}] -to [get_ports {PIO[0] PIO[1]}] 0.000


#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

