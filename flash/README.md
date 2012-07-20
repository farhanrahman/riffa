How to program your compact flash
=================================

* There are two ace files created in this directory. There is a folder called Untitled which includes the ace file created from the default example. Then there is the SimpleD directory which is contains the .ace file created that does a dma transfer from PC to FPGA and FPGA back to PC.

* The way to create these ace files is through Xilinx Impact tools (more detailed documentation will be included later).

* In order to program your compact flash you have to copy the contents inside one of these directories. For example if you want to program the board with the ace file in SimpleD then copy the contents inside SimpleD i.e the subdirectory SimpleD and xilinx.sys file onto your compact flash. Make sure its the only .sys file and the SimpleD folder name is not changed.

In summary your flash card should look like this:

SimpleD xilinx.sys

SimpleD folder should contain the ace file.

* Finally you have to configure your board so that it loads up from the flash drive. Look into the documentation of the board for more details.
