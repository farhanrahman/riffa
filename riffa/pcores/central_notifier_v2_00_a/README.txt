Provides an interface for IP cores to communicate with workstation software 
threads via interrupts and for software threads to communicate with IP cores via
signal pulses (i.e. doorbells). Supports a DMA transfer interface for both 
software and IP cores. Supports up to 16 independent communication channels 
between IP cores and software. Currently, this core works with and depends on 
the Xilinx cores:
	plbv46_pcie
	xps_central_dma


Configuration parameters:
(defaults are specifed but may be changed accordingly)

Address and data widths of the connected system bus (e.g. PLB or AXI).
	PARAMETER C_SIMPBUS_AWIDTH = 32
	PARAMETER C_SIMPBUS_DWIDTH = 32

Specify number of connected channels. This will make valid RIFFA channels 0-15
(depending on the value specified).
	PARAMETER C_NUM_CHANNELS = 1

If set to 1, it will make valid a slave SIMPBUS interface. This interface can be
connected to an IP core which can perform initialization using a SIMPBUS 
interface to access the system bus. Initialization will happen at system reset.
	PARAMETER C_INIT_BUS = 0

The system bus address for the Xilnx xps_central_dma core.
	PARAMETER C_DMA_BASE_ADDR = 0x00000000

The system bus address for the Xilinx plbv46_pcie core. Also, the size of the
IPIF2PCI BARs (assume all are configured to be the same size).
	PARAMETER C_PCIE_BASE_ADDR = 0x00000000
	PARAMETER C_PCIE_IPIF2PCI_LEN = 4194304


Ports:

System clock and system reset. Both must correspond to the SIMPBUS clock.
	PORT SYS_CLK
	PORT SYS_RST

The workstation-bound interrupt signal. It must be connected to the interrupt 
input signal on the Xilinx plbv46_pcie core.
	PORT INTR_PCI

The DMA complete interrupt signal. It must be connected to the Xilinx 
xps_central_dma core's outbound interrupt complete signal.
	PORT INTR_DMA

Initialization start and done signals. A connected IP core will receive an 
active high signal on INIT_START when it should begin initialization. When done,
the core should assert INIT_DONE (also active high) to signal completion.
	PORT INIT_START
	PORT INIT_DONE


Buses:

Initialization core bus. Follows the semantics of SIMPBUS.
	BUS_INTERFACE BUS = SIMPBUS_INIT

Connections as slave and master to the system bus.
	BUS_INTERFACE BUS = SIMPBUS_SLV
	BUS_INTERFACE BUS = SIMPBUS_MST

RIFFA channels. Connect to IP cores that need to interact with RIFFA on PC.
	BUS_INTERFACE BUS = CHANNEL_00
	...
	BUS_INTERFACE BUS = CHANNEL_15


Usage:

Instantiate a Xilinx plbv46_pcie (PCIe Bridge and Endpoint), a xps_central_dma 
(DMA controller), and system bus (e.g. PLB or AXI). Instantiate a 
central_notifier and connect all to the system bus. For system bus independence,
use the simpbus_* adapter cores to convert between system bus specific
signals and a SIMPBUS interface.

All the parameters must be assigned values. All the ports must be connected as
described. The SIMPBUS_INIT is optional. Both the SIMPBUS_MST and SIMPBUS_SLV
must be connected to the system bus (again through some adapter core). Then 
connect your IP cores to (RIFFA) CHANNEL_* buses as needed.

Follow the configuration setup guide for setting parameters on this core and the
plbv46_pcie and xps_central_dma cores.

For SIMPBUS bus usage and RIFFA CHANNEL bus usage, see the accompanying 
documentation.


