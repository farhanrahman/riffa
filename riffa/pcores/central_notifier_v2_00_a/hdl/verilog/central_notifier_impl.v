//----------------------------------------------------------------------------
//	Copyright (c) 2012, Matthew Jacobsen
//	All rights reserved.
//	
//	Redistribution and use in source and binary forms, with or without
//	modification, are permitted provided that the following conditions are met: 
//	
//	1. Redistributions of source code must retain the above copyright notice, this
//	   list of conditions and the following disclaimer. 
//	2. Redistributions in binary form must reproduce the above copyright notice,
//	   this list of conditions and the following disclaimer in the documentation
//	   and/or other materials provided with the distribution. 
//	
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
//	ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
//	The views and conclusions contained in the software and documentation are those
//	of the authors and should not be interpreted as representing official policies, 
//	either expressed or implied, of the FreeBSD Project.
//----------------------------------------------------------------------------
//----------------------------------------------------------------------------
// Filename:			central_notifier_impl.v
// Version:				1.00.a
// Verilog Standard:	Verilog-2001
// Description:			Instantiates and connects interrupt_queue, dma_queue,
//						reg_handler, and initializer cores.
// History:				@mattj: Initial pre-release. Version 0.9.
//-----------------------------------------------------------------------------

module central_notifier_impl
(
	SYS_CLK,
	SYS_RST,
	INTR_PCI,
	INTR_DMA,
	INIT_START,
	INIT_DONE,
	SIMPBUS_INIT_ADDR,
	SIMPBUS_INIT_WDATA,
	SIMPBUS_INIT_RDATA,
	SIMPBUS_INIT_BE,
	SIMPBUS_INIT_RNW,
	SIMPBUS_INIT_START,
	SIMPBUS_INIT_DONE,
	SIMPBUS_INIT_ERR,
	SIMPBUS_MST_ADDR,
	SIMPBUS_MST_WDATA,
	SIMPBUS_MST_RDATA,
	SIMPBUS_MST_BE,
	SIMPBUS_MST_RNW,
	SIMPBUS_MST_START,
	SIMPBUS_MST_DONE,
	SIMPBUS_MST_ERR,
	SIMPBUS_SLV_ADDR,
	SIMPBUS_SLV_WDATA,
	SIMPBUS_SLV_RDATA,
	SIMPBUS_SLV_BE,
	SIMPBUS_SLV_RNW,
	SIMPBUS_SLV_START,
	SIMPBUS_SLV_DONE,
	SIMPBUS_SLV_ERR,
	CHANNEL,
	INTERRUPT,
	INTERRUPT_ERR,
	INTERRUPT_ACK,
	DOORBELL,
	DOORBELL_ERR,
	DOORBELL_LEN,
	DOORBELL_ARG,
	DMA_REQ,
	DMA_REQ_ACK,
	DMA_SRC,
	DMA_DST,
	DMA_LEN,
	DMA_SIG,
	DMA_DONE,
	DMA_ERR,
	BUF_REQ,
	BUF_REQ_ACK,
	BUF_REQ_ADDR,
	BUF_REQ_SIZE,
	BUF_REQ_RDY,
	BUF_REQ_ERR,
	BUF_REQD,
	BUF_REQD_ADDR,
	BUF_REQD_SIZE,
	BUF_REQD_RDY,
	BUF_REQD_ERR
);

parameter C_ARCH = "V5";
parameter C_SIMPBUS_AWIDTH = 32;
parameter C_SIMPBUS_DWIDTH = 32;
parameter C_NUM_CHANNELS = 1;
parameter C_INIT_BUS = 1;
parameter C_DMA_BASE_ADDR = 'h0;
parameter C_PCIE_BASE_ADDR = 'h0;
parameter C_PCIE_IPIF2PCI_LEN = 1024;

