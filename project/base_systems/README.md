XPS project files for ml505 and ml506 boards
===========================================

I have tried to generate a bitstream from the files included in ml505 folder. The files included there were created from a fresh project in XPS. The synthesis of the design still doesn't work.

However the bitstream in ml506 (which was generated from the example code given from RIFFA) seems to work to the point of sending data to the FPGA. Receiving the DMA transfer still doesn't work.


Board being used to test:

Xilinx Universiy Program ml505

Update 9th Jul
=======================================

The problem as identified by Dr. Nachiket Kapre was that the board needed the bitstream to be loaded up on system boot. There would be a problem otherwise from the host side. Now the data can be transferred and received successfully via the PCIe bus
