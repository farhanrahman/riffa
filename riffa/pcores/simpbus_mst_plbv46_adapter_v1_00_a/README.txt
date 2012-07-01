Adapter core for connecting the SIMPBUS interface to the PLB v4.6 system bus as
a master.


Configuration parameters:
(defaults are specifed but may be changed accordingly)

Xilinx PLB bus v4.6 required parameters.
	PARAMETER C_FAMILY = virtex5
	PARAMETER C_MPLB_AWIDTH = 32
	PARAMETER C_MPLB_DWIDTH = 128
	PARAMETER C_MPLB_NATIVE_DWIDTH = 32
	PARAMETER C_MPLB_P2P = 0
	PARAMETER C_MPLB_SMALLEST_SLAVE = 32
	PARAMETER C_MPLB_CLK_PERIOD_PS = 10000


Ports:


Buses:

Interface to the PLB as a master.
	BUS_INTERFACE BUS = MPLB

Corresponding SIMPBUS interface (as a master).
	BUS_INTERFACE BUS = SIMPBUS


Usage:

Attach to the PLB bus. Provides a SIMPBUS interface on the other end. The 
SIMPBUS interface is driven using the system clock (same as the PLB clock).