input								SYS_CLK;
input								SYS_RST;
output								INTR_PCI;
input								INTR_DMA;
output								INIT_START;
input								INIT_DONE;
input	[C_SIMPBUS_AWIDTH-1:0]		SIMPBUS_INIT_ADDR;
input	[C_SIMPBUS_DWIDTH-1:0]		SIMPBUS_INIT_WDATA;
output	[C_SIMPBUS_DWIDTH-1:0]		SIMPBUS_INIT_RDATA;
input	[C_SIMPBUS_DWIDTH/8-1:0]	SIMPBUS_INIT_BE;
input								SIMPBUS_INIT_RNW;
input								SIMPBUS_INIT_START;
output								SIMPBUS_INIT_DONE;
output								SIMPBUS_INIT_ERR;
output	[C_SIMPBUS_AWIDTH-1:0]		SIMPBUS_MST_ADDR;
output	[C_SIMPBUS_DWIDTH-1:0]		SIMPBUS_MST_WDATA;
input	[C_SIMPBUS_DWIDTH-1:0]		SIMPBUS_MST_RDATA;
output	[C_SIMPBUS_DWIDTH/8-1:0]	SIMPBUS_MST_BE;
output								SIMPBUS_MST_RNW;
output								SIMPBUS_MST_START;
input								SIMPBUS_MST_DONE;
input								SIMPBUS_MST_ERR;
input	[C_SIMPBUS_AWIDTH-1:0]		SIMPBUS_SLV_ADDR;
input	[C_SIMPBUS_DWIDTH-1:0]		SIMPBUS_SLV_WDATA;
output	[C_SIMPBUS_DWIDTH-1:0]		SIMPBUS_SLV_RDATA;
input	[C_SIMPBUS_DWIDTH/8-1:0]	SIMPBUS_SLV_BE;
input								SIMPBUS_SLV_RNW;
input								SIMPBUS_SLV_START;
output								SIMPBUS_SLV_DONE;
output								SIMPBUS_SLV_ERR;
output	[3:0]						CHANNEL;
input								INTERRUPT;
input								INTERRUPT_ERR;
output								INTERRUPT_ACK;
output								DOORBELL;
output								DOORBELL_ERR;
output	[C_SIMPBUS_AWIDTH-1:0]		DOORBELL_LEN;
output	[31:0]						DOORBELL_ARG;
input								DMA_REQ;
output								DMA_REQ_ACK;
input	[C_SIMPBUS_AWIDTH-1:0]		DMA_SRC;
input	[C_SIMPBUS_AWIDTH-1:0]		DMA_DST;
input	[C_SIMPBUS_AWIDTH-1:0]		DMA_LEN;
input								DMA_SIG;
output								DMA_DONE;
output								DMA_ERR;
input								BUF_REQ;
output								BUF_REQ_ACK;
output	[C_SIMPBUS_AWIDTH-1:0]		BUF_REQ_ADDR;
output	[4:0]						BUF_REQ_SIZE;
output								BUF_REQ_RDY;
output								BUF_REQ_ERR;
output								BUF_REQD;
input	[C_SIMPBUS_AWIDTH-1:0]		BUF_REQD_ADDR;
input	[4:0]						BUF_REQD_SIZE;
input								BUF_REQD_RDY;
input								BUF_REQD_ERR;

wire								wIntrClear;
wire								wIntrReq;
wire	[4:0]						wQChannel;
wire								wQSignal;
wire	[31:0]						wQLen;
wire								wQDone;
wire								wQDoneAck;
wire								wQErr;
wire								wQFifoWEN;
wire	[31:0]						wQFifoData;
wire	[C_SIMPBUS_AWIDTH-1:0]		wProxyAddr;
wire	[C_SIMPBUS_DWIDTH-1:0]		wProxyWData;
wire	[C_SIMPBUS_DWIDTH-1:0]		wProxyRData;
wire	[C_SIMPBUS_DWIDTH/8-1:0]	wProxyBE;
wire								wProxyRNW;
wire								wProxyStart;
wire								wProxyDone;
wire								wProxyErr;
wire								wRegInit;
wire								wRegInitDone;
wire	[C_SIMPBUS_DWIDTH-1:0]		wRegInitData;
wire	[0:2]						wRegInitNum;

