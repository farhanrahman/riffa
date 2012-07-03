RIFFA Explanation
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

