Example IP core to use RIFFA channel. This core connects to a single RIFFA 
channel and a XIL_BRAM bus (i.e. BRAM core). It shows a simple example of how
a core can interact with RIFFA and what the corresponding PC would look like.


Configuration parameters:
(defaults are specifed but may be changed accordingly)

Size of the system bus address.
	PARAMETER C_SIMPBUS_AWIDTH = 32

System bus address of the connected BRAM core.
	PARAMETER C_BRAM_ADDR = 0x00000000


Ports:

System clock and reset. Be sure this is the same as what is used by the system
bus and central_notifier.
	PORT SYS_CLK
	PORT SYS_RST


Buses:

Interface to a RIFFA channel on the central_notifier.
	BUS_INTERFACE BUS = CHANNEL, BUS_STD = RIFFA_CHANNEL_BUS

Interface to a BRAM memory module.
	BUS_INTERFACE BUS = BRAMPORT, BUS_STD = XIL_BRAM


Usage:

Connect the CHANNEL bus to the central_notifier and the BRAMPORT bus to a Xilinx
BRAM core (that is also connected to the system bus). Then run the corresponding
C application in the sw directory to interact with this IP core.