// Handles queuing interrupts for transmission to the PCIe bridge.
// Also exports the interrupt reg that indicates which interrupts
// were triggered.
interrupt_queue interruptQueue (
	.CLK(SYS_CLK),
	.RST(SYS_RST),
	.INTR_IN(wIntrReq),
	.INTR_CLEAR(wIntrClear),
	.INTR_OUT(INTR_PCI)
);

// Handles queuing up DMA transfer requests and issuing them to the
// DMA Controller. Also signals DMA done/err and interrupt/doorbell
// after the DMA transfer completes (as necessary).
dma_queue #(C_ARCH, C_SIMPBUS_AWIDTH, C_SIMPBUS_DWIDTH, C_DMA_BASE_ADDR) dmaQueue (
	.SYS_CLK(SYS_CLK),
	.SYS_RST(SYS_RST),
	.INTR_DMA(INTR_DMA),
	.SIMPBUS_ADDR(SIMPBUS_MST_ADDR),
	.SIMPBUS_WDATA(SIMPBUS_MST_WDATA),
	.SIMPBUS_RDATA(SIMPBUS_MST_RDATA),
	.SIMPBUS_BE(SIMPBUS_MST_BE),
	.SIMPBUS_RNW(SIMPBUS_MST_RNW),
	.SIMPBUS_START(SIMPBUS_MST_START),
	.SIMPBUS_DONE(SIMPBUS_MST_DONE),
	.SIMPBUS_ERR(SIMPBUS_MST_ERR),
	.SIMPBUS_PROXY_ADDR(wProxyAddr),
	.SIMPBUS_PROXY_WDATA(wProxyWData),
	.SIMPBUS_PROXY_RDATA(wProxyRData),
	.SIMPBUS_PROXY_BE(wProxyBE),
	.SIMPBUS_PROXY_RNW(wProxyRNW),
	.SIMPBUS_PROXY_START(wProxyStart),
	.SIMPBUS_PROXY_DONE(wProxyDone),
	.SIMPBUS_PROXY_ERR(wProxyErr),
	.FIFO_WEN(wQFifoWEN),
	.FIFO_DATA(wQFifoData),
	.CHANNEL(wQChannel),
	.DONE(wQDone),
	.DONE_ACK(wQDoneAck),
	.SIGNAL(wQSignal),
	.LEN(wQLen),
	.ERR(wQErr)
);

