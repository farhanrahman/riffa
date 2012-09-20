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
// Filename:			reg_handler.v
// Version:				1.00.a
// Verilog Standard:	Verilog-2001
// Description:			Handles bus requests from the PC, RIFFA channel requests
//						from IP cores, and dma_queue completion signals. Main
//						logic for the central_notifier core.
// History:				@mattj: Initial pre-release. Version 0.9.
//-----------------------------------------------------------------------------

module reg_handler
(
	SYS_CLK,
	SYS_RST,
	INTR_REQ,
	INTR_CLEAR,
	REG_INIT,
	REG_INIT_DONE,
	REG_INIT_DATA,
	REG_INIT_NUM,
	SIMPBUS_ADDR,			// This will be a relative addr.
	SIMPBUS_WDATA,
	SIMPBUS_RDATA,
	SIMPBUS_BE,
	SIMPBUS_RNW,
	SIMPBUS_START,
	SIMPBUS_DONE,
	SIMPBUS_ERR,
	DMA_QUEUE_FIFO_WEN,
	DMA_QUEUE_FIFO_DATA,
	DMA_QUEUE_CHANNEL,
	DMA_QUEUE_DONE,
	DMA_QUEUE_DONE_ACK,
	DMA_QUEUE_SIGNAL,
	DMA_QUEUE_LEN,
	DMA_QUEUE_ERR,
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
parameter C_BUF_REQD_TIMEOUT = 32;

input								SYS_CLK;
input								SYS_RST;
output								INTR_REQ;
output								INTR_CLEAR;
output								REG_INIT;
input								REG_INIT_DONE;
output	[C_SIMPBUS_DWIDTH-1:0]		REG_INIT_DATA;
output	[2:0]						REG_INIT_NUM;
input	[C_SIMPBUS_AWIDTH-1:0]		SIMPBUS_ADDR;
input	[C_SIMPBUS_DWIDTH-1:0]		SIMPBUS_WDATA;
output	[C_SIMPBUS_DWIDTH-1:0]		SIMPBUS_RDATA;
input	[C_SIMPBUS_DWIDTH/8-1:0]	SIMPBUS_BE;
input								SIMPBUS_RNW;
input								SIMPBUS_START;
output								SIMPBUS_DONE;
output								SIMPBUS_ERR;
output								DMA_QUEUE_FIFO_WEN;
output	[31:0]						DMA_QUEUE_FIFO_DATA;
input	[4:0]						DMA_QUEUE_CHANNEL;
input								DMA_QUEUE_DONE;
output								DMA_QUEUE_DONE_ACK;
input								DMA_QUEUE_SIGNAL;
input	[31:0]						DMA_QUEUE_LEN;
input								DMA_QUEUE_ERR;
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

// ------------------------------------------------------
// The 8KB memory address to is mapped to 32 bit registers where each register 
// corresponds to a value for a channel. The first 1K registers are for the 
// PC->FPGA side of the channel. Each channel uses 8 registers and stores the 
// register values in backing BRAM until they can be passed to the IP core. The
// PC can only write one 32 bit word at a time. The the FPGA->PC side of the 
// channel is connected directly to the IP cores via ports/signal lines and 
// does not use the address space or BRAM storage. The last 1K registers in the
// 8KB address space are used for configuration.
// The address space is laid out as follows:
// 0x000 DMA_LEN	CHAN00					0x200 IPIF BAR 0 HW addr
// 0x004 DMA_SRC	CHAN00					0x204 IPIF BAR 1 HW addr
// 0x008 DMA_DST	CHAN00					0x208 IPIF BAR 2 HW addr
// 0x00C DMA_INFO	CHAN00					0x20C IPIF BAR 3 HW addr
// 0x010 ARG_0		CHAN00					0x210 IPIF BAR 4 HW addr
// 0x014 ARG_1		CHAN00					0x214 IPIF BAR 5 HW addr
// 0x018 BUF_INFO	CHAN00					0x218 [UNUSED]
// 0x01C INTR_INFO	CHAN00					...
// 0x020 DMA_LEN	CHAN01
// 0x024 DMA_SRC	CHAN01
// 0x028 DMA_DST	CHAN01
// 0x02C DMA_INFO	CHAN01
// 0x030 ARG_0		CHAN01
// 0x034 ARG_1		CHAN01
// 0x038 BUF_INFO	CHAN01
// 0x03C INTR_INFO	CHAN01
// ...										
// 0x1E0 DMA_LEN	CHAN15					
// 0x1E4 DMA_SRC	CHAN15
// 0x1E8 DMA_DST	CHAN15
// 0x1EC DMA_INFO	CHAN15
// 0x1F0 ARG_0		CHAN15
// 0x1F4 ARG_1		CHAN15					...
// 0x1F8 BUF_INFO	CHAN15					0x2F8 [UNUSED]
// 0x1FC INTR_INFO	CHAN15					0x2FC Interrupt vector
//
// Unless otherwise indicated, all values are interpreted in big-endian format.
//
// A write to the DMA_LEN register triggers a DMA transfer using the values 
// from the corresponding DMA_SRC and DMA_DST registers. Thus, the DMA_LEN 
// value should always be written to last. The DMA values are persisted between
// writes. So if no changes are required for the DMA_SRC and/or DMA_DST values,
// a single write to DMA_LEN will trigger another DMA transfer. Reads from the
// DMA_SRC, DMA_DST, and DMA_LEN registers will return their current values.
// DMA transfer requests are queued in a FIFO and processed by the dma_queue 
// module. The DMA_SRC and DMA_DST values are 32 bit addresses for the system 
// bus. The DMA_LEN value should be encoded as follows:
// { err (1 bit) | doorbell (1 bit) | transfer_bytes (30 bits) }
// The transfer_bytes value indicates how many bytes to transfer. If 
// transfer_bytes is non-zero, the doorbell bit indicates whether to signal the
// IP core on the channel _after_ the DMA completes. If transfer_bytes is zero, 
// no transfer is initiated. In this case the doorbell bit indicates whether to
// signal the IP core on the channel _immediately_. The error bit indicates a 
// software side error and is only used when the doorbell bit is set. 
//
// When a DMA transfer is complete, the PC will be notified of the completion
// and the DMA_INFO register will contain the status of the DMA transfer. A
// read from the DMA_INFO will return the encoded value:
// { err (1 bit) | doorbell'd (1 bit) | transfer_bytes (30 bits) }
// The err bit indicates an error in the DMA transfer. The transfer_bytes is 
// the number of bytes transferred (should be the same as the original amount
// specified). The doorbell'd bit indicates if the IP core on the channel was
// signaled after the transfer. 
// Writes to the DMA_INFO register will be ignored.
// 
// Writes to ARG registers are simply persisted. When a doorbell is initiated, 
// their values will be read out to the IP core in sequence. The IP core on the
// channel must be written to capture their values after each doorbell.
// Reads from the ARG registers will return their current values.
//
// Reads from the BUF_INFO register initiate a request for a new FPGA target
// buffer for DMA transfers. The IP core on the channel will receive a
// cooresponding request and must respond immediately with the buffer address
// and size. The response will be encoded as:
// { addr_shift (27 bits) | log2_size (5 bits) }
// The buffer size will always be a power of 2. Therefore, the actual size = 
// pow(2, log2_size). The buffer address = addr_shift<<5 (the bottom 5 bits are
// always 0). If the IP core on the channel does not respond immediately or 
// responds with an error, the entire value will be 0 (to indicate an error).
// Writes to BUF_INFO register are a response to the IP core's request for a PC
// target buffer for DMA transfers. The value is encoded as above (like with
// reads) and errors are signaled in the same way. The IP core can initiate a 
// PC target buffer request using the BUF_REQ port.
//
// The INTR_INFO register holds the interrupt status value corresponding to 
// when the IP core on the channel requests an interrupt. The value encodes:
// { err (1 bit) | need_buf (1 bit) | transfer_bytes (30 bits) }
// The err bit indicates an error on the FPGA side. The need_buf bit indicates 
// a request for a PC target buffer (initiated by a BUF_REQ assertion). The 
// transfer_bytes value is the number of bytes transferred and is always 0 if
// need_buf is asserted.
// Writes to the INTR_INFO register will be ignored.
//
// The IPIF BAR HW addr registers are written to when the PC determines what 
// PCIe hardware address to allocated to the PCIe mapped IPIF BAR regions. When
// written to the value will be used to (re)initialize the PCIe bridge. Reads
// fom these registers will return undefined values (as the values are not 
// persisted).
//
// The Interrupt vector indicates which channels are being "interrupted" on the
// PC. The vector is encoded as follows:
// { PC_sent_intr_15-0 (16 bits) | PC_recv_intr_15-0 (16 bits) }
// The left most 16 bits correspond to interrupts to read the DMA_INFO 
// registers, indicating a completion of a PC initiated DMA transfer. The right
// most 16 bits correspond to interrupts to read the INTR_INFO registers.

reg		[4:0]					rState=0;
reg		[31:0]					rIntrVect=0;
reg								rIntrClear=0;
reg								rRegInit=0;
reg		[2:0]					rRegInitNum=0;
reg		[7:0]					rBramAddr=0;
reg     						rBramWEN=0;
reg     [31:0]					rData=0;
reg								rFifoDmaQWEN=0;
reg								rFifoDmaInfoWEN=0;
reg								rFifoIntrWEN=0;
reg								rFifoDmaInfoREN=0;
reg								rFifoIntrREN=0;
reg								rBusDone=0;
reg								rDmaDoneAck=0;
reg								rFifoTurn=0;
reg		[3:0]					rChannel=0;
reg								rInterruptAck=0;
reg								rDoorbell=0;
reg								rDoorbellErr=0;
reg								rDmaReqAck=0;
reg								rDmaDone=0;
reg								rBufReqAck=0;
reg		[4:0]					rBufReqSize=0;
reg								rBufReqRdy=0;
reg								rBufReqErr=0;
reg								rBufReqd=0;
reg								rTmpSignal=0;
reg								rTmpErr=0;
reg		[3:0]					rTmpChannel=0;

wire	[31:0]					wBramDataOut;
wire	[35:0]					wFifoIntrDataOut;
wire	[35:0]					wFifoDmaInfoDataOut;
wire							wFifoIntrEmpty;
wire							wFifoDmaInfoEmpty;


assign INTR_REQ = (rIntrVect != 0);
assign INTR_CLEAR = rIntrClear;

assign REG_INIT = rRegInit;
assign REG_INIT_DATA = rData;
assign REG_INIT_NUM = rRegInitNum;

assign SIMPBUS_RDATA = rData;
assign SIMPBUS_DONE = rBusDone;
assign SIMPBUS_ERR = 0;

assign DMA_QUEUE_FIFO_WEN = rFifoDmaQWEN;
assign DMA_QUEUE_FIFO_DATA = rData;
assign DMA_QUEUE_DONE_ACK = rDmaDoneAck;

assign CHANNEL = rChannel;

assign INTERRUPT_ACK = rInterruptAck;

assign DOORBELL = rDoorbell;
assign DOORBELL_ERR = rDoorbellErr;
assign DOORBELL_LEN = rData;
assign DOORBELL_ARG = rData;

assign DMA_REQ_ACK = rDmaReqAck;
assign DMA_DONE = rDmaDone;
assign DMA_ERR = rTmpErr;

assign BUF_REQ_ACK = rBufReqAck;
assign BUF_REQ_ADDR = rData;
assign BUF_REQ_SIZE = rBufReqSize;
assign BUF_REQ_RDY = rBufReqRdy;
assign BUF_REQ_ERR = rBufReqErr;

assign BUF_REQD = rBufReqd;

// Block ram to store register values and FIFO for queuing interrupts & dma info msgs.
generate
	if (C_ARCH == "V5") begin: v5
		ramb_sp_32w256d regMem (
			.clka(SYS_CLK),
			.wea(rBramWEN),
			.addra(rBramAddr),
			.dina(rData),
			.douta(wBramDataOut)
		);
		fifo_ramd_36w32d interruptFifo (
			.clk(SYS_CLK),
			.rst(SYS_RST),
			.din({rChannel, rData}),
			.wr_en(rFifoIntrWEN),
			.rd_en(rFifoIntrREN),
			.dout(wFifoIntrDataOut),
			.full(),
			.empty(wFifoIntrEmpty)
		);
		fifo_ramd_36w32d dmaInfoFifo (
			.clk(SYS_CLK),
			.rst(SYS_RST),
			.din({rChannel, rData}),
			.wr_en(rFifoDmaInfoWEN),
			.rd_en(rFifoDmaInfoREN),
			.dout(wFifoDmaInfoDataOut),
			.full(),
			.empty(wFifoDmaInfoEmpty)
		);
	end
	else if (C_ARCH == "V6") begin: v6
		ramb_sp_32w256d_v6 regMem (
			.clka(SYS_CLK),
			.wea(rBramWEN),
			.addra(rBramAddr),
			.dina(rData),
			.douta(wBramDataOut)
		);
		fifo_ramd_36w32d_v6 interruptFifo (
			.clk(SYS_CLK),
			.rst(SYS_RST),
			.din({rChannel, rData}),
			.wr_en(rFifoIntrWEN),
			.rd_en(rFifoIntrREN),
			.dout(wFifoIntrDataOut),
			.full(),
			.empty(wFifoIntrEmpty)
		);
		fifo_ramd_36w32d_v6 dmaInfoFifo (
			.clk(SYS_CLK),
			.rst(SYS_RST),
			.din({rChannel, rData}),
			.wr_en(rFifoDmaInfoWEN),
			.rd_en(rFifoDmaInfoREN),
			.dout(wFifoDmaInfoDataOut),
			.full(),
			.empty(wFifoDmaInfoEmpty)
		);
	end
endgenerate

// State machine to service bus requests (PC channel requests) and
// directly connected IP core requests.
always @(posedge SYS_CLK or posedge SYS_RST) begin
	if (SYS_RST) begin
		rState <= 0;
		rIntrVect <= 0;
		rIntrClear <= 0;
		rRegInit <= 0;
		rRegInitNum <= 0;
		rData <= 0;
		rBramAddr <= 0;
		rBramWEN <= 0;
		rFifoDmaQWEN <= 0;
		rFifoDmaInfoWEN <= 0;
		rFifoIntrWEN <= 0;
		rFifoDmaInfoREN <= 0;
		rFifoIntrREN <= 0;
		rFifoTurn <= 0;
		rBusDone <= 0;
		rDmaDoneAck <= 0;
		rChannel <= 0;
		rInterruptAck <= 0;
		rDoorbell <= 0;
		rDoorbellErr <= 0;
		rDmaReqAck <= 0;
		rDmaDone <= 0;
		rBufReqAck <= 0;
		rBufReqSize <= 0;
		rBufReqRdy <= 0;
		rBufReqErr <= 0;
		rBufReqd <= 0;
		rTmpChannel <= 0;
		rTmpSignal <= 0;
		rTmpErr <= 0;
	end
	else begin		
		case (rState)
			5'd0: begin // Wait for some kind of request.
				if (SIMPBUS_START) begin // Bus request.
					if (SIMPBUS_ADDR == 'h2FC) begin // Interrupt vector
						if (SIMPBUS_RNW) begin
							rData <= rIntrVect;
						end
						else begin
							rIntrVect <= ((SIMPBUS_WDATA ^ rIntrVect) & rIntrVect); // Remove read interrupts
							rIntrClear <= 1;
						end
						rBusDone <= 1;
						rState <= 30;
					end
					else if (SIMPBUS_ADDR >= 'h200 && SIMPBUS_ADDR <= 'h214) begin // IPIF BAR HW addr
						if (SIMPBUS_RNW) begin 
							rData <= 0;
							rState <= 30;
						end
						else begin
							rRegInit <= 1;
							rData <= SIMPBUS_WDATA;
							rRegInitNum <= SIMPBUS_ADDR[4:2];
							rState <= 14; // Wait for REG_INIT_DONE
						end
						rBusDone <= 1;
					end
					else if (SIMPBUS_ADDR < 'h200) begin
						if (SIMPBUS_ADDR[4:0] == 'h0) begin // DMA_LEN
							if (SIMPBUS_RNW) begin 
								rBramAddr <= SIMPBUS_ADDR>>2;
								rState <= 15; // Return the read data
							end
							else begin
								rBramWEN <= 1;
								rBramAddr <= SIMPBUS_ADDR>>2;
								rData <= SIMPBUS_WDATA;
								rTmpErr <= SIMPBUS_WDATA[31];
								rTmpSignal <= SIMPBUS_WDATA[30];
								if (SIMPBUS_WDATA[29:0]) begin // Has length
									rTmpChannel <= SIMPBUS_ADDR[8:5];
									rState <= 17; // Queue a transfer
								end
								else if (SIMPBUS_WDATA[30]) begin // Zero length, doorbell set
									rChannel <= SIMPBUS_ADDR[8:5];
									rTmpChannel <= rChannel;
									rState <= 9; // Signal a doorbell
								end
								rBusDone <= 1;
							end
						end
						else if (SIMPBUS_ADDR[4:0] == 'hC || SIMPBUS_ADDR[4:0] == 'h1C) begin // DMA_INFO or INTR_INFO
							if (SIMPBUS_RNW) begin 
								rBramAddr <= SIMPBUS_ADDR>>2;
								rState <= 15; // Return the read data
							end
							else begin // Writes are ignored
								rBusDone <= 1;
								rState <= 30;
							end
						end
						else if (SIMPBUS_ADDR[4:0] == 'h18) begin // BUF_INFO
							if (SIMPBUS_RNW) begin 
								rChannel <= SIMPBUS_ADDR[8:5];
								rTmpChannel <= rChannel;
								rBufReqd <= 1;
								rData <= C_BUF_REQD_TIMEOUT;
								rState <= 23; // Get FPGA buffer info
							end
							else begin
								rChannel <= SIMPBUS_ADDR[8:5];
								rTmpChannel <= rChannel;
								rData <= ((SIMPBUS_WDATA>>5)<<5);
								rBufReqSize <= SIMPBUS_WDATA[4:0];
								rBufReqRdy <= 1;
								rBufReqErr <= (SIMPBUS_WDATA == 0);
								rBusDone <= 1;
								rState <= 13; // Restore channel
							end
						end
						else begin // Other read/write registers
							if (SIMPBUS_RNW) begin 
								rBramAddr <= SIMPBUS_ADDR>>2;
								rState <= 15; // Return the data
							end
							else begin
								rBramWEN <= 1;
								rBramAddr <= SIMPBUS_ADDR>>2;
								rData <= SIMPBUS_WDATA;
								rBusDone <= 1;
								rState <= 30;
							end
						end
					end
				end
				else if (DMA_QUEUE_DONE) begin // DMA finished.
					rDmaDoneAck <= 1;
					rTmpSignal <= DMA_QUEUE_SIGNAL;
					rTmpErr <= DMA_QUEUE_ERR;
					rChannel <= DMA_QUEUE_CHANNEL[4:1];
					rTmpChannel <= rChannel;
					if (DMA_QUEUE_CHANNEL[0]) begin // FPGA initiated transfer
						rDmaDone <= 1;
						rFifoIntrWEN <= (DMA_QUEUE_SIGNAL && !DMA_QUEUE_ERR);
						rData <= DMA_QUEUE_LEN[29:0];
						rState <= 13;  // Restore channel
					end
					else begin // PC initiated transfer
						rData <= (DMA_QUEUE_ERR<<31 | DMA_QUEUE_SIGNAL<<30 | DMA_QUEUE_LEN[29:0]); 
						rFifoDmaInfoWEN <= 1;
						rState <= 8; // Possible doorbell
					end
				end
				else if (DMA_REQ) begin // DMA request.
					rData <= DMA_SRC;
					rFifoDmaQWEN <= 1;
					rState <= 1; // Queue a transfer
				end
				else if (INTERRUPT) begin // Interrupt reqeust
					rFifoIntrWEN <= 1;
					rData <= (INTERRUPT_ERR<<31);
					rInterruptAck <= 1;
					rState <= 30;
				end
				else if (BUF_REQ) begin // Buf reqeust
					rFifoIntrWEN <= 1;
					rData <= (1<<30);
					rBufReqAck <= 1;
					rState <= 30;
				end
				else begin // Change channel & cycle through FIFOs.
					rChannel <= (rChannel == C_NUM_CHANNELS-1 ? 0 : rChannel + 1);
					rFifoTurn <= !rFifoTurn;
					if (rFifoTurn) begin
						rFifoIntrREN <= (!wFifoIntrEmpty);
						rState <= (!wFifoIntrEmpty ? 4 : 0); // Pull from INTR FIFO
					end
					else begin
						rFifoDmaInfoREN <= (!wFifoDmaInfoEmpty);
						rState <= (!wFifoDmaInfoEmpty ? 6 : 0); // Pull from DMA INFO FIFO
					end
				end
			end
			5'd1: begin // Push in the dst.
				rData <= DMA_DST;
				rState <= 2;
			end
			5'd2: begin // Push in the len.
				rData <= DMA_LEN;
				rState <= 3;
			end
			5'd3: begin // Push in the req.
				// req: { channel (4 bits) | core_initiated (1 bit) | signal (1 bit) }
				rData <= (rChannel<<28 | 1<<27 | DMA_SIG<<26);
				rDmaReqAck <= 1;
				rState <= 30;
			end
			5'd4: begin // Wait for FIFO reads.
				rFifoIntrREN <= 0;
				rState <= 5;
			end
			5'd5: begin //  Write FIFO INTR data to BRAM if possible.
				rData <= wFifoIntrDataOut[31:0];
				if (!rIntrVect[wFifoIntrDataOut[35:32]]) begin // OK to write INTR_INFO
					rBramWEN <= 1;
					rBramAddr <= (wFifoIntrDataOut[35:32]*8) + 7;
					rIntrVect <= (rIntrVect | 1<<wFifoIntrDataOut[35:32]);
					rState <= 30;
				end
				else begin // Pending interrupt, put back in FIFO
					rFifoIntrWEN <= 1;
					rChannel <= wFifoIntrDataOut[35:32];
					rTmpChannel <= rChannel;
					rState <= 13; // Restore channel
				end
			end
			5'd6: begin // Wait for FIFO DMA INFO read.
				rFifoDmaInfoREN <= 0;
				rState <= 7;
			end
			5'd7: begin //  Write FIFO DMA INFO data to BRAM.
				rData <= wFifoDmaInfoDataOut[31:0];
				if (!rIntrVect[16 + wFifoDmaInfoDataOut[35:32]]) begin // OK to write DMA_INFO
					rBramWEN <= 1;
					rBramAddr <= (wFifoDmaInfoDataOut[35:32]*8) + 3;
					rIntrVect <= (rIntrVect | 1<<(16 + wFifoDmaInfoDataOut[35:32]));
					rState <= 30;
				end
				else begin // Pending interrupt, put back in FIFO
					rFifoDmaInfoWEN <= 1;
					rChannel <= wFifoDmaInfoDataOut[35:32];
					rTmpChannel <= rChannel;
					rState <= 13; // Restore channel
				end
			end
			5'd8: begin // Set rData to DOORBELL_LEN for ring.
				rDmaDoneAck <= 0;
				rFifoDmaInfoWEN <= 0;
				rState <= (rTmpSignal && !rTmpErr ? 9 : 13); // Doorbell or done/restore channel
			end
			5'd9: begin // Read ARG_0.
				rBusDone <= 0;
				rData <= rData[29:0]; // Make sure only 30 bits for len.
				rBramWEN <= 0;
				rBramAddr <= (rChannel*8) + 4;
				rState <= 10;
			end
			5'd10: begin // Read ARG_1 and signal doorbell.
				rBramAddr <= (rChannel*8) + 5;
				rDoorbell <= 1;
				rDoorbellErr <= rTmpErr;
				rState <= 11;
			end
			5'd11: begin // Send ARG_0.
				rDoorbell <= 0;
				rData <= wBramDataOut;
				rState <= 12;
			end
			5'd12: begin // Send ARG_1.
				rData <= wBramDataOut;
				rState <= 13;
			end
			5'd13: begin // Restore the channel.
				rDmaDone <= 0;
				rDmaDoneAck <= 0;
				rFifoDmaQWEN <= 0;
				rFifoIntrWEN <= 0;
				rFifoDmaInfoWEN <= 0;
				rBramWEN <= 0;
				rBusDone <= 0;
				rBufReqRdy <= 0;
				rChannel <= rTmpChannel;
				rState <= 30;
			end
			5'd14: begin // Wait for REG_INIT_DONE.
				rBusDone <= 0;
				if (REG_INIT_DONE) begin
					rRegInit <= 0;
					rState <= 30;
				end
			end
			5'd15: begin // Get requested data from BRAM.
				rState <= 16;
			end
			5'd16: begin // Return requested data from BRAM.
				rData <= wBramDataOut;
				rBusDone <= 1;
				rState <= 30;
			end
			5'd17: begin // Read the src.
				rBusDone <= 0;
				rBramAddr <= rBramAddr + 1;
				rBramWEN <= 0;
				rState <= 18;
			end
			5'd18: begin // Read the dst.
				rBramAddr <= rBramAddr + 1;
				rState <= 19;
			end
			5'd19: begin // Read the len, push in the src.
				rBramAddr <= rBramAddr - 2;
				rData <= wBramDataOut;
				rFifoDmaQWEN <= 1;
				rState <= 20;
			end
			5'd20: begin // Push in the dst.
				rData <= wBramDataOut;
				rState <= 21;
			end
			5'd21: begin // Push in the len.
				rData <= wBramDataOut[29:0];
				rState <= 22;
			end
			5'd22: begin // Push in the req.
				// req: { channel (4 bits) | core_initiated (1 bit) | signal (1 bit) }
				rData <= (rTmpChannel<<28 | rTmpSignal<<26);
				rState <= 30;
			end
			5'd23: begin // Wait for BUF_REQD_RDY.
				if (BUF_REQD_RDY || rData == 0) begin
					rBufReqd <= 0;
					rData <= (BUF_REQD_ERR || rData == 0 ? 0 : ((BUF_REQD_ADDR>>5)<<5 | BUF_REQD_SIZE));
					rBusDone <= 1;
					rState <= 13;
				end
				else begin
					rData <= rData - 1;
				end
			end
			5'd30: begin // Reset
				rInterruptAck <= 0;
				rBramWEN <= 0;
				rFifoDmaQWEN <= 0;
				rFifoDmaInfoWEN <= 0;
				rFifoIntrWEN <= 0;
				rFifoDmaInfoREN <= 0;
				rFifoIntrREN <= 0;
				rIntrClear <= 0;
				rBusDone <= 0;
				rDmaDoneAck <= 0;
				rDoorbell <= 0;
				rDoorbellErr <= 0;
				rDmaReqAck <= 0;
				rDmaDone <= 0;
				rBufReqAck <= 0;
				rBufReqRdy <= 0;
				rBufReqErr <= 0;
				rBufReqd <= 0;
				rState <= 31;
			end
			5'd31: begin // Pause a cycle before repeating.
				rState <= 0;
			end
			default: begin
				rState <= 0;
			end
		endcase
	end
end

/*
wire [35:0] wControl0;

chipscope_icon cs_icon(
	.CONTROL0(wControl0)
);
//chipscope_ila_128 a0(.CLK(SYS_CLK), .CONTROL(wControl0), .TRIG0({2'd0, rIntrClear, (rIntrVect[31:16] != 0), (rIntrVect[15:0] != 0), DMA_QUEUE_DONE, DMA_REQ, BUF_REQ, INTERRUPT, rTmpSignal, rTmpErr, rTmpChannel, SIMPBUS_ERR, SIMPBUS_DONE, SIMPBUS_START, SIMPBUS_RNW, SIMPBUS_BE, SIMPBUS_RDATA, SIMPBUS_WDATA, SIMPBUS_ADDR, rChannel, rState}));
chipscope_ila_128 a0(.CLK(SYS_CLK), .CONTROL(wControl0), .TRIG0({wFifoIntrEmpty, INTR_REQ, rIntrClear, (rIntrVect[31:16] != 0), (rIntrVect[15:0] != 0), DMA_QUEUE_DONE, DMA_REQ, BUF_REQ, INTERRUPT, rTmpSignal, rTmpErr, rTmpChannel, SIMPBUS_ERR, SIMPBUS_DONE, SIMPBUS_START, SIMPBUS_RNW, SIMPBUS_BE, SIMPBUS_RDATA, SIMPBUS_WDATA, SIMPBUS_ADDR, rChannel, rState}));
 
//chipscope_ila_128 a0(.CLK(SYS_CLK), .CONTROL(wControl0), .TRIG0({1'd0, rTmpSignal, rTmpErr, rTmpChannel, rFifoDmaQWEN, wBramDataOut, rBramWEN, rBramAddr, rRegInitNum, REG_INIT_DONE, rRegInit, rIntrClear, rIntrVect, rData, rChannel, rState}));
//chipscope_ila_128 a0(.CLK(SYS_CLK), .CONTROL(wControl0), .TRIG0({19'd0, rTmpSignal, rTmpErr, rTmpChannel, BUF_REQD_ERR, BUF_REQD_RDY, BUF_REQD_SIZE, BUF_REQD_ADDR, rBufReqd, rBufReqErr, rBufReqRdy, rBufReqSize, BUF_REQ, rDoorbellErr, rDoorbell, rInterruptAck, INTERRUPT_ERR, INTERRUPT, DMA_QUEUE_CHANNEL, DMA_QUEUE_ERR, DMA_QUEUE_SIGNAL, rDmaDoneAck, DMA_QUEUE_DONE, rData, rChannel, rState}));
//chipscope_ila_128 a0(.CLK(SYS_CLK), .CONTROL(wControl0), .TRIG0({14'd0, rTmpSignal, rTmpErr, rTmpChannel, 1'd0, rDmaDone, DMA_SIG, DMA_LEN, DMA_SRC, DMA_SRC, rDmaReqAck, DMA_REQ, rChannel, rState}));

//chipscope_ila_1 a0(.CLK(SYS_CLK), .CONTROL(wControl0), .TRIG0({1'd0}));
*/

endmodule
