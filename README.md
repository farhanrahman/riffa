[RIFFA](https://sites.google.com/a/eng.ucsd.edu/matt-jacobsen/riffa) (Reusable Integration Framework for FPGA Accelerators) is a framework developed by [Matt Jacobsen](https://sites.google.com/a/eng.ucsd.edu/matt-jacobsen/). It connects IP cores on an FPGA with user software running on a Linux computer. For detailed explanation about the framework please read the "RIFFA README" section of this file which is the contents of the README file taken from RIFFA 0.9.

This project has been developed on top of RIFFA version 0.9. It includes extra hardware which interfaces with a user's IP Core via handshaking signals. RIFFA 0.9 offers more control and low level access to the corresponding framework from the hardware side of the framework in the FPGA. However in this project I decided to abstract away and include a handshaking interface that a user can connect to as long as their cores maintain the handshake protocol. Please refer to the WIKI pages to find out how to interface with the core. You can have a look at the [test_core.vhdl](https://github.com/farhanrahman/riffa/blob/master/src/test_core.vhd) file which is an example of how a user's core can interface with this framework.

A small summary of what the interface does:

1. Uses the RIFFA 0.9 framework to communicate with the PC.
2. Once a start signal is sent to the interface, it will read the stored input data from the RAM and assign them to the inputs of the user's IP core.
3. During processing: write output data to the RAM every time data from the user's IP core is valid.
4. During processing: Handle multiple dma transfers back to the PC if RAM gets full. Implements double buffering (i.e. two RAM blocks) method for increased throughput.
5. Post processing: Handle completion of processing using RIFFA 0.9 framework.

RIFFA README
================
This is a distribution of the Reusable Integration Framework for FPGA 
Accelerators (RIFFA). The contents of this distribution are open source, 
licensed with the FreeBSD license. Please feel free to contact the author with
any feedback, fixes, or requests at mdjacobs@cs.ucsd.edu <Matt Jacobsen>.

The distribution contains an examples folder and a riffa folder. The examples
folder contains Xilinx base system designs for various boards. In these base
system designs, there is a custom IP core which contains HDL showing interaction
with the RIFFA framework. In the custom IP core directory, there is also a 
software directory that contains a software user application that works with
the IP core.

In the riffa directory, you'll find the IP cores that make up RIFFA. The driver
and user library can be found in the central_notifier IP core directory, under
the software subdirectory. Be sure to read the README.txt files in each 
directory for further details.

A getting started guide is available at http://cseweb.ucsd.edu/~mdjacobs.