// Handles bus accessible register reads/writes for DMA transfers,
// interrupts, and doorbells.
reg_handler #(C_ARCH, C_SIMPBUS_AWIDTH, C_SIMPBUS_DWIDTH, C_NUM_CHANNELS) regHandler (
	.SYS_CLK(SYS_CLK),
	.SYS_RST(SYS_RST),
	.INTR_REQ(wIntrReq),
	.INTR_CLEAR(wIntrClear),
	.REG_INIT(wRegInit),
	.REG_INIT_DONE(wRegInitDone),
	.REG_INIT_DATA(wRegInitData),
	.REG_INIT_NUM(wRegInitNum),
	.SIMPBUS_ADDR(SIMPBUS_SLV_ADDR),
	.SIMPBUS_WDATA(SIMPBUS_SLV_WDATA),
	.SIMPBUS_RDATA(SIMPBUS_SLV_RDATA),
	.SIMPBUS_BE(SIMPBUS_SLV_BE),
	.SIMPBUS_RNW(SIMPBUS_SLV_RNW),
	.SIMPBUS_START(SIMPBUS_SLV_START),
	.SIMPBUS_DONE(SIMPBUS_SLV_DONE),
	.SIMPBUS_ERR(SIMPBUS_SLV_ERR),
	.DMA_QUEUE_FIFO_WEN(wQFifoWEN),
	.DMA_QUEUE_FIFO_DATA(wQFifoData),
	.DMA_QUEUE_CHANNEL(wQChannel),
	.DMA_QUEUE_DONE(wQDone),
	.DMA_QUEUE_DONE_ACK(wQDoneAck),
	.DMA_QUEUE_SIGNAL(wQSignal),
	.DMA_QUEUE_LEN(wQLen),
	.DMA_QUEUE_ERR(wQErr),
	.CHANNEL(CHANNEL),
	.INTERRUPT(INTERRUPT),
	.INTERRUPT_ERR(INTERRUPT_ERR),
	.INTERRUPT_ACK(INTERRUPT_ACK),
	.DOORBELL(DOORBELL),
	.DOORBELL_ERR(DOORBELL_ERR),
	.DOORBELL_LEN(DOORBELL_LEN),
	.DOORBELL_ARG(DOORBELL_ARG),
	.DMA_REQ(DMA_REQ),
	.DMA_REQ_ACK(DMA_REQ_ACK),
	.DMA_SRC(DMA_SRC),
	.DMA_DST(DMA_DST),
	.DMA_LEN(DMA_LEN),
	.DMA_SIG(DMA_SIG),
	.DMA_DONE(DMA_DONE),
	.DMA_ERR(DMA_ERR),
	.BUF_REQ(BUF_REQ),
	.BUF_REQ_ACK(BUF_REQ_ACK),
	.BUF_REQ_ADDR(BUF_REQ_ADDR),
	.BUF_REQ_SIZE(BUF_REQ_SIZE),
	.BUF_REQ_RDY(BUF_REQ_RDY),
	.BUF_REQ_ERR(BUF_REQ_ERR),
	.BUF_REQD(BUF_REQD),
	.BUF_REQD_ADDR(BUF_REQD_ADDR),
	.BUF_REQD_SIZE(BUF_REQD_SIZE),
	.BUF_REQD_RDY(BUF_REQD_RDY),
	.BUF_REQD_ERR(BUF_REQD_ERR)
);

// Handles initializing the centeral_notifier.
initializer #(C_SIMPBUS_AWIDTH, C_SIMPBUS_DWIDTH, C_INIT_BUS, 
	C_PCIE_BASE_ADDR, C_PCIE_IPIF2PCI_LEN) initr (
	.SYS_CLK(SYS_CLK),
	.SYS_RST(SYS_RST),
	.EXT_INIT_START(INIT_START),
	.EXT_INIT_DONE(INIT_DONE),
	.REG_INIT(wRegInit),
	.REG_INIT_DONE(wRegInitDone),
	.REG_INIT_DATA(wRegInitData),
	.REG_INIT_NUM(wRegInitNum),
	.SIMPBUS_INIT_ADDR(SIMPBUS_INIT_ADDR),
	.SIMPBUS_INIT_WDATA(SIMPBUS_INIT_WDATA),
	.SIMPBUS_INIT_RDATA(SIMPBUS_INIT_RDATA),
	.SIMPBUS_INIT_BE(SIMPBUS_INIT_BE),
	.SIMPBUS_INIT_RNW(SIMPBUS_INIT_RNW),
	.SIMPBUS_INIT_START(SIMPBUS_INIT_START),
	.SIMPBUS_INIT_DONE(SIMPBUS_INIT_DONE),
	.SIMPBUS_INIT_ERR(SIMPBUS_INIT_ERR),
	.SIMPBUS_PROXY_ADDR(wProxyAddr),
	.SIMPBUS_PROXY_WDATA(wProxyWData),
	.SIMPBUS_PROXY_RDATA(wProxyRData),
	.SIMPBUS_PROXY_BE(wProxyBE),
	.SIMPBUS_PROXY_RNW(wProxyRNW),
	.SIMPBUS_PROXY_START(wProxyStart),
	.SIMPBUS_PROXY_DONE(wProxyDone),
	.SIMPBUS_PROXY_ERR(wProxyErr)
);

endmodule
