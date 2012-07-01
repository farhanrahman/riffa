Adapter core for connecting the SIMPBUS interface to the PLB v4.6 system bus as
as slave.


Configuration parameters:
(defaults are specifed but may be changed accordingly)

Xilinx PLB bus v4.6 required parameters.
	PARAMETER C_BASEADDR = 0xffffffff
	PARAMETER C_HIGHADDR = 0x00000000
	PARAMETER C_SPLB_AWIDTH = 32
	PARAMETER C_SPLB_DWIDTH = 128
	PARAMETER C_SPLB_NUM_MASTERS = 8
	PARAMETER C_SPLB_MID_WIDTH = 3
	PARAMETER C_SPLB_NATIVE_DWIDTH = 32
	PARAMETER C_SPLB_P2P = 0
	PARAMETER C_SPLB_SUPPORT_BURSTS = 0
	PARAMETER C_SPLB_SMALLEST_MASTER = 32
	PARAMETER C_SPLB_CLK_PERIOD_PS = 10000
	PARAMETER C_INCLUDE_DPHASE_TIMER = 1
	PARAMETER C_FAMILY = virtex5


Ports:


Buses:

Interface to the PLB as a slave.
	BUS_INTERFACE BUS = SPLB

Corresponding SIMPBUS interface (as a slave).
	BUS_INTERFACE BUS = SIMPBUS


Usage:

Attach to the PLB bus. Provides a SIMPBUS interface on the other end. The 
SIMPBUS interface is driven using the system clock (same as the PLB clock).

