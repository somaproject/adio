Digital output
--------------------

Simple mode (version 0.8):
----------------------------
Right now we have an exceptionally simple interface. 

0x30 : Set state
data[0] : output mask[31:16]
data[1] : output mask[15:0]
data[2] : output set [31:16]
data[3] : output set [15:0]

This is the simplest of all state variables. There are two 
thirty-two-bit registers, a state set and a mask.

once per ecycle the output state is read, and then
pushed out to the real output

0x31 : get state 
